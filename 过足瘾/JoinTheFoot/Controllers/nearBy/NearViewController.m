//
//  NearViewController.m
//  JoinTheFoot
//
//  Created by skd on 16/6/27.
//  Copyright © 2016年 lzm. All rights reserved.
//

#import "NearViewController.h"
#import "MyCollectionViewCell.h"
#import "MyTableViewCell.h"
#import "DPModel.h"
#import "AdvHeaderView.h"
#import "AdvViewController.h"
#import "JSDetailViewController.h"
#define list_API @"http://gzy.api.kd52.com/member.aspx?action=getneartech2"
#define shop_list @"http://gzy.api.kd52.com/shop.aspx?action=getnearshop"
#import "JSModel.h"
@interface NearViewController () <UICollectionViewDataSource , UICollectionViewDelegateFlowLayout ,UICollectionViewDelegate ,UITableViewDataSource , UITableViewDelegate , UIScrollViewDelegate>
{
    NSInteger _JSpage;
    NSInteger _DPpage;
    NSInteger _type;

}
@property (weak, nonatomic) IBOutlet UISegmentedControl *segement;
@property (weak, nonatomic) IBOutlet UIView *segementBgView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, weak)  AdvHeaderView  * advheaderview;

//存放技师模型
@property (nonatomic , strong) NSMutableArray *items;
//存放门店模型
@property (nonatomic , strong) NSMutableArray *datasource;

@end

@implementation NearViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    tabbarHidden(NO)
   }

- (NSMutableArray *)items
{
    if (!_items) {
        _items = [NSMutableArray array];
        _datasource = [NSMutableArray array];
    }
    return _items;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setNavigation];//设置导航按钮
    [self _initCollectionViewAndSetSegement];//设置collection和segement
    [self _setTableView];//设置表视图
//    自动刷新
    [self.collectionView.mj_header beginRefreshing];

}
#pragma mark -设置导航
- (void)_setNavigation
{
    [self setTopView:@"过足瘾"];
    [self setLeftItem:nil OrImage:@"技师列表_侧边"];
    self.leftAct = ^(UIButton *leftBtn){
        
        AppDelegate *del =  [UIApplication sharedApplication].delegate;
        WDRootViewController *root = (WDRootViewController *)del.window.rootViewController;
        [root.mianTabBar panAction:nil];
    };
    [self setRightItem:nil OrImage:@"技师列表_查询"];
    self.rightAct = ^(UIButton *rightBtn){
        
        
    };


}

#pragma mark - 设置表视图
- (void)_setTableView
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    设置表视图的行高 为让表视图 自适应
    _tableView.rowHeight = UITableViewAutomaticDimension;
//    评估预设高度
    _tableView.estimatedRowHeight = 40;
//    注册cell
    [_tableView registerNib:[UINib nibWithNibName:@"MyTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
//自定义了一个 表视图的 headerView（自已定义view）
    AdvHeaderView *av = [[[NSBundle mainBundle] loadNibNamed:@"AdvHeaderView" owner:nil options:nil] firstObject];
//    表示图的headerview为自定义的headerview
    _tableView.tableHeaderView = av;
//    实现广告页面的bloc
    av.tapADV= ^(AdvModel *am)
    {
//    block启动之后该做的事情
        AdvViewController *avc = [[AdvViewController alloc]init];
        avc.model = am;
        [self.navigationController pushViewController:avc animated:YES];
    
    };
    self.advheaderview = av;
//    调用了自定义headerview的一个API（这个api是自定义的headview  去加载网络 拿到广告图片和广告内容）
    [av setAdvertismentWithUrl:@"http://gzy.api.kd52.com/shop.aspx?action=getnearad" pragram:nil];//(M-V-VM  M-V-C)
    
    //    集成下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        //        网络加载动作
        //        让当前页数  回到第一页
        _DPpage = 1;
        //        重新加载网络
        [self getDataFromNetWork:2];
        
    }];
    
    //    集成上拉刷新
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //        让页码增加1
        _DPpage ++;
        //        发起网络请求
        [self getDataFromNetWork:2];
    }];


}

- (void)_initCollectionViewAndSetSegement
{

    self.segementBgView.backgroundColor = mian_color;
    [self.segement setTintColor:[UIColor whiteColor]];
    self.segement.selectedSegmentIndex = 0;
//    监听 segement 事件
    [self.segement addTarget:self action:@selector(segementAction:) forControlEvents:UIControlEventValueChanged];

    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = bg_color;
    _JSpage = 1; //记录当前页数
    [_collectionView registerNib:[UINib nibWithNibName:@"MyCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"myCell"];
    
//    集成下拉刷新
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
//        网络加载动作
//        让当前页数  回到第一页
        _JSpage = 1;
//        重新加载网络
        [self getDataFromNetWork:1];
        
    }];
    
//    集成上拉刷新
    _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        让页码增加1
        _JSpage ++;
//        发起网络请求
        [self getDataFromNetWork:1];
    }];

}


#pragma mark - 网络请求
//列表数据请求
- (void)getDataFromNetWork:(NSInteger)dataType
{
//    1:准备一个作为接口调用参数的 字典
    NSMutableDictionary *pragram = [NSMutableDictionary dictionary];
//    设置相关参数
    [pragram setObject:@1 forKey:@"appid"];
    [pragram setObject:@22.535868 forKey:@"latitude"];
    [pragram setObject:@113.950943 forKey:@"longitude"];
    [pragram setObject:@"BCCFFAAB6A7D79D1E6D1478F2B432B83CD451E2660F067BF" forKey:@"memberdes"];
//    标示当前页
    [pragram setObject:[NSNumber numberWithInteger:dataType == 1?_JSpage:_DPpage]forKey:@"page"];
//    表示每一页显示多少条数据
    [pragram setObject:@10 forKey:@"size"];
//    1表示技师  2 表示店铺
    [pragram setObject:[NSNumber numberWithInteger:1] forKey:@"type"];
    
//    如果是店铺接口 需要增加3个参数。
    if (dataType == 2) {
        [pragram setObject:@"1" forKey:@"checktype"];
        [pragram setObject:@"中国广东" forKey:@"detailaddr"];
        [pragram setObject:@"深圳市南山区" forKey:@"position"];
    }
    
    [WDHttpRequest postWithURL:dataType==1?list_API:shop_list pragram:pragram completion:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        if (!error) {
//            解析数据
             NSArray *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            if (dataType == 1) {
                //            判断当前是否是  下拉刷新
                if ([_collectionView.mj_header isRefreshing]) {
                    //                清理所有的数据源数据
                    [self.items removeAllObjects];
                    [_collectionView reloadData];
                }
                //            让头和尾全部停止刷新
                [_collectionView.mj_header endRefreshing];
                [_collectionView.mj_footer endRefreshing];
                //解析字典  封装模型
                for (NSDictionary *temDic in dic) {
                    JSModel *jsm = [[JSModel alloc]initWithDic:temDic];
                    [self.items addObject:jsm];
                }
                //            重读数据
                [_collectionView reloadData];
            }else if (dataType == 2)
            {
            
                if ([_tableView.mj_header isRefreshing]) {
                    [self.datasource removeAllObjects];
                    [_tableView reloadData];
                }
                //            让头和尾全部停止刷新
                [_tableView.mj_header endRefreshing];
                [_tableView.mj_footer endRefreshing];
                
                //解析字典  封装模型
                for (NSDictionary *temDic in dic) {
                    DPModel *jsm = [[DPModel alloc]initWithDic:temDic];
                    [self.datasource addObject:jsm];
                }
                //            重读数据
                [_tableView reloadData];
                
            }
            

        }else
        {
        
//        错误提示
        }
       
    }];

}
#pragma mark - segement事件
- (void)segementAction:(UISegmentedControl *)sengement
{

    NSInteger selecteIndex = sengement.selectedSegmentIndex;
    if (selecteIndex == 0) {
        _tableView.hidden = YES;
        _collectionView.hidden = NO;
        [_collectionView.mj_header beginRefreshing];
    }else
    {
        _tableView.hidden = NO;
        _collectionView.hidden = YES;
        [_tableView.mj_header beginRefreshing];
    
    }

}


#pragma collection代理

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{


    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    
    JSModel *jsm = self.items[indexPath.row];
    cell.jsModel = jsm;
    return cell;

}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    CGSize size = CGSizeMake(kScreen_W / 2 - 20, kScreen_W / 2);
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return (UIEdgeInsets){10,10,10,10};

}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    取到当前点击的item对应模型
    JSModel *currenModel = self.items[indexPath.row];
//创建控制器
    JSDetailViewController *jsDetailVC = [[JSDetailViewController alloc]init];
//    传值
    jsDetailVC.jsModel = currenModel;
//    push
    [self.navigationController pushViewController:jsDetailVC animated:YES];

}


#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.datasource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    DPModel *dm = self.datasource[indexPath.row];
    cell.dpModel = dm;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{


}
@end

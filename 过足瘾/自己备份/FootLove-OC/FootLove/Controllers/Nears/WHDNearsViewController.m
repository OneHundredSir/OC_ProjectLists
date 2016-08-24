//
//  WHDNearsViewController.m
//  FootLove
//
//  Created by HUN on 16/6/27.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDNearsViewController.h"

//设置collection的头文件
#import "WHDJSModel.h"
#import "WHDNearsCollectionViewCell.h"

//设置tableview的头文件
#import "WHDADShowView.h"
#import "WHDDPModel.h"
#import "WHDNearsTableViewCell.h"

//跳转的页面
#import "JSdetailHeaderView.h"
#import "WHDShopViewController.h"

@interface WHDNearsViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UISegmentedControl *mySegment;

@property (weak, nonatomic) IBOutlet UIView *segBackView;

//其他用途
@property(nonatomic,assign)NSInteger pageNum;
@property(nonatomic,assign)NSInteger TpageNum;

//设置collection
//模型数据
@property (weak, nonatomic) IBOutlet UICollectionView *myColloction;
@property(nonatomic,strong)NSMutableArray *jsModels;

//设置tableView
@property (weak, nonatomic) UITableView *myTableView;

//模型数据
@property(nonatomic,strong)NSMutableArray *dpModels;

//广告数据
@property(nonatomic,weak)WHDADShowView *myAdView ;
@property(nonatomic,strong)NSMutableArray *adUrlImgs;
@property(nonatomic,strong)NSMutableArray *adshopIds;
@end

@implementation WHDNearsViewController
#pragma mark lazyload
-(NSMutableArray *)adUrlImgs
{
    if (_adUrlImgs) {
        return _adUrlImgs;
    }
    _adUrlImgs = [NSMutableArray array];
    return _adUrlImgs;
}

-(NSMutableArray *)jsModels
{
    if (_jsModels) {
        return _jsModels;
    }
    _jsModels = [NSMutableArray array];
    return _jsModels;
}

//广告部分两个
-(NSMutableArray *)dpModels
{
    if (_dpModels) {
        return _dpModels;
    }
    _dpModels = [NSMutableArray array];
    return _dpModels;
}
-(NSMutableArray *)adshopIds
{
    if (_adshopIds) {
        return _adshopIds;
    }
    _adshopIds = [NSMutableArray array];
    return _adshopIds;
}

#pragma mark - 视图加载
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setViewTitle:@"过足瘾"];

    [self _initItem];
    //    自动刷新
    [self.myColloction.mj_header beginRefreshing];
    
    
}

#pragma mark - 视图释放
-(void)dealloc
{
    //把定时器关了
    [_myAdView.timer invalidate];
    _myAdView.timer = nil;
}

#pragma mark - 初始化设置页面
-(void)_initItem
{
    
    //设置segment
    [_mySegment setTintColor:[UIColor whiteColor]];
    _segBackView.backgroundColor = W_BackColor;
    [_mySegment addTarget:self action:@selector(segementAction:) forControlEvents:UIControlEventValueChanged];
    
    
    //设置collection
    [_myColloction registerNib:[UINib nibWithNibName:@"WHDNearsCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"Cell"];
    _myColloction.backgroundColor = W_viewColor;
    
    [self whdSetCollectionRefresh];
    
    //由于自己用了代码创建tableView，scrollview的那个顶出来的代码打出来
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    //设置广告
    [self whdLoadAd];//读取广告的数据
    //由于加载图片的时候线程就完成了～坑爹～所以加载玩图片才出来
    CGRect adRect = self.view.frame;
    adRect.origin.y = 50;//这是上面那个view的
    adRect.size.height = 120;
    WHDADShowView *adView = [[WHDADShowView alloc]initWithFrame:adRect];
    [self.view addSubview:adView];
    _myAdView = adView;
    
    //设置tableView
    CGRect tbRect = self.view.frame;
    tbRect.origin.y = adRect.origin.y + adRect.size.height;
    tbRect.size.height = self.view.frame.size.height - adRect.size.height;
    UITableView *table = [[UITableView alloc]initWithFrame:tbRect style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    _myTableView = table;
    [_myTableView registerNib:[UINib nibWithNibName:@"WHDNearsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    //
    _myTableView.rowHeight = 80;
//    _myTableView.estimatedRowHeight = 80;
    if (_mySegment.selectedSegmentIndex == 0) {
        [self setTableViewIsShow:NO andColloctionViewIsShow:NO];
    }
//    [self whdSetTableViewRefresh];
    [self setTableViewIsShow:NO andColloctionViewIsShow:YES];
}

#pragma mark - 广告加载
-(void)whdLoadAd
{
    //设置请求table数据
    NSString *urlStr = @"http://gzy.api.kd52.com/shop.aspx?action=getnearad";
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    [dic setObject:@1 forKey:@"appid"];
    [dic setObject:@22.535885 forKey:@"latitude"];
    [dic setObject:@113.950966 forKey:@"longitude"];
    [dic setObject:@"F55B38250E5CF1AB8A43568EED88E83AFA2186030A5158FC7EADB78DD436E8A5" forKey:@"memberdes"];
    
    
    [WHDHttpRequest  whdReuqestActionWith:urlStr and:dic andCompletion:^(NSData *wdata, NSURLResponse *wresponse, NSError *werror) {
        //数据就转出来
        //下面数组就是装这模型的字典数据
        NSDictionary *showDic =[NSDictionary dictionary];
        if (wdata) {
            showDic = [NSJSONSerialization JSONObjectWithData:wdata options:NSJSONReadingMutableContainers error:nil];
        }else
            showDic = @{@"item":@[]};
        
        NSArray *arr = showDic[@"item"];
//                NSLog(@"--广告数据:%d -->,%@",_TpageNum,arr);//测试用的
        //            把数据转成模型再存起来
        for (NSDictionary *modelDic in arr) {
            NSString *imgUrl = modelDic[@"image_path"];
//            NSLog(@"%@",imgUrl);
            [self.adUrlImgs addObject:imgUrl];
//            NSLog(@"%d",self.adUrlImgs.count);
            //把店铺的id放进去给另外一页使用
            [self.adshopIds addObject:modelDic[@"shop_id"]];
        }
        if (self.adUrlImgs > 0)
        {
//            NSLog(@"广告数目%d",self.adUrlImgs.count);
            [_myAdView initwhdSetAdViewWithImgUrlArr:self.adUrlImgs];
            _myAdView.btnBlock = ^(UIButton *btn){
                NSInteger index = btn.tag - 10;
                WHDShopViewController *vc =[WHDShopViewController new];
                vc.view.frame = CGRectMake(0, 0, W_width, W_height);
                vc.shopId = self.adshopIds[index];
                [self.navigationController pushViewController:vc animated:YES];
            };
        }
        
        if (werror) {
            NSLog(@"啦啦啦发生错误了....%@",werror);
        }
    }];
}

#pragma mark - 设置tableView的MJ刷新部分
/**
 *  设置tableView的MJ刷新
 */

-(void)whdSetTableViewRefresh
{
    //加载时候第一个刷新，下拉刷新
    _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //只要一下啦刷新就重新来，把所有数据都删除
        _TpageNum = 1;
        if ([_myTableView.mj_header isRefreshing]) {
            //                清理所有的数据源数据
            [self.dpModels removeAllObjects];
            [self whdPostTableMessage];
        }
        
    }];
    
    
    //上啦刷新的时候把页面加上
    _myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _TpageNum++;
        [self whdPostTableMessage];
    }];
}

/**
 *  数据加载内容
 */
-(void)whdPostTableMessage
{
    //设置数据常量
    _TpageNum  = _TpageNum?_TpageNum:1;
    
    //设置请求table数据
    NSString *urlStr = @"http://gzy.api.kd52.com/shop.aspx?action=getnearshop";
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    [dic setObject:@1 forKey:@"appid"];
    [dic setObject:@22.535858 forKey:@"latitude"];
    [dic setObject:@113.950928 forKey:@"longitude"];
    [dic setObject:@"true" forKey:@"checktype"];
    [dic setObject:[NSNumber numberWithInteger:_TpageNum] forKey:@"page"];
    [dic setObject:@"广东省,深圳市,南山区" forKey:@"position"];
    [dic setObject:@20 forKey:@"size"];
    [dic setObject:@1 forKey:@"type"];
    
    
    [WHDHttpRequest  whdReuqestActionWith:urlStr and:dic andCompletion:^(NSData *wdata, NSURLResponse *wresponse, NSError *werror) {
        //数据加载完，把刷新结束
        [_myTableView.mj_header endRefreshing];
        [_myTableView.mj_footer endRefreshing];
        
        //数据就转出来
        //下面数组就是装这模型的字典数据
        NSArray *arr = [NSArray array];
        if (wdata) {
            arr = [NSJSONSerialization JSONObjectWithData:wdata options:NSJSONReadingMutableContainers error:nil];
        }else
        {
            NSLog(@"没有加载到数据，可能没有网络咯....");
            arr = nil;
        }
        
//                NSLog(@"--tableView数据:%d -->,%@",_TpageNum,arr);//测试用的
        //            把数据转成模型再存起来
        for (NSDictionary *modelDic in arr) {
            WHDDPModel *model = [WHDDPModel setModelValuesWithDictionary:modelDic];
            [self.dpModels addObject:model];
        }
        [_myTableView reloadData];
        if (werror) {
            NSLog(@"啦啦啦发生错误了....%@",werror);
        }
    }];
}

#pragma mark - tableView
#pragma mark delegate
/**
 *  选中cell的使用方法
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WHDShopViewController *vc =[WHDShopViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark datasource
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"这是加载数据时候的模型数目  :  %d",self.dpModels.count);
    return self.dpModels.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WHDNearsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
//    NSLog(@"这是加载 CELL  时候的模型数目  :  %d",self.dpModels.count);
    if (self.dpModels.count != 0) {//这句话没有明白
        cell.model = self.dpModels[indexPath.row];
    }
    
    return cell;
}


#pragma mark - 设置collection的MJ刷新部分
/**
 *  设置collection的MJ刷新
 */

-(void)whdSetCollectionRefresh
{
    //加载时候第一个刷新，下拉刷新
    _myColloction.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //只要一下啦刷新就重新来，把所有数据都删除
        _pageNum = 1;
        [self.jsModels removeAllObjects];
        [self whdPostMessage];
    }];
    
    
    //上啦刷新的时候把页面加上
    _myColloction.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageNum++;
        [self whdPostMessage];
    }];
}

/**
 *  数据加载内容
 */
-(void)whdPostMessage
{
    //设置数据常量
    _pageNum  = _pageNum?_pageNum:1;
    
    //设置请求数据
    NSString *urlStr = @"http://gzy.api.kd52.com/member.aspx?action=getneartech2";
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    [dic setObject:@1 forKey:@"appid"];
    [dic setObject:@22.535858 forKey:@"latitude"];
    [dic setObject:@113.950928 forKey:@"longitude"];
    [dic setObject:@"F55B38250E5CF1AB1DBE62C2CE8061C14C6963F829B875454AB80" forKey:@"memberde"];
    [dic setObject:[NSNumber numberWithInteger:_pageNum] forKey:@"page"];
    [dic setObject:@20 forKey:@"size"];
    [dic setObject:@1 forKey:@"type"];
    
    [WHDHttpRequest  whdReuqestActionWith:urlStr and:dic andCompletion:^(NSData *wdata, NSURLResponse *wresponse, NSError *werror) {
        //数据加载完，把刷新结束
        [_myColloction.mj_header endRefreshing];
        [_myColloction.mj_footer endRefreshing];
        if (werror) {
            NSLog(@"啦啦啦发生错误了....%@",werror);
        }else
        {
            //数据就转出来
            //下面数组就是装这模型的字典数据
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:wdata options:NSJSONReadingMutableContainers error:nil];
            //        NSLog(@"--colloctionView数据：page:%d -->,%@",_pageNum,arr);//测试用的
            //            把数据转成模型再存起来
            for (NSDictionary *modelDic in arr) {
                WHDJSModel *model = [WHDJSModel setModelValuesWithDictionary:modelDic];
                [self.jsModels addObject:model];
            }
            [_myColloction reloadData];
        }
    }];
}

#pragma mark - segement的方法，监听值变化
/**
 *  segement的方法，监听值变化
 */
-(void)segementAction:(UISegmentedControl *)seg
{
    switch (seg.selectedSegmentIndex) {
            //一个隐藏一个显示
        case 0://技师
            [self setTableViewIsShow:NO andColloctionViewIsShow:YES];
            [self.dpModels removeAllObjects];
            [_myTableView reloadData];
            [self whdSetCollectionRefresh];
            [self whdPostMessage];
            [self.myColloction.mj_header beginRefreshing];
            break;
        case 1://店铺
            [self setTableViewIsShow:YES andColloctionViewIsShow:NO];
            [self.jsModels removeAllObjects];
            [_myColloction reloadData];
            [self whdSetTableViewRefresh];
            [self whdPostTableMessage];
            [self.myTableView.mj_header beginRefreshing];
            break;
        default:
            break;
    }
    
}

/**
 *  设置隐藏
 */
-(void)setTableViewIsShow:(BOOL)TIsShow andColloctionViewIsShow:(BOOL)CIsShow
{
    _myTableView.hidden = !TIsShow;
    _myAdView.hidden = !TIsShow;
    _myColloction.hidden = !CIsShow;
}


#pragma mark - colloction
#pragma mark delegate
/**
 *  选中cell的使用方法
 */
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    JSdetailHeaderView *JSDetailVC = [JSdetailHeaderView new];
    [self.navigationController pushViewController:JSDetailVC animated:YES];
}

#pragma mark datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.jsModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WHDNearsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.model = self.jsModels[indexPath.row];
    return cell;
}

#pragma mark layout
/**
 *  设置cell的尺寸
 */

static CGFloat magin = 10;
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat CellW = W_width/2.0 - magin*2;
//     NSLog(@"%lf",CellW);//打印高度测试用而已
    return (CGSize){ CellW , CellW};
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return (UIEdgeInsets){magin,magin,magin,magin};
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

@end

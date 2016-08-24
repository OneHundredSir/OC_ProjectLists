//
//  ShopViewController.m
//  Flower
//
//  Created by HUN on 16/7/7.
//  Copyright © 2016年 hundred Company. All rights reserved.
//
#define leftViewH k_height-49-64
#define bMargin 15
#define lMargin 10
//获取banner图片
#define imgUrl @"http://ec.htxq.net/rest/htxq/index/carousel"
#define ACell @"AtabCell"
#define BCell @"BtabCell"
#define btnCell @"btnCell"
#define index @"tableViewIndex"
#define tabArr @"tableViewDataArr"
#define Banner @"BannerView"

//精选
#define JXUrl @"http://ec.htxq.net/rest/htxq/index/jingList/"

//商城
#define SCUrl @"http://ec.htxq.net/rest/htxq/index/theme"


#import "ShopViewController.h"
#import "leftCell.h"
#import "BannerView.h"
#import "JXmodel.h"
#import "SCmodel.h"
#import "JFmodel.h"
#import "JXdetail.h"
#import "AtabCell.h"
#import "BtabCell.h"
#import "JXDetailVC.h"

@interface ShopViewController ()<UITableViewDelegate,UITableViewDataSource>

#pragma mark -  view
@property (weak, nonatomic) IBOutlet UITableView *sTableView;

@property (nonatomic,weak) UITableView *menuTabView;

@property (nonatomic,weak) UIView *bgView;

@property (nonatomic,strong) BannerView *banner;

@property (nonatomic,assign) CGFloat maxY;


#pragma mark -  data
@property (nonatomic,strong) NSMutableArray *tabDataArrA;

@property (nonatomic,strong) NSMutableArray *tabDataArrB;

@property (nonatomic,strong) NSMutableArray *taDataArrC;


@property (nonatomic,strong) NSMutableDictionary *tabDataDict;

@property(nonatomic,strong)NSMutableArray *leftDataArr;

@property (nonatomic,assign) NSInteger tag;

@property (nonatomic,assign) int JXpage;



@end

@implementation ShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _JXpage = 1;
    [self getDataFormNetA];
    [self getDataFromNetB];
     [self initMainUI];
    self.view.backgroundColor = mainColor;
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
       [self initleftUI];
    
}

#pragma mark - 初始化表和格数据源
- (NSMutableDictionary *)tabDataDict
{
    if (self.tabDataArrA == nil || _tabDataDict == nil) {
        //构造字典,默认显示第一个tableView
        _tabDataDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.tabDataArrA,tabArr,@1,index,nil];
    }
    return _tabDataDict;
    
}
- (NSMutableArray *)tabDataArrA
{
    if (!_tabDataArrA) {
        _tabDataArrA = [@[] mutableCopy];
        _tabDataArrB = [@[] mutableCopy];
        _taDataArrC = [@[] mutableCopy];
    }
    return _tabDataArrA;
}


#pragma mark - 网络获取数据
- (void)getDataFormNetA
{
    //~~~~~~~~~~~~~~~~~~~~~~
    //拼接页面路径
    NSString *strUrl = [NSString stringWithFormat:@"%@%d",JXUrl,_JXpage];
    NSLog(@"精选请求路径 %@",strUrl);
    [WHDHttpRequest ReuqestGetActionWithUrlString:strUrl and:nil andCompletion:^(NSData *wdata, NSURLResponse *wresponse, NSError *werror) {
        if (!werror) {
            //~~~~~~~~~~~~~~~~~~~~~~
            //如果是头刷新则重新加载数据
            if ([_sTableView.mj_header isRefreshing]) {
                [self.tabDataArrA removeAllObjects];
            }
            
            //~~~~~~~~~~~~~~~~~~~~~~
            //解析数据
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:wdata options:NSJSONReadingMutableContainers error:nil];
            NSArray *arr = dict[@"result"];
            for (NSDictionary *tempDict in arr) {
                JXmodel *model = [[JXmodel alloc]initWithDict:tempDict];
                [self.tabDataArrA addObject:model];
            }
            //~~~~~~~~~~~~~~~~~~~~~~
            //停止刷新头
            [_sTableView.mj_header endRefreshing];
            //~~~~~~~~~~~~~~~~~~~~~~
            //判断没有更多数据了(刷新尾)
            if (arr.count == 0) {
                [_sTableView.mj_footer endRefreshingWithNoMoreData];
            }else
            {
                [_sTableView.mj_footer endRefreshing];
            }
            [self.sTableView reloadData];
        }
        
    }];
    
}

- (void)getDataFromNetB
{
    //~~~~~~~~~~~~~~~~~~~~~~
    //请求网络
    [WHDHttpRequest ReuqestGetActionWithUrlString:SCUrl and:nil andCompletion:^(NSData *wdata, NSURLResponse *wresponse, NSError *werror) {
        if (!werror) {
            //~~~~~~~~~~~~~~~~~~~~~~
            //如果是头刷新则重新加载数据
            if ([_sTableView.mj_header isRefreshing]) {
                [self.tabDataArrB removeAllObjects];
//                [self.sTableView reloadData];
            }
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:wdata options:NSJSONReadingMutableContainers error:nil];
            NSArray *arr = dict[@"result"];
            for (NSDictionary *tempDict in arr) {
                SCmodel *model = [SCmodel mj_objectWithKeyValues:tempDict];
                [self.tabDataArrB addObject:model];
                
            }
            //~~~~~~~~~~~~~~~~~~~~~~
            //停止刷新
            [self.sTableView.mj_header endRefreshing];
            [self.sTableView.mj_footer endRefreshingWithNoMoreData];
            //刷新tab
            [self.sTableView reloadData];
        }
    }];
}





#pragma mark -  创建leftTableView的数据源
- (NSMutableArray *)leftDataArr
{
    if (!_leftDataArr) {
        _leftDataArr = [@[] mutableCopy];
        // 组title
        NSArray *groups = @[@"花植",@"课堂",@"杂物"];
        // 格子title
        NSArray *arr1 = @[@"鲜切花",@"一周一花"];
        NSArray *arr2 = @[@"兴趣课"];
        NSArray *arr3 = @[@"花器",@"工具",@"书籍",@"周边"];
        NSArray *arr = @[arr1,arr2,arr3];
        //保存到数组中
        for (int i = 0; i < groups.count; i++) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:groups[i],@"group",arr[i],@"cell",@0,@"isExpanded",nil];
            [_leftDataArr addObject:dict];
        }
        
    }
    return _leftDataArr;
}

#pragma mark - UI
- (void)initleftUI
{
    //~~~~~~~~~~~~~~~~~~~~~~
    //导航栏配置
     [self initleftTabView];
    //左边
    [self setLeftBtnIcon:@"menu" andLeftBtnSeletdIcon:nil];
    
    //遍历得到item的img
    UIButton *Mbtn = [self.navigationController.navigationBar subviews][3];
    self.navigationItem.leftBarButtonItem.tag = 110 + 1;
    __weak ShopViewController *shopVc = self;
    __weak UITableView  *tempTab = _menuTabView;
    self.leftBtnBlock = ^(UIButton *btn)
    {
        if (shopVc.navigationItem.leftBarButtonItem.tag - 110) {
            shopVc.navigationItem.leftBarButtonItem.tag = 110;
            [UIView animateWithDuration:0.38 animations:^{
            //旋转
                Mbtn.transform = CGAffineTransformMakeRotation(M_PI_2);
                shopVc.bgView.frame = CGRectMake(0, 0, k_width, leftViewH);
            }];
        }else
        {
            shopVc.navigationItem.leftBarButtonItem.tag = 110 + 1;
            [UIView animateWithDuration:0.38 animations:^{
                //旋转
                Mbtn.transform = CGAffineTransformIdentity;
                shopVc.bgView.frame = CGRectMake(0, -leftViewH, k_width, leftViewH);
            }];
            
            // ~~~~~~~~~~~~~~~~~~~~
            // 重置tableView
            for (NSMutableDictionary *dict in shopVc.leftDataArr) {
                [dict setValue:@0 forKey:@"isExpanded"];
            }
            [tempTab reloadData];
        }
        
    };
    
}

#pragma mark - 左边按钮点击后出现的View
- (void)initleftTabView
{
    //~~~~~~~~~~~~~~~~~~~~~~
    //背景,先隐藏
    UIView *bgView = [[UIView alloc]initWithFrame:(CGRect){0,-leftViewH,k_width,leftViewH}];
    _bgView = bgView;
    //背景颜色
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    //~~~~~~~~~~~~~~~~~~~~~~
    //tabView
    CGFloat tabH = bgView.frame.size.height - 64 -49;
    UITableView *leftTab = [[UITableView alloc]initWithFrame:(CGRect){0,64,k_width,tabH} style:UITableViewStyleGrouped];
    _menuTabView = leftTab;
    leftTab.delegate = self;
    leftTab.dataSource = self;
    leftTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    leftTab.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:leftTab];
    //注册
    [leftTab registerNib:[UINib  nibWithNibName:@"leftCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"leftCell"];
    
    //~~~~~~~~~~~~~~~~~~~~~~
    //下部分静态image
    UIView *line = [[UIView alloc]initWithFrame:(CGRect){0,CGRectGetMaxY(leftTab.frame),k_width,1}];
    line.backgroundColor = [UIColor grayColor];
    [bgView addSubview:line];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:(CGRect){(k_width-80)/2,CGRectGetMaxY(leftTab.frame)+12,80,49-24}];
    imgView.image = [UIImage imageNamed:@"l_regist.jpg"];
    [bgView addSubview:imgView];
}

#pragma mark - 主UI
- (void)initMainUI
{
    // ~~~~~~~~~~~~~~~~~~~~
    // tableView
    
    [_sTableView registerNib:[UINib nibWithNibName:ACell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ACell];
    [_sTableView registerNib:[UINib nibWithNibName:BCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BCell];
    
    //广告栏
    self.banner = [[NSBundle mainBundle] loadNibNamed:Banner owner:nil options:nil].firstObject;
    [self.banner getDataFromNet:imgUrl];
    __weak ShopViewController *tempVC = self;
    self.banner.btnBlock = ^(UIButton *btn)
    {
        [tempVC findTheTag:btn];
    };
    
    // ~~~~~~~~~~~~~~~~~~~~
    //刷新
    _sTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if ([_tabDataDict[index] intValue] == 1) {
            _JXpage = 1;
            [self getDataFormNetA];
        }else if([_tabDataDict[index] intValue] == 2)
        {
            [self getDataFromNetB];
        }else
        {
            [self.sTableView.mj_header endRefreshing];
        }
    }];
    
    _sTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
         int num = [self.tabDataDict[index] intValue];
       if (num == 1)
        {
            _JXpage++;
            [self getDataFormNetA];
        }else
        {
            [_sTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

#pragma mark - 判断btn的标记
- (void)findTheTag:(UIButton *)btn
{
    self.tag = btn.tag - 20;
    if (self.tag == 1)
    {
        [self.tabDataDict setObject:@1 forKey:index];
        [_sTableView.mj_header beginRefreshing];
        [self getDataFormNetA];
        
    }else if (self.tag == 2)
    {
        [self.tabDataDict setObject:@2 forKey:index];
        [_sTableView.mj_header beginRefreshing];
        [self getDataFromNetB];
        
    }else
    {
        [self.tabDataDict setObject:@3 forKey:index];
        [self.sTableView reloadData];
    }
    NSLog(@"点击第%ld个view",_tag);
}

#pragma mark - 表代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //如果是下拉视图
    if (tableView == _menuTabView) {
        return self.leftDataArr.count;
    }else
//        如果是主表
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _menuTabView) {
        //取到每个组
        NSDictionary *dict = self.leftDataArr[section];
        NSArray *arr = dict[@"cell"];
        int flag = [dict[@"isExpanded"] intValue];
        // ~~~~~~~~~~~~~~~~~~~~
        // 判读标记
        if (!flag) {
            return 0;
        }else
        {
            return arr.count;
        }
    }else
    {
        //获取字典中的标记
        int num = [self.tabDataDict[index] intValue];
        if (num == 1) {
            //返回“精选”cell的个数
            return self.tabDataArrA.count;
        }else if(num == 2)
        {
            //返回“商城”cell的个数
            return self.tabDataArrB.count;
        }else
            //返回"积分"cell的个数
            return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (tableView == _menuTabView) {
        leftCell *leftcell = [tableView dequeueReusableCellWithIdentifier:@"leftCell"];
        //取值
        NSMutableDictionary *dict = self.leftDataArr[indexPath.section];
        NSArray *arr = dict[@"cell"];
        NSString *title = arr[indexPath.row];
        leftcell.title.text = title;
        leftcell.title.font = font(13);
        return leftcell;
    }
    else
    {
        //获取字典中的标记
        int num = [self.tabDataDict[index] intValue];

        if (num == 1) {
            AtabCell *cell1 = [tableView dequeueReusableCellWithIdentifier:ACell];
            cell1.backgroundColor = [UIColor groupTableViewBackgroundColor];
            JXmodel *model = self.tabDataArrA[indexPath.row];
            cell1.model = model;
            return cell1;
        }else if(num == 2)
        {
            BtabCell *cell2 = [tableView dequeueReusableCellWithIdentifier:BCell];
            SCmodel *model = self.tabDataArrB[indexPath.row];
            cell2.model = model;
            return cell2;
            
        }else
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:btnCell];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:btnCell];
                cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [self createBtn:cell];
            }
            return cell;
        }
    }
}

#pragma mark - 积分动态创建btn
- (void)createBtn:(UITableViewCell *)cell
{
    CGFloat w = cell.contentView.frame.size.width;
    //~~~~~~~~~~~~~~~~~~~~~~
    //积分兑换规则
    UIButton *btn1 = [[UIButton alloc]initWithFrame:(CGRect){0,0,w,33}];
    [btn1 addTarget:self action:@selector(JFBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:btn1];
    
    UILabel *lblRude = [[UILabel alloc]initWithFrame:(CGRect){bMargin,lMargin,0,0}];
    lblRude.text = @"积分兑换规则";
    lblRude.textColor = [UIColor blackColor];
    lblRude.font = font(14);
    [lblRude sizeToFit];
    [btn1 addSubview:lblRude];
    
    UIImageView *imgR = [[UIImageView alloc]initWithFrame:(CGRect){CGRectGetMaxX(cell.contentView.frame)-30,lMargin-6,30,30}];
    imgR.image = [UIImage imageNamed:@"u_right_40x40"];
    [btn1 addSubview:imgR];
    
    UIView *line = [[UIView alloc]initWithFrame:(CGRect){0,34,cell.contentView.frame.size.width,1}];
    line.backgroundColor = [UIColor grayColor];
    line.alpha = 0.7;
    [cell.contentView addSubview:line];
    
    //~~~~~~~~~~~~~~~~~~~~~~
    //每个Btn
    int num = 5;
    CGFloat Btnw = (w - lMargin - 2*bMargin)/2;
    CGFloat BtnH = 210;
    int row = 0;
    int col = 0;
    //创建
    for (int i = 0; i < num; i++) {
        row = i/2;
        col = i%2;
        //底层view
        UIView *bgview = [[UIView alloc]initWithFrame:(CGRect){(lMargin+Btnw)*col + bMargin, (lMargin + BtnH)*row + lMargin + 36, Btnw,BtnH}];
        bgview.backgroundColor = [UIColor whiteColor];
        UIButton *btn = [[UIButton alloc]initWithFrame:(CGRect){0,0,bgview.frame.size.width,bgview.frame.size.height}];
        [btn addTarget:self action:@selector(JFPriceAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 200+i+1;
        [bgview addSubview:btn];
        //~~~~~~~~~~~~~~~~~~~~~~
        //btn内部
        CGFloat allW = btn.frame.size.width;
        UIImageView *img = [[UIImageView alloc]initWithFrame:(CGRect){0,0,allW,allW}];
        img.image = [UIImage imageNamed:@"bgirl.jpg"];
        [btn addSubview:img];
        
        UILabel *lbl1 = [[UILabel alloc]initWithFrame:(CGRect){5,CGRectGetMaxY(img.frame)+1,Btnw,16}];
        lbl1.text = @"英文";
        lbl1.textColor = [UIColor blackColor];
        lbl1.font = font(14);
        [bgview addSubview:lbl1];
        
        UILabel *lbl2 = [[UILabel alloc]initWithFrame:(CGRect){5,CGRectGetMaxY(lbl1.frame),Btnw-5,40}];
        lbl2.text = @"这是花的名称daks圣诞节啊哈大家来";
        lbl2.numberOfLines = 0;
        lbl2.textColor = [UIColor blackColor];
        lbl2.font = font(14);
        [bgview addSubview:lbl2];
        
        UILabel *lbl3 = [[UILabel alloc]initWithFrame:(CGRect){5,CGRectGetMaxY(lbl2.frame)-5,Btnw,16}];
        lbl3.text = @"这是花的积分，比如积分100";
        lbl3.textColor = [UIColor blackColor];
        lbl3.font = font(12);
        [bgview addSubview:lbl3];
        
        [cell.contentView addSubview:bgview];
        if (i ==  num-1) {
            self.maxY = CGRectGetMaxY(bgview.frame);
        }
    }

    
}

#pragma mark - 积分按钮事件
- (void)JFBtnAction:(UIButton *)btn
{
    NSLog(@"积分");
}

- (void)JFPriceAction:(UIButton *)btn
{
    NSLog(@"%ld",btn.tag);
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == _menuTabView) {
        return 0.1;
    }else
    {
        return 0.1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _menuTabView) {
        return 72;
    }else
    {
        return 245;
    }
}

// ~~~~~~~~~~~~~~~~~~~~
// 每个section样式
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (tableView == _menuTabView) {
    //背景view
    UIView *hView = [[UIView alloc]initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, 50)];
    hView.backgroundColor=[UIColor whiteColor];
    //按钮
    UIButton* eButton = [[UIButton alloc] init];
    eButton.frame = hView.frame;
    [eButton addTarget:self action:@selector(expandButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //把节号保存到按钮tag，以便传递到expandButtonClicked方法
    eButton.tag = section;
    
    //根据是否展开，切换按钮显示图片
    
    if (![self isExpanded:section]){
        
        [eButton setImage: [UIImage imageNamed: @"hp_arrow_down" ]forState:UIControlStateNormal];
    } else {
        
        [eButton setImage: [UIImage imageNamed: @"hp_arrow_up" ]forState:UIControlStateNormal];
    }
    //设置分组标题
    [eButton setTitle:self.leftDataArr[section][@"group"] forState:UIControlStateNormal];
    eButton.titleLabel.font = font(12);
    [eButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //设置button的图片和标题的相对位置
    
    //4个参数是到上边界，左边界，下边界，右边界的距离
    eButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [eButton setTitleEdgeInsets:UIEdgeInsetsMake(22,-10, 0,0)];
    [eButton setImageEdgeInsets:UIEdgeInsetsMake(22,k_width - 120, 0,0)];
    [hView addSubview: eButton];
    
    return hView;
    }else
    {
        return self.banner;
    }

}

#pragma mark -  判断是否展开组
- (BOOL)isExpanded:(NSInteger)section
{
    NSMutableDictionary *dict = self.leftDataArr[section];
    int isExpanded = [dict[@"isExpanded"] intValue];
    return isExpanded;
}

#pragma mark -  section点击事件
- (void)expandButtonClicked:(UIButton *)btn
{
    NSInteger section = btn.tag;
    // ~~~~~~~~~~~~~~~~~~~~
    // 修改该点击组是否隐藏的标记,如果是则变成不是
    NSMutableDictionary *dict = self.leftDataArr[section];
    int isExpand = [dict[@"isExpanded"] intValue];
    if (isExpand) {
        [dict setValue:@0 forKey:@"isExpanded"];
    }else
        [dict setValue:@1 forKey:@"isExpanded"];
    
    // ~~~~~~~~~~~~~~~~~~~~
    // 刷新该组
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:section];
    [self.menuTabView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

//~~~~~~~~~~~~~~~~~~~~~~
//每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _menuTabView) {
        return 44;
    }else
    {
        //获取字典中的标记
        int num = [self.tabDataDict[index] intValue];
        if (num == 1) {
            return 260;
        }else if(num == 2)
        {
            return 360;
        }else
            return self.maxY;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //如果是点击了主表的cell
    if (tableView == _sTableView) {
        //取数据
        JXmodel *model = self.tabDataArrA[indexPath.row];
        JXDetailVC *vc = [[JXDetailVC alloc]init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

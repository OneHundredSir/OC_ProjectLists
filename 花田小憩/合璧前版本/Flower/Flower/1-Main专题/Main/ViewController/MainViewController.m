//
//  MainViewController.m
//  Flower
//
//  Created by HUN on 16/7/7.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "MainViewController.h"
#import "MenuView.h"
#import "MainTitleView.h"
#import "MainTableViewCell.h"
#import "MainTableModel.h"
#import "IdDetailViewController.h"
#import "MainDetailViewController.h"
#import "Top10VC.h"
@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>
/**
 *  左边菜单栏
 */
@property(nonatomic,strong)MenuView *menuView;

/**
 *  tableView
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 *  头部的view
 */
@property(nonatomic,strong)MainTitleView *mainTitleView;
/**
 *  头部view的按钮事件
 */
@property(nonatomic,copy)void (^titleBtn)(UIButton *btn);

//其他参数
@property(nonatomic,strong)NSMutableArray *leftmodels;

@property(nonatomic,strong)NSMutableArray *modelLists;

@end

@implementation MainViewController
{
    UIImageView *titleImg;
}
#pragma mark lazyload
-(MenuView *)menuView
{
    if (_menuView == nil) {
        _menuView = [[[NSBundle mainBundle] loadNibNamed:@"MenuView" owner:nil options:nil] lastObject];
    }
    return _menuView;
}



-(NSMutableArray *)leftmodels
{
    if (_leftmodels == nil) {
        _leftmodels = [NSMutableArray array];
    }
    return _leftmodels;
}

/**
 *  tableviewModels
 */
-(NSMutableArray *)modelLists
{
    if (_modelLists == nil) {
        _modelLists = [NSMutableArray array];
    }
    return _modelLists;
}

#pragma mark - 系统视图加载
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self getLeftmodelsList];//左边网络请求,UI都放在一起
    //    self.view.backgroundColor = [UIColor blackColor];
    [self _initWebRequest];
    [_tableView.mj_header beginRefreshing];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    
}

#pragma mark 设置网络请求以及tableView

-(void)_initWebRequest
{
    
    [_tableView registerNib:[UINib nibWithNibName:cellID bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellID];
    _tableView.separatorInset = (UIEdgeInsets){10,10,10,10};
    static NSInteger index = 0;
    //获取网络数据
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        index = 0;
        [self.modelLists removeAllObjects];
        [self tableViewWebLoadWithPage:index];
    }];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        index ++;
        [self tableViewWebLoadWithPage:index];
    }];
    
    
}

/**
 *  tableView网络请求
 */
-(void)tableViewWebLoadWithPage:(NSInteger)index
{
    NSMutableDictionary *paramters = [@{} mutableCopy];
    NSString *indexPage = [NSString stringWithFormat:@"%ld",(long)index];
    [paramters setObject:indexPage forKey:@"currentPageIndex"];
    [paramters setObject:@"5" forKey:@"pageSize"];
    [WHDHttpRequest getHomeListWithparamters:paramters andandCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {
        //数据加载完，把刷新结束
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing]; 
        if (!error) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSArray *arr = dic[@"result"];
//            NSLog(@"%@",arr);
            if (arr.count<=0) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }
            for (NSDictionary *result in arr) {
                MainTableModel *model = [MainTableModel mj_objectWithKeyValues:result];
                [self.modelLists addObject:model];
            }
            
            [_tableView reloadData];
            
        }else
        {
            NSLog(@"%@",error);
        }
    }];

}

#pragma mark - 初始化navigation左中右按钮
/**
 #1.获得专题的类型:(POST或者GET都行)
 http://m.htxq.net/servlet/SysCategoryServlet?action=getList
 
 解析信息如下
 {
	id : 79eb0990-3cfd-4d6f-aabd-93ba001d0076,
	createDate : 2015-09-17 10:00:16.0,
	order : 7,
	name : 家居庭院
 }
 */
static NSString *urlSrting = @"http://m.htxq.net/servlet/SysCategoryServlet?action=getList";
-(void)getLeftmodelsList
{
    [WHDHttpRequest ReuqestActionWithUrlString:urlSrting and:nil andCompletion:^(NSData *wdata, NSURLResponse *wresponse, NSError *werror) {
        if (wdata) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:wdata options:NSJSONReadingMutableContainers error:nil];
            
            NSArray *dicArr = dic[@"result"];
            //注意这里有几个key：id，createDate，order，name
//            NSLog(@"%@",dicArr);
            [self.leftmodels addObjectsFromArray:dicArr];
            
            [self _initLeftRightViewWithArr:self.leftmodels];
            
        }else
        {
            NSLog(@"发生错误:%@",werror);
        }
    }];
}

/**
 *  初始化左右边按钮
 */
-(void)_initLeftRightViewWithArr:(NSArray<NSString *> *)arr
{
    
    //设置左边
    [self setLeftBtnIcon:@"menu" andLeftBtnSeletdIcon:nil];
    //设置菜单栏
//    NSArray *arr = @[@"家具庭院",@"缤纷小物",@"奇葩之物",@"花田秘籍",@"跨界鉴赏",@"城市微光"];//测试用
    MenuView *menuView = self.menuView;
//    CGFloat menuY = k_navigationbarH+k_statusH;
    CGFloat menuH = k_height - k_tabbarH - k_navigationbarH - k_statusH ;
    CGFloat menuW = k_width;
    menuView.frame = (CGRect){0,-menuH,menuW,menuH};
//    NSLog(@"%@",NSStringFromCGRect(menuView.frame));
//    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    
    NSMutableArray *nameArr = [@[] mutableCopy];
    NSMutableArray *idArr = [@[] mutableCopy];
    for (NSDictionary *dicResult in arr)
    {
        //注意这里有几个key：id，createDate，order，name
        NSString *name = dicResult[@"name"];
        [nameArr addObject:name];
        
        NSString *idName = dicResult[@"id"];
        [idArr addObject:idName];
    }
    
    [menuView _setScrollViewWithTitleArray:nameArr];
    menuView.btnBlock = ^(UIButton *btn)
    {
        NSInteger index =  btn.tag-10;
        IdDetailViewController *vc = [IdDetailViewController new];
        vc.view.frame = self.view.frame;
        [vc setViewTitle:nameArr[index]];
        NSMutableDictionary *paramas = [@{} mutableCopy];
        [paramas setObject:idArr[index] forKey:@"action"];
        [paramas setObject:@"0" forKey:@"currentPageIndex"];
        [paramas setObject:@"5" forKey:@"pageSize"];
        vc.paramas = paramas;
        [self.navigationController pushViewController:vc animated:YES];
        

        
    };
//    menuView.center = (CGPoint){self.view.center.x,-self.view.center.y};
    [self.view addSubview:menuView];
    
    //联合设置菜单栏按钮事件
    self.leftBtnBlock = ^(UIButton *btn){
        btn.selected = !btn.selected;

        //设置位移事件，唯一问题就是设置按钮的宽度高度要一致
        [UIView animateWithDuration:0.3 animations:^{
            menuView.transform = btn.selected?CGAffineTransformMakeTranslation(0, menuH):CGAffineTransformIdentity;
            btn.transform = btn.selected?CGAffineTransformMakeRotation(M_PI/2.0):CGAffineTransformIdentity;
        }];
    };
    
    
    
    //设置顶部,使用的是自己重写的方法
    [self setViewTitle:@"专题"];
    CGFloat mainW = 100 ;
    CGFloat mainH = 50 ;
    CGFloat mainX = self.view.center.x - mainW/2.0;
//    CGFloat mainY = k_navigationbarH + k_statusH;
    NSArray *titlearr = @[@"文章",@"视频"];
    
    _mainTitleView = [[MainTitleView  new ] mainTitleViewInitWithTitleAcitonArr:titlearr andFrame:(CGRect){mainX,0,mainW,mainH}];
    [self.view addSubview:self.mainTitleView];
    _mainTitleView.alpha = 0;
    __weak typeof(_mainTitleView) weakView = _mainTitleView;
    __weak typeof(titleImg) weaktitleImg = titleImg;
    __weak typeof(self) weakSelf = self;
    self.titleBtn = ^(UIButton *btn)
    {
        btn.selected = !btn.selected;
        weaktitleImg.image =btn.selected? [UIImage imageNamed:@"hp_arrow_up"]:[UIImage imageNamed:@"hp_arrow_down"];
        weakView.alpha = btn.selected? 1:0;
        
        __weak typeof(btn) weakbtn = btn;
        weakView.btnBlock = ^(UIButton *btn)
        {
            
            NSInteger index =  btn.tag-10;
            IdDetailViewController *vc = [IdDetailViewController new];
            vc.view.frame = weakSelf.view.frame;
            [vc setViewTitle:nameArr[index]];
            NSMutableDictionary *paramas = [@{} mutableCopy];
            NSString *str = index?@"true":@"false";
            NSString *name = titlearr[index];
            [paramas setObject:str forKey:@"isVideo"];
            [paramas setObject:@"0" forKey:@"currentPageIndex"];
            [paramas setObject:@"5" forKey:@"pageSize"];
            [vc setViewTitle:name];
            vc.paramas = paramas;
            [weakSelf.navigationController pushViewController:vc animated:YES];

            weakView.alpha = 0;
            weaktitleImg.image = [UIImage imageNamed:@"hp_arrow_down"];
            weakbtn.selected = !weakbtn.selected;
        };

    };
    
    
    
    
    //设置右边
     [self setRightBtn:nil andTitle:@"Top"];
//    __weak typeof(self) weakSelf = self;
    self.rightBtnBlock = ^(UIButton *btn){
        Top10VC *top10Vc = [[Top10VC alloc]init];
        [top10Vc setViewTitle:@"本周排行TOP10"];
        [weakSelf.navigationController pushViewController:top10Vc animated:YES];
    };
}


#pragma mark 设置头部，重写父类方法
/** 设置顶部 */
-(void)setViewTitle:(NSString *)title
{
    CGSize fontSize = [title sizeWithFont:font(14) constrainedToSize:(CGSize){MAXFLOAT,44}];
    CGFloat imgWH = 10;
    CGFloat magin = 2;
    //通过字体大小设置大小再赋值
    CGFloat backViewW = fontSize.width+magin*3+imgWH;
    CGFloat backViewH = 44;
    
    CGFloat titleW = backViewW - magin*2 -imgWH ;
    
    CGFloat titleX = magin;
    
    CGFloat imgX = titleX + titleW +magin;
    CGFloat imgY = (backViewH-imgWH)/2.0;
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:(CGRect){0,0,backViewW,backViewH}];
    
    //图片
    titleImg = [[UIImageView alloc]initWithFrame:(CGRect){imgX,imgY,imgWH,imgWH}];
    titleImg.image = [UIImage imageNamed:@"hp_arrow_down"];
    [backgroundView addSubview:titleImg];
    
    //label
    UILabel *titleLB = [[UILabel  alloc]initWithFrame:(CGRect){titleX,0,titleW,backViewH}];
    titleLB.text = title;
    titleLB.textAlignment = NSTextAlignmentCenter;
    titleLB.textColor = [UIColor blackColor];
    titleLB.font=font(14);
    [backgroundView addSubview:titleLB];
    
    //按钮
    UIButton *btn = [[UIButton alloc]initWithFrame:backgroundView.frame];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:btn];
    
    self.navigationItem.titleView = backgroundView;
}


/**
 *  navigation头部的按钮
 */
-(void)btnAction:(UIButton *)btn
{
    if(self.titleBtn)
    {
        //回到上面用比较好看
        self.titleBtn(btn);
    }

}

#pragma mark - TableView
#pragma mark delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MainDetailViewController *detailVC = [MainDetailViewController new];
    detailVC.view.frame = self.view.frame;
    detailVC.model = self.modelLists[indexPath.row];
    [detailVC setViewTitle: detailVC.model.title];
    [self.navigationController pushViewController:detailVC animated:YES];
    
    
}


#pragma mark datasoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelLists.count;
}

static NSString *cellID = @"MainTableViewCell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.model = self.modelLists[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300;
}

@end

//
//  ExperienceVC.m
//  xiaorizi
//
//  Created by HUN on 16/6/1.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "ExperienceVC.h"
#import "WHDExCell.h"
#import "WHDExModel.h"

#define cellID @"WHDExCell"
@interface ExperienceVC ()<UITableViewDataSource,UITableViewDelegate>
#pragma mark tableview
@property (weak, nonatomic) IBOutlet UITableView *table;
#pragma mark 模型数组
@property(nonatomic,strong)NSMutableArray *model_list;


//设置广告条的属性,自动
#pragma mark scrollView
@property(nonatomic,strong)UIScrollView *scrollView;
#pragma mark 页面控制
@property(nonatomic,strong)UIPageControl *pageControl;
#pragma mark scroll数据数组
@property(nonatomic,strong)NSMutableArray *ardArr;
#pragma mark 定时器
@property(nonatomic,strong)NSTimer *autoScrollTimer;
#pragma mark 当前页
@property(nonatomic,assign)BOOL IsOn;
@end

@implementation ExperienceVC
#pragma mark - lazy load
//读取数据
-(NSMutableArray *)model_list
{
    [_table.mj_header endRefreshing];
    if (_model_list) {
        return _model_list;
    }
    _model_list=[@[] mutableCopy];
    

    //开始获取数据
    NSString *path=[[NSBundle mainBundle] pathForResource:@"Experience" ofType:nil];
    NSData *data=[NSData dataWithContentsOfFile:path];
    //把数据转成字典
    NSDictionary *dataDic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    //模型数据
    NSArray *modelArr=dataDic[@"list"];
    for (NSDictionary *dic in modelArr) {
        WHDExModel *model=[WHDExModel mj_objectWithKeyValues:dic];
        [_model_list addObject:model];
    }
    return _model_list;
}

-(NSMutableArray *)ardArr
{
    [_table.mj_header endRefreshing];
    if (_ardArr) {
        return _ardArr;
    }
    _ardArr=[@[] mutableCopy];
    
    
    //开始获取数据
    NSString *path=[[NSBundle mainBundle] pathForResource:@"Experience" ofType:nil];
    NSData *data=[NSData dataWithContentsOfFile:path];
    //把数据转成字典
    NSDictionary *dataDic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    //模型数据
    NSArray *modelArr=dataDic[@"head"];
    for (NSDictionary *dic in modelArr) {
        WHDExModel *model=[WHDExModel mj_objectWithKeyValues:dic];
        [_ardArr addObject:model];
    }
    return _ardArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _table.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_table reloadData];
    }];
    
    [self setUpView];
    
}

-(void)setUpView
{
    self.title=@"体验";
    [_table registerNib:[UINib nibWithNibName:cellID bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellID];
    //为什么用不了？
//        _table.estimatedRowHeight=1000;
//        _table.rowHeight=UITableViewAutomaticDimension;
    _table.rowHeight=220;
    [self makeUpScrollView];
}
#pragma mark - scrollView广告栏
-(void)makeUpScrollView
{
    
    //设置scrollview
    CGFloat scrollHeight=200;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, VIEWW, scrollHeight)];
    _scrollView.backgroundColor=[UIColor whiteColor];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(VIEWW * 3,scrollHeight);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.delegate = self;
    
    //设置分页
    CGFloat pageHeight=30;
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, scrollHeight-pageHeight, VIEWW, pageHeight)];
    _pageControl.userInteractionEnabled = NO;
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    _pageControl.pageIndicatorTintColor = [UIColor blueColor];
    [_pageControl addTarget:self action:@selector(pageChange:) forControlEvents:UIControlEventValueChanged];
    [_scrollView addSubview:_pageControl];
    
    //设置数据
    static int index=0;
    for (WHDExModel * model in self.ardArr) {
        UIButton *btn = [[UIButton alloc]initWithFrame:(CGRect){VIEWW*index,0,VIEWW,scrollHeight-pageHeight}];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.adurl]];
        [btn setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
        btn.tag = index+50;
        [btn addTarget:self action:@selector(jumpShow:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn];
        index++;
    }
    _pageControl.numberOfPages=index;
    
    _table.tableHeaderView=_scrollView;
    _table.tableHeaderView.backgroundColor=[UIColor whiteColor];
    
    //设置定时器
    _autoScrollTimer=[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(timePlay:) userInfo:nil repeats:YES];
}
/**
 *  广告页面跳转
 */
-(void)jumpShow:(UIButton *)btn
{
    NSInteger num=btn.tag-50;
    WHDExModel * model=self.ardArr[num];
    WHDWebViewController *web=[[WHDWebViewController alloc]init];
    web.path=model.shareURL;
    web.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:web  animated:YES];
    
}


-(void)pageChange:(UIPageControl *)page
{
    NSLog(@"页面转了");
}

/**
 *  定时器
 */
-(void)timePlay:(id)time
{
    //获取当前的size
    CGPoint offPoint=_scrollView.contentOffset;
    if (offPoint.x>=(self.ardArr.count-1)*VIEWW) {
        offPoint.x=0;
    }else
    {
        offPoint.x+=VIEWW;//设置完就改
    }
    [_scrollView setContentOffset:offPoint animated:YES];
    
    //通过偏移量设置pagecontrol的位移还有当前点
    NSInteger num = offPoint.x/VIEWW;
    _pageControl.currentPage=num;
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{        //开始移动就关掉
    if (_autoScrollTimer) {
        [_autoScrollTimer invalidate];
        self.autoScrollTimer=nil;
    }
    NSLog(@"定时器暂停了");
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _autoScrollTimer=[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timePlay:) userInfo:nil repeats:YES];
    NSLog(@"又开始了");
}
/**
 *  scrollview代理翻转
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //获取当前的size
    CGPoint offPoint=_scrollView.contentOffset;
    
    //通过偏移量设置pagecontrol的位移还有当前点
    NSInteger num = offPoint.x/VIEWW;
    _pageControl.currentPage=num;
    CGRect pageRect=_pageControl.frame;
    pageRect.origin.x=offPoint.x;
    _pageControl.frame=pageRect;
}
/**
 *  scrollView拉完之后重新设置
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

/**
 *  设置读取data
 */
-(void)loadScroll:(BOOL)IsOn
{
    self.IsOn=YES;
    //获取当前的size
    CGPoint offPoint=_scrollView.contentOffset;
    
    //通过偏移量设置pagecontrol的位移还有当前点
    NSInteger num = offPoint.x/VIEWW;
    _pageControl.currentPage=num;
    CGRect pageRect=_pageControl.frame;
    pageRect.origin.x=offPoint.x;
    _pageControl.frame=pageRect;
}

#pragma mark scrollerview；

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - tableViewdatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return _model_list.count;
    return self.model_list.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WHDExCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
//    cell.backgroundColor=[UIColor redColor];
    cell.model=self.model_list[indexPath.row];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark - tableDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WHDExModel * model=self.model_list[indexPath.row];
    WHDWebViewController *web=[[WHDWebViewController alloc]init];
    web.path=model.shareURL;
    web.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:web  animated:YES];
}

@end

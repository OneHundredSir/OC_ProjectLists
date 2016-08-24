//
//  FoundShopVC.m
//  xiaorizi
//
//  Created by HUN on 16/6/1.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "FoundShopVC.h"

#import "WHDFirCell.h"
#import "WHDFirRowCell.h"

#import "WHDFirModel.h"
#import "WHDFirRowModel.h"
@interface FoundShopVC ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,weak)UIButton *leftBtn;
@property(nonatomic,weak)UIButton *rightBtn;
@property(nonatomic,weak)CALayer *lineLayer;

@property(nonatomic,strong)UIScrollView *scroll;
//第一个页面的数据
@property(nonatomic,strong)NSMutableArray *firModel_list;

//第二个页面的数据
@property(nonatomic,strong)NSMutableArray *SecModel_list;

@end

@implementation FoundShopVC

#pragma mark - lazy load
-(NSMutableArray *)firModel_list
{
    if (_firModel_list) {
        return _firModel_list;
    }
    _firModel_list=[@[] mutableCopy];
    NSString *path=[[NSBundle mainBundle]pathForResource:@"events" ofType:nil];
    //把JSON数据转换成字典
    NSData *data=[NSData dataWithContentsOfFile:path];
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    //获取字典中的数组
    NSArray *getArr=dic[@"list"];
    for (NSDictionary *realDic in getArr) {
        WHDFirModel *model=[WHDFirModel mj_objectWithKeyValues:realDic];
        [_firModel_list addObject:model];
    }
    
    return _firModel_list;
}

-(NSMutableArray *)SecModel_list
{
    if (_SecModel_list) {
        return _SecModel_list;
    }
    _SecModel_list=[@[] mutableCopy];
    NSString *path=[[NSBundle mainBundle]pathForResource:@"themes" ofType:nil];
    //把JSON数据转换成字典
    NSData *data=[NSData dataWithContentsOfFile:path];
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    //获取字典中的数组
    NSArray *getArr=dic[@"list"];
    for (NSDictionary *realDic in getArr) {
        WHDFirRowModel *model=[WHDFirRowModel mj_objectWithKeyValues:realDic];
        [_SecModel_list addObject:model];
    }
    
    return _SecModel_list;
}


#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUptitle];
    [self makeUpNavigationItem];
    [self setUpTable];
//    NSLog(@"%d",self.firModel_list.count);
}


#pragma mark 设置title
-(void)setUptitle
{
    CGFloat magin=4.0;
    CGFloat doubleMagin=magin*2;
    CGFloat Tx=VIEWW/magin;
    CGFloat Ty=0;
    CGFloat Tw=VIEWW/magin;
    CGFloat Th=44;
    CGRect Trect=(CGRect){Tx,Ty,Tw,Th};
    //设置
    UIView *titleView=[[UIView alloc]initWithFrame:Trect];
//    titleView.backgroundColor=[UIColor yellowColor];//测试用
    self.navigationItem.titleView=titleView;

    UIButton *left=[self makeTitleBtnWithFrame:(CGRect){0,0,VIEWW/doubleMagin,44}
                                 andNomalTitle:@"美天"
                                 andNomalColor:[UIColor grayColor]
                               andSeletedTitle:@"美天"
                               andSeletedColor:[UIColor blackColor]
                                        andSel:@selector(show:)];
    left.tag=0;
    self.leftBtn=left;
    //设置第一个一开始选中
    left.selected=YES;
//    [left setBackgroundColor:[UIColor greenColor]];//测试用
    [titleView addSubview:left];
    
    //右边
    UIButton *right=[self makeTitleBtnWithFrame:(CGRect){VIEWW/doubleMagin,0,VIEWW/doubleMagin,44}
                                  andNomalTitle:@"美辑"
                                  andNomalColor:[UIColor grayColor]
                                andSeletedTitle:@"美辑"
                                andSeletedColor:[UIColor blackColor]
                                         andSel:@selector(show:)];
    right.tag=1;
    self.rightBtn=right;
    [titleView addSubview:right];
    
    //设置CAlayer的偏移
    CALayer *layer=[[CALayer alloc]init];
    layer.frame=(CGRect){0,right.frame.size.height-2,VIEWW/doubleMagin,2};
    layer.backgroundColor=[UIColor blackColor].CGColor;
    self.lineLayer=layer;
    [titleView.layer addSublayer:layer];
}

-(UIButton *)makeTitleBtnWithFrame:(CGRect)rect
                     andNomalTitle:(NSString*)nTitle
                     andNomalColor:(UIColor *)nColor
                     andSeletedTitle:(NSString*)sTitle
                   andSeletedColor:(UIColor *)sColor
                            andSel:(SEL)seletor
{
    UIButton *btn=[[UIButton alloc]initWithFrame:rect];
    [btn setTitle:nTitle forState:UIControlStateNormal];
    [btn setTitleColor:nColor forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:18];
    [btn setTitle:sTitle forState:UIControlStateSelected];
    [btn setTitleColor:sColor forState:UIControlStateSelected];
    [btn addTarget:self action:seletor forControlEvents:UIControlEventTouchUpInside];
    return btn;
}


-(void)show:(UIButton *)btn
{
    self.rightBtn.selected=self.leftBtn.selected=NO;
    btn.selected=YES;
//    NSLog(@"我被按下了");//测试用的
    self.lineLayer.position=(CGPoint){btn.center.x,43};
    [self.scroll setContentOffset:(CGPoint){btn.tag*VIEWW,0} animated:YES];
    
}

#pragma mark - 设置button
-(void)makeUpNavigationItem
{
    //设置右边的按钮
    UIBarButtonItem *rightbutton=[[UIBarButtonItem alloc]initWithTitle:@"附近" style:UIBarButtonItemStylePlain target:self action:@selector(rightbuttonshow)];
    [rightbutton setTitleTextAttributes:@{NSFontAttributeName:myFontNum,NSForegroundColorAttributeName:[UIColor blackColor]
                                          } forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=rightbutton;

}

-(void)rightbuttonshow
{
    
}

#pragma mark - table
-(void)setUpTable
{
    self.view.frame=[UIApplication sharedApplication].windows[0].bounds;
    //第一个table
    UIScrollView *scroll=[[UIScrollView alloc]initWithFrame:self.view.frame];
    scroll.contentSize=(CGSize){VIEWW*2,0};//由于不想他纵轴拖动，就设置高度0
    scroll.delegate=self;
    scroll.pagingEnabled=YES;
    self.scroll=scroll;
    
    [self.view addSubview:scroll];
    
    
    CGRect tableRect=scroll.frame;
    UITableView *firTable=[[UITableView alloc]initWithFrame:tableRect];
    firTable.delegate=self;
    firTable.dataSource=self;
    [firTable registerNib:[UINib nibWithNibName:@"WHDFirCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WHDFirCell"];
    [firTable registerNib:[UINib nibWithNibName:@"WHDFirRowCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WHDFirRowCell"];
    
//    firTable.estimatedRowHeight=300;
    firTable.rowHeight=250;
    [scroll addSubview:firTable];
    //第二个table
    tableRect.origin.x=scroll.frame.size.width;
    UITableView *rowTable=[[UITableView alloc]initWithFrame:tableRect];
    rowTable.tag=10;
    rowTable.delegate=self;
    rowTable.dataSource=self;
    
//    rowTable.estimatedRowHeight=300;
    rowTable.rowHeight=250;
    [rowTable registerNib:[UINib nibWithNibName:@"WHDFirRowCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WHDFirRowCell"];
    [scroll addSubview:rowTable];
    
    //设置刷新
    firTable.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
    }];
    
}

#pragma mark datasoure
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag==10) {
        return self.SecModel_list.count;
    }
    return self.firModel_list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==10) {
        return 1;
    }
    WHDFirModel *model=self.firModel_list[section];
    return  model.themes.count ?2:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView.mj_header endRefreshing];
    if (tableView.tag==10) {
        WHDFirRowModel *secModel=self.SecModel_list[indexPath.section];
        WHDFirRowCell *cell=[tableView dequeueReusableCellWithIdentifier:@"WHDFirRowCell"];
        cell.titleLabel.text = secModel.title;
        cell.detailLabel.text = secModel.keywords;
        [cell.backImg sd_setImageWithURL:[NSURL URLWithString:secModel.img] placeholderImage:[UIImage imageNamed:@"mebackground"]];
        return cell;
    }
    
    WHDFirModel *model=self.firModel_list[indexPath.section];
    if (indexPath.row==1) {
        
        //转数据
        Themes *theme=model.themes[0];
        WHDFirRowCell *cell=[tableView dequeueReusableCellWithIdentifier:@"WHDFirRowCell"];
        cell.titleLabel.text = theme.title;
        cell.detailLabel.text = theme.keywords;
        [cell.backImg sd_setImageWithURL:[NSURL URLWithString:theme.img] placeholderImage:[UIImage imageNamed:@"mebackground"]];
        return cell;
    }else{
        WHDFirCell *firCell=[tableView dequeueReusableCellWithIdentifier:@"WHDFirCell"];
        //由于数据有几层，只好用这种办法，不能模型传递
        //获取模型,这里的数据就只有一个.
        Events *event=model.events[0];
        //获取时间，分拆时间
        NSString * date = model.date;
        NSString * month = [date substringWithRange:(NSRange){5,2}];
        NSString * day = [date substringWithRange:(NSRange){8,2}];
        
//        NSLog(@"%@",event);
        firCell.MonLabel.text = @"May. ";
        firCell.dayLabel.text = day;
        firCell.showLabel.text = event.feeltitle;
        firCell.detailLabel.text = event.title;
        firCell.addressLabel.text =event.address;
        NSString * imageUrl = event.imgs[0];
        [firCell.backImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"mebackground"]];
        return firCell;
    }
}
#pragma mark delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    WHDWebViewController *web=[[WHDWebViewController alloc]init];
    if (tableView.tag==10) {
        WHDFirRowModel *secModel=self.SecModel_list[indexPath.section];
        web.path=secModel.themeurl;
    }else
    {
        WHDFirModel *model=self.firModel_list[indexPath.section];
        if (indexPath.row==1) {
            web.path=model.themes[0].themeurl;
        }else
        {
            web.path=model.events[0].shareURL;
            web.detailStr=model.events[0].mobileURL;
        }
        
    }
    web.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:web  animated:YES];
    
}
#pragma mark 控制滑动时候设置的.
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView!=_scroll) return;
    if (scrollView.contentOffset.x==320) {
        [self show:self.rightBtn];
    }else
        [self show:self.leftBtn];

}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView!=_scroll) return;
    CGFloat rate=(_lineLayer.frame.size.width)/scrollView.frame.size.width;
    _lineLayer.frame = (CGRect){scrollView.contentOffset.x *rate,42,VIEWW/8.0,2};
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




@end

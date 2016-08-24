//
//  Top10VC.m
//  Flower
//
//  Created by HUN on 16/7/12.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "Top10VC.h"

#import "MainDetailViewController.h"
#import "MainTableModel.h"
#import "ArticleModel.h"
#import "authorCell.h"

#import "AuthorModel.h"
#import "GoodCell1.h"
#import "GoodCell2.h"

@interface Top10VC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property(nonatomic,weak)UIButton *lastSeletedBtn;

@property(nonatomic,strong)UITableView *tableView_goods;

@property(nonatomic,strong)UITableView *tableView_author;

@property(nonatomic,strong)NSMutableArray *goodsArr;

@property(nonatomic,strong)NSMutableArray *authorArr;

@property(nonatomic,strong)CALayer *buttonLayer;

@property(nonatomic,assign)BOOL isGoodTable;
//装2个tableView
@property(nonatomic,strong)UIScrollView *scrollView;

@end

@implementation Top10VC
#pragma mark - lazyLoad
-(CALayer *)buttonLayer
{
    if (_buttonLayer == nil) {
        _buttonLayer = [[CALayer alloc]init];
    }
    return _buttonLayer;
}

-(NSMutableArray *)goodsArr
{
    if (_goodsArr == nil) {
        _goodsArr = [NSMutableArray array];
    }
    return _goodsArr;
}

-(NSMutableArray *)authorArr
{
    if (_authorArr == nil) {
        _authorArr = [NSMutableArray array];
    }
    return _authorArr;
}


#pragma mark - 视图加载
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self _initNavi];
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self _initView];
}

#pragma mark - 初始化页面
#pragma mark 初始化navigation按钮
-(void)_initNavi
{
    /**
     *  设置右边按钮
     */
    [self setRightBtn:@"f_search" andTitle:nil];
    self.rightBtnBlock = ^(UIButton *btn)
    {
        
    };
}


#pragma mark 初始化页面
static CGFloat maginY = 10;
-(void)_initView
{
    self.view.frame = (CGRect){0,0,k_width,k_height};
    NSArray *nameArr = @[@"专栏",@"作者"];
    NSInteger fontNumber = 13;
    CGSize nameSize = [nameArr[0] sizeWithFont:font(fontNumber) constrainedToSize:(CGSize){MAXFLOAT,MAXFLOAT}];
    
    CGFloat maginX =30;
    CGFloat tempMagin = 0 ;
    CGPoint centerP = (CGPoint){self.view.center.x,0};
    CGFloat btnW = nameSize.width + maginY;
    CGFloat btnH = nameSize.height + maginY;
    for (int i=0; i<nameArr.count; i++) {
        
        tempMagin = i?maginX:(maginX+nameSize.width)*-1;
        UIButton *btn =[ [UIButton alloc]initWithFrame:(CGRect){centerP.x+tempMagin,maginY,btnW,btnH}];
        [btn setTitle:nameArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = font(fontNumber);
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [btn setTitle:nameArr[i] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        btn .tag = i + 10;
        if (i==0) {
            btn.selected = YES;
            _lastSeletedBtn =btn;
//            self.buttonLayer = [[CALayer alloc]init];
            self.buttonLayer.frame = (CGRect){btn.frame.origin.x,maginY+btnH,btnW,2};
            self.buttonLayer.backgroundColor = [UIColor blackColor].CGColor;
            self.isGoodTable = YES;
            [self.view.layer addSublayer:self.buttonLayer];
            [self getModelsFromWeb];
        }
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    //设置scrollView
    CGFloat scrollViewY = maginY*2 + btnH;
    _scrollView = [[UIScrollView alloc]initWithFrame:(CGRect){0,scrollViewY,k_width,k_height-scrollViewY}];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;//取消弹簧效果
    _scrollView.tag = 100;//因为有两个tableView,要做区分，不然都走代理了
    [self.view addSubview:_scrollView];
    
    CGFloat tableW = _scrollView.frame.size.width;
    CGFloat tableH = _scrollView.frame.size.height;
    _scrollView.contentSize = (CGSize){2*tableW,tableH};
    
    //专栏tablvieView
    _tableView_goods = [[UITableView alloc]initWithFrame:(CGRect){0,0,tableW,tableH}];
    _tableView_goods.delegate = self;
    _tableView_goods.dataSource = self;
    //注册CELL
    //前3个
    [_tableView_goods registerNib:[UINib nibWithNibName:goodCell1ID bundle:[NSBundle mainBundle]] forCellReuseIdentifier:goodCell1ID];
    [_tableView_goods registerNib:[UINib nibWithNibName:goodCell2ID bundle:[NSBundle mainBundle]] forCellReuseIdentifier:goodCell2ID];
    _tableView_goods.rowHeight = 140;
    [_scrollView addSubview:_tableView_goods];
    
    //作者tableView
    _tableView_author = [[UITableView alloc]initWithFrame:(CGRect){tableW,0,tableW,tableH}];
    _tableView_author.delegate = self;
    _tableView_author.dataSource = self;
    //注册CELL
    //前3个
    [_tableView_author registerNib:[UINib nibWithNibName:authorCellID bundle:[NSBundle mainBundle]] forCellReuseIdentifier:authorCellID];
    _tableView_author.rowHeight = 60;
    [_scrollView addSubview:_tableView_author];
}

/**
 *  顶部按钮事件
 */
-(void)btnAction:(UIButton *)btn
{
    CGFloat tableW = _scrollView.frame.size.width;
    _lastSeletedBtn.selected = NO;
    btn.selected = !btn.selected;
    _lastSeletedBtn = btn;
    self.buttonLayer.frame = (CGRect){btn.frame.origin.x,maginY+btn.frame.size.height,btn.frame.size.width,2};
    if (btn.selected == YES && btn.tag == 10) {
        //主要用来切换tableView的
        self.isGoodTable = YES;
        [_scrollView setContentOffset:(CGPoint){0,0} animated:YES];
       
    }else
    {
         self.isGoodTable = NO;
        [_scrollView setContentOffset:(CGPoint){tableW,0} animated:YES];
    }
    [self getModelsFromWeb];
}
#pragma mark - 获取网络数据



/**
 *  获取产品模型
 */
-(void)getModelsFromWeb
{
    NSMutableDictionary *paramas = [@{} mutableCopy];
    NSString *str = self.isGoodTable? @"topContents":@"topArticleAuthor";
    [paramas setObject:str forKey:@"action"];
    [self.goodsArr removeAllObjects];
    [self.authorArr removeAllObjects];
    [WHDHttpRequest getTop10Withparamters:paramas andandCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSArray *arr = dic[@"result"];
//                        NSLog(@"%@",arr);
            NSInteger  index = 1;
            //文章详情
            if (self.isGoodTable) {
                for (NSDictionary *result in arr) {
                    ArticleModel *model = [ArticleModel mj_objectWithKeyValues:result];
                    model.index = index;
                    index++;
                    [self.goodsArr addObject:model];
                }
//                NSLog(@"goodsArr<----%d",self.goodsArr.count);
                
                [_tableView_goods reloadData];
            }else
            {
                for (NSDictionary *result in arr) {
                    AuthorModel *model = [AuthorModel mj_objectWithKeyValues:result];
                    model.index = index;
                    index++;
                    model.authnum = result[@"newAuth"];
//                    NSLog(@"%@",model.authnum);
                    [self.authorArr addObject:model];
                }
//                NSLog(@"authorArr--->:%d",self.authorArr.count);
                
                [_tableView_author reloadData];
            }
            
            
        }else
        {
            NSLog(@"%@",error);
        }
    }];
}

#pragma mark scrollViewDalegate
//移动过程中不能做网络请求，智能做layer的变化
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 100)
    {
    NSInteger offSetX = scrollView.contentOffset.x/scrollView.frame.size.width + 0.5 + 10;
//    NSLog(@"%lf,%d",scrollView.contentOffset.x,offSetX);
    UIButton *btn =[self.view viewWithTag:offSetX];
    self.buttonLayer.frame = (CGRect){btn.frame.origin.x,maginY+btn.frame.size.height,btn.frame.size.width,2};
    scrollView.userInteractionEnabled = NO;
    }
}

//这里做唯一一次的请求就可以了,注意这里要注意scrollView被重复使用，要用tag区分.


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag == 100)
    {
        scrollView.userInteractionEnabled = YES;
        NSInteger offSetX = scrollView.contentOffset.x/(scrollView.frame.size.width*1.0)+0.5 + 10;
//        NSLog(@"%lf,%d",scrollView.contentOffset.x,offSetX);
        UIButton *btn =[self.view viewWithTag:offSetX];
        _lastSeletedBtn.selected = NO;
        btn.selected = YES;
        _lastSeletedBtn = btn;
        NSInteger num = offSetX - 10;
        self.isGoodTable = num?NO:YES;
//        NSLog(@"%d",self.isGoodTable);
        [self getModelsFromWeb];
    }
    
}

#pragma mark - TableView
#pragma mark delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //如果是专栏就跳转到专栏
    //如果不是就跳转到自己的页面
    if (self.isGoodTable) {
        MainDetailViewController *detailVC = [MainDetailViewController new];
        detailVC.view.frame = self.view.frame;
        ArticleModel *model = self.goodsArr[indexPath.row];
//        需要网络请求
        NSMutableDictionary *paramas = [@{} mutableCopy];
        [paramas setObject:model.id forKey:@"articleId"];
        [paramas setObject:MyUserID forKey:@"userId"];
        [WHDHttpRequest getArticleDetailWithparamters:paramas andandCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (!error) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                NSDictionary *resultDic = dic[@"result"];
                detailVC.model = [MainTableModel mj_objectWithKeyValues:resultDic];
                [detailVC setViewTitle: detailVC.model.title];
                [self.navigationController pushViewController:detailVC animated:YES];
            }else
            {
                NSLog(@"%@",error);
            }
        }];
       
        
    }else
        nil;
    
    
}


#pragma mark datasoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //如果专栏..
    if (self.isGoodTable) {
        return self.goodsArr.count;
    }else
        return self.authorArr.count;
}

static NSString *goodCell1ID = @"GoodCell1";
static NSString *goodCell2ID = @"GoodCell2";
static NSString *authorCellID = @"authorCell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isGoodTable) {
        if (indexPath.row<3) {
            GoodCell1 *cell= [tableView dequeueReusableCellWithIdentifier:goodCell1ID];
            cell.model = self.goodsArr[indexPath.row];
            cell.clipsToBounds = YES;
            return cell;
        }else
        {
            GoodCell2 *cell= [tableView dequeueReusableCellWithIdentifier:goodCell2ID];
            cell.model = self.goodsArr[indexPath.row];
            cell.clipsToBounds = YES;
            return cell;
        }
    }else
    {
        authorCell *cell = [tableView dequeueReusableCellWithIdentifier:authorCellID];
        cell.model = self.authorArr[indexPath.row];
        cell.clipsToBounds = YES;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}


@end

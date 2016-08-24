//
//  AskBorrowerViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-7-2.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//借款详情 =======》》向借款人提问
#import "AskBorrowerViewController.h"
#import "ColorTools.h"
#import "TenderOnceViewController.h"
#import "AskQuestionViewController.h"
#import "AskBorrowerCell.h"
#import "Questions.h"

#define kIS_IOS7                (kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_6_1)
@interface AskBorrowerViewController ()<UITableViewDataSource,UITableViewDelegate,HTTPClientDelegate>

@property(nonatomic ,strong) NSMutableArray *listDataArr;
@property(nonatomic ,strong) UITableView *listView;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation AskBorrowerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化视图
    [self initView];

//    // 初始化数据
//    [self initData];
}

/**
 * 初始化数据
 */
- (void)initData
{
    
//    _listDataArr = [[NSMutableArray alloc] init];
//    
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    //借款提问问题列表
//    [dic setObject:@"13" forKey:@"OPT"];
//    [dic setObject:@"" forKey:@"body"];
//    [dic setObject:[NSString stringWithFormat:@"%@",_borrowId] forKey:@"borrowId"];
//    
//    if (_requestClient == nil) {
//        _requestClient = [[NetWorkClient alloc] init];
//        _requestClient.delegate = self;
//        [_requestClient requestGet:@"app/services" withParameters:dic];
//    }
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = KblackgroundColor;
    
    //列表刷新通知注册
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerRereshing) name:@"AskRefresh" object:nil];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 40)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    
    UIButton *askBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    askBtn.frame = CGRectMake(self.view.frame.size.width*0.5-50, 8,100, 25);
    askBtn.backgroundColor = PinkColor;
    [askBtn setTitle:@"提问" forState:UIControlStateNormal];
    [askBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    askBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13.0];
    [askBtn.layer setMasksToBounds:YES];
    [askBtn.layer setCornerRadius:3.0];
    [askBtn addTarget:self action:@selector(askBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:askBtn];
    
    _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 104, self.view.frame.size.width, self.view.frame.size.height-104) style:UITableViewStyleGrouped];
    _listView.delegate = self;
    _listView.scrollEnabled = YES;
    _listView.dataSource = self;
    [self.view  addSubview:_listView];
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.listView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 自动刷新(一进入程序就下拉刷新)
//    [self.listView headerBeginRefreshing];
       [self headerRereshing];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
//    [self.listView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    _listDataArr = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //借款提问问题列表
    [dic setObject:@"13" forKey:@"OPT"];
    [dic setObject:@"" forKey:@"body"];
    [dic setObject:[NSString stringWithFormat:@"%@",_borrowId] forKey:@"borrowId"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    [_requestClient requestGet:@"app/services" withParameters:dic];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.listView reloadData];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.listView headerEndRefreshing];
    });
    
}



/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"向借款人提问";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];

    
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
        
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
}


// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    DLOG(@"==返回成功=======%@",obj);
    NSDictionary *dics = obj;
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        NSArray *dataArr = [dics objectForKey:@"questionList"];
        
        [_listDataArr removeAllObjects];
        if (![dataArr isEqual:[NSNull null]]) {
            
            for (NSDictionary *dic in dataArr) {

                Questions *Datamodel = [[Questions alloc] init];
                Datamodel.question =  [dic objectForKey:@"content"];
                if(![[dic objectForKey:@"bidAnswerList"] count])
                {
                   Datamodel.answerStr = @"暂无回复";
                
                }
                else
                {
                
                    Datamodel.answerStr = [[[dic objectForKey:@"bidAnswerList"] objectAtIndex:0] objectForKey:@"content"];
                }
              
                Datamodel.answerName = [dic objectForKey:@"name"];
                
                NSDate *date = [NSDate dateWithTimeIntervalSince1970: [[[dic objectForKey:@"time"] objectForKey:@"time"] doubleValue]/1000];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
                Datamodel.answerTime  = [dateFormat stringFromDate: date];
                
                [_listDataArr addObject:Datamodel];
            }
            
//             [_listView reloadData];
        }
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
        
    }else {
        
        DLOG(@"返回成功===========%@",[obj objectForKey:@"msg"]);
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
    
    }
    
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    // 服务器返回数据异常
//    [SVProgressHUD showErrorWithStatus:@"网络异常"];

}

// 无可用的网络
-(void) networkError
{
    // 服务器返回数据异常
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
}


#pragma mark UItableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [_listDataArr count];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2.0f;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 2.0f;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    AskBorrowerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell = [[AskBorrowerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (kIS_IOS7) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 14, 0, 14)];
    }
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(9, 14, 15, 15)];
    numLabel.layer.cornerRadius = 7.5f;
    numLabel.layer.masksToBounds = YES;
    numLabel.text = [NSString stringWithFormat:@"%ld",indexPath.section+1];
    numLabel.font = [UIFont systemFontOfSize:11.0f];
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.adjustsFontSizeToFitWidth = YES;
    numLabel.backgroundColor = PinkColor;
    numLabel.textColor = [UIColor whiteColor];
    [cell.contentView addSubview:numLabel];
    

    Questions *model = [_listDataArr objectAtIndex:indexPath.section];
    cell.questionLabel.text = model.question;
    cell.answerLabel.text = [NSString stringWithFormat:@"%@",model.answerStr];
    cell.questionName.text = model.answerName;
    cell.timeLabel.text = model.answerTime;
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma 返回按钮触发方法
- (void)backClick
{
    // DLOG(@"返回按钮");
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

#pragma 提问
- (void)askBtnClick
{
    DLOG(@"提问按钮!!!!!!!!");
    
    if (AppDelegateInstance.userInfo == nil) {
        
        [ReLogin outTheTimeRelogin:self];
        
    }else {
        
        AskQuestionViewController *AskQuestionView = [[AskQuestionViewController alloc] init];
        AskQuestionView.bidUserIdSign =_bidUserIdSign;
        AskQuestionView.borrowId = _borrowId;
        [self.navigationController pushViewController:AskQuestionView animated:YES];

    }

}


#pragma 立即投标
- (void)tenderBtnClick
{
    if (AppDelegateInstance.userInfo == nil) {
        
        [ReLogin outTheTimeRelogin:self];
    }
    else
    {
        TenderOnceViewController *TenderOnceView = [[TenderOnceViewController alloc] init];
        TenderOnceView.borrowId = _borrowId;
        [self.navigationController pushViewController:TenderOnceView animated:YES];
        
    }
}


-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}

@end

//
//  DetailsOfCreditorViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-7-8.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  债权转让详情页

#import "DetailsOfCreditorViewController.h"
#import "UIFolderTableView.h"

#import "LDProgressView.h"
#import "ColorTools.h"
#import "CreditorDetailsCell.h"
#import "BorrowerInfoViewController.h"
#import "MaterialAuditSubjectViewController.h"
#import "CBORiskControlSystemViewController.h"
#import "HistoricalRecordViewController.h"
#import "TenderAwardViewController.h"
#import "AuctionRecordViewController.h"
#import "DetailsDescriptionViewController.h"
#import "TransferSnapshotViewController.h"
#import "AuctionViewController.h"
#import "ReportTwoViewController.h"
#import "SendMessageViewController.h"

@interface DetailsOfCreditorViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,HTTPClientDelegate>
{
    
    NSArray *tableArr;
    NSMutableArray *_collectionArrays;
    UIView *scrollPanel;
    NSInteger _num;
    NSInteger _attentionNum;
    NSInteger _collectNum;
    NSInteger _outTimeNum;
    NSString *debtNo;
}
@property (nonatomic,strong)UIFolderTableView *listView;
//  是否打开二级详情
@property (assign)BOOL isOpen;
@property (nonatomic,retain)NSIndexPath *selectIndex;

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIScrollView *ScrollView;
@property (nonatomic,strong)LDProgressView *progressView;
@property (nonatomic,strong)UILabel *idLabel;
@property (nonatomic,strong)UILabel *stateLabel;
@property (nonatomic,strong)UILabel  *progressLabel;
@property (nonatomic,strong)UILabel *usageLabel;
@property (nonatomic,strong)UIImageView * typeImg;
@property (nonatomic,strong)UILabel *wayLabel;
@property (nonatomic,strong)NSString *associatesStr;
@property (nonatomic,strong)NSString *CBOAuditStr;
@property (nonatomic,strong)UILabel *moneyLabel;
@property (nonatomic,strong)UILabel *rateLabel;
@property (nonatomic,strong)UILabel *deadlineLabel;
@property (nonatomic,strong)UILabel *dateLabel;
@property (nonatomic,strong)UILabel *dateLabel2;
@property (nonatomic,copy) NSString *borrowerId;
@property (nonatomic,copy)NSString   *borrowerheadImg;
@property (nonatomic,copy)NSString   *borrowername;
@property (nonatomic,copy)NSString   *borrowid;
@property (nonatomic,copy)NSString   *creditRating;
@property (nonatomic,copy)NSArray   *list;    //审核数组  AuditSubjectName  auditStatus   imgpath
@property (nonatomic,strong)UILabel *organizationLabel;
@property (nonatomic,copy)NSString   *VipStr;
@property (nonatomic,copy)NSString   *BorrowsucceedStr;
@property (nonatomic,copy)NSString   *BorrowfailStr;
@property (nonatomic,copy)NSString   *repaymentnormalStr;
@property (nonatomic,copy)NSString   *repaymentabnormalStr;
@property (nonatomic,copy)NSString   *borrowDetails;
@property (nonatomic,copy)NSString   *registrationTime;
@property (nonatomic,copy)NSString   *reimbursementAmount;
@property (nonatomic,copy)NSString   *SuccessBorrowNum;
@property (nonatomic,copy)NSString   *NormalRepaymentNum;
@property (nonatomic,copy)NSString   *OverdueRepamentNum;
@property (nonatomic,copy)NSString   *BorrowingAmount;
@property (nonatomic,copy)NSString   *FinancialBidNum;
@property (nonatomic,copy)NSString   *paymentAmount;
@property (nonatomic,copy)NSString   *awardString;
@property (nonatomic,strong)NSMutableArray  *AuditdataArr;
@property (nonatomic,strong)NSMutableArray  *auditStatusArr;
@property (nonatomic,strong)NSMutableArray  *imgpathArr;
@property (nonatomic,copy)NSString  *bidIdSign;
@property (nonatomic,copy)NSString  *debtUserIdSign;
@property (nonatomic,strong)UILabel *titleLabel;


@property (nonatomic,strong)UILabel *moneyLabel1;
@property (nonatomic,strong)UILabel *moneyLabel2;
@property (nonatomic,strong)UILabel *moneyLabel3;
@property (nonatomic,strong)UITextView *detailView;


@property (nonatomic,copy)NSString *borrowingStr;
@property (nonatomic,copy)NSString *principalStr;
@property (nonatomic,copy)NSString *YearRateStr;
@property (nonatomic,copy)NSString *interestStr;
@property (nonatomic,copy)NSString *receivedStr;
@property (nonatomic,copy)NSString *remainingStr;
@property (nonatomic,copy)NSString *collectedStr;
@property (nonatomic,assign)BOOL isoverdue;
@property (nonatomic,copy)NSString *timeStr;
@property (nonatomic)NSTimeInterval time;//相差时间
//@property (nonatomic,strong)UILabel *dateLabel2;
@property (nonatomic,copy)NSString *attentionId;
@property (nonatomic,copy)NSString *collectId;
@property(nonatomic ,strong) UIButton *attBtn;
@property(nonatomic ,strong) UIButton *collectBtn;
@property(nonatomic ,strong) NetWorkClient *requestClient;
@property(nonatomic ,strong) UIView *bottomView;
@property (nonatomic,strong)NSMutableArray  *isVisibleArray;    // 是否可查看
@property (nonatomic,strong) UIImageView *clockimg;
@property (nonatomic,strong) UILabel *textLabel1;
@property (nonatomic,strong) UILabel *textLabel2;
@property (nonatomic,strong) UILabel *textLabel3;
@property (nonatomic,strong)UIView  *dateBackView;
@property (nonatomic,strong)UILabel *dateLabel1;
@end

@implementation DetailsOfCreditorViewController

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
    // Do any additional setup after loading the view.
    // 初始化数据
    self.isOpen = NO;
    [self initData];
    
    // 初始化视图
    [self initView];
    
}

/**
 * 初始化数据
 */
- (void)initData
{

    _outTimeNum = 0;
    _attentionNum = 0;
    _collectNum = 0;
    
//    tableArr = @[@"转让标简况",@"借款标详细描述",@"必要材料审核科目",@"CBO风控体系审核",@"历史记录",@"投标奖励",@"竞拍记录"];
    tableArr = @[@"转让标详情",@"竞拍记录"];
    
    //展开行数组
    _collectionArrays =[[NSMutableArray alloc] init];
    _AuditdataArr = [[NSMutableArray alloc] init];
    _auditStatusArr = [[NSMutableArray alloc] init];
    _imgpathArr = [[NSMutableArray alloc] init];
    _isVisibleArray = [[NSMutableArray alloc] init];
    
    _num = 1;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //获取债权详情（opt=31）
    [parameters setObject:@"31" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:[NSString stringWithFormat:@"%@",_creditorId] forKey:@"id"];
    if (AppDelegateInstance.userInfo != nil) {
        
        [parameters setObject:[NSString stringWithFormat:@"%@",AppDelegateInstance.userInfo.userId] forKey:@"userId"];
        
    }
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
       
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
    
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = KblackgroundColor;
    
    
    //滚动视图
    _ScrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 950)];
    _ScrollView.userInteractionEnabled = YES;
    _ScrollView.scrollEnabled = YES;
    _ScrollView.backgroundColor = KblackgroundColor;
    _ScrollView.showsHorizontalScrollIndicator =NO;
    _ScrollView.showsVerticalScrollIndicator = NO;
    _ScrollView.delegate = self;
    _ScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1000);
    [self.view addSubview:_ScrollView];
    
    
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, MSWIDTH - 90, 32)];
     _titleLabel.textColor = BluewordColor;
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    _titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [_ScrollView addSubview:_titleLabel];
    
    
    _idLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 42, 25)];
//    _idLabel.text =  [NSString stringWithFormat:@"Z%@",_creditorId];
    _idLabel.textColor = [UIColor grayColor];
    _idLabel.font = [UIFont systemFontOfSize:13.0f];
    _idLabel.textAlignment = NSTextAlignmentRight;
    _idLabel.adjustsFontSizeToFitWidth = YES;
    [_ScrollView addSubview:_idLabel];
    
    
    
    //收藏按钮
    _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _collectBtn.frame = CGRectMake(MSWIDTH-30, 10, 20, 20);
    [_collectBtn setImage:[UIImage imageNamed:@"no_collection"] forState:UIControlStateNormal];
    [_collectBtn addTarget:self action:@selector(collectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_ScrollView addSubview:_collectBtn];


        
    _textLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, 100, 30)];
    _textLabel1.font = [UIFont boldSystemFontOfSize:13.0f];
    _textLabel1.text = @"待收本金:";
    _textLabel1.textAlignment = NSTextAlignmentLeft;
    [_ScrollView addSubview:_textLabel1];

    
    _textLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(155, 30, 100, 30)];
    _textLabel2.font = [UIFont boldSystemFontOfSize:13.0f];
    _textLabel2.text = @"拍卖底价:";
    _textLabel2.textAlignment = NSTextAlignmentLeft;
    [_ScrollView addSubview:_textLabel2];
    
    
    _textLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(15, 50, 100, 30)];
    _textLabel3.font = [UIFont boldSystemFontOfSize:13.0f];
    _textLabel3.text = @"目前拍价:";
    _textLabel3.textAlignment = NSTextAlignmentLeft;
    [_ScrollView addSubview:_textLabel3];
    
    _moneyLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(75, 35, 100, 20)];
    _moneyLabel1.textColor = [UIColor grayColor];
    _moneyLabel1.font = [UIFont boldSystemFontOfSize:12.0f];
    [_ScrollView addSubview:_moneyLabel1];
    
    _moneyLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(215, 35, 100, 20)];
    _moneyLabel2.textColor = [UIColor  grayColor];
    _moneyLabel2.font = [UIFont boldSystemFontOfSize:12.0f];
    [_ScrollView addSubview:_moneyLabel2];
    
    _moneyLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(75, 54, 100, 20)];
    _moneyLabel3.textColor = [UIColor grayColor];
    _moneyLabel3.font = [UIFont boldSystemFontOfSize:12.0f];
    [_ScrollView addSubview:_moneyLabel3];
    
    
    _dateBackView = [[UIView alloc] initWithFrame:CGRectMake(10, 80, 110, 30)];
    _dateBackView.backgroundColor = PinkColor;
    [_ScrollView addSubview:_dateBackView];
    
    _dateLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(50, 80, 110, 30)];
    _dateLabel1.text = @"剩余时间";
    _dateLabel1.textColor = [UIColor whiteColor];
    _dateLabel1.font = [UIFont boldSystemFontOfSize:14.0f];
    [_ScrollView addSubview:_dateLabel1];
    
    _clockimg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 85, 22, 22)];
    _clockimg.image = [UIImage imageNamed:@"clock_big"];
    _clockimg.backgroundColor = [UIColor clearColor];
    [_ScrollView addSubview:_clockimg];
    
    _dateLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(120, 80, MSWIDTH - 130, 30)];
    _dateLabel2.textColor = PinkColor;
    _dateLabel2.backgroundColor = [UIColor whiteColor];
    _dateLabel2.textAlignment = NSTextAlignmentCenter;
    _dateLabel2.font = [UIFont boldSystemFontOfSize:14.0f];
    [_ScrollView addSubview:_dateLabel2];
    
    _detailView = [[UITextView alloc] initWithFrame:CGRectMake(0, 120, MSWIDTH, 50)];
    _detailView.textColor = [UIColor lightGrayColor];
    _detailView.font = [UIFont boldSystemFontOfSize:12.0f];
    _detailView.userInteractionEnabled = NO;
    _detailView.textAlignment = NSTextAlignmentCenter;
    _detailView.backgroundColor = [UIColor whiteColor];
    [_ScrollView addSubview:_detailView];
    
    
    _listView = [[UIFolderTableView alloc] initWithFrame:CGRectMake(0, 180, MSWIDTH, 840)  style:UITableViewStyleGrouped];
    _listView.delegate = self;
    _listView.dataSource = self;
    _listView.backgroundColor = KblackgroundColor;
    [_ScrollView addSubview:_listView];
    
    
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 60, MSWIDTH, 60)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:_bottomView aboveSubview:_ScrollView];
    
    
    UIButton *auctionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    auctionBtn.frame = CGRectMake(0, 0,MSWIDTH, 60);
    auctionBtn.backgroundColor = BrownColor;
    [auctionBtn setTitle:@"我要竞拍" forState:UIControlStateNormal];
    [auctionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    auctionBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:18.0];
    [auctionBtn addTarget:self action:@selector(auctionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:auctionBtn];
    
    
    
     [self updateAuctionState:self.status];
}

#pragma mark -- 更新竞拍状态
- (void)updateAuctionState:(NSInteger)statuNum
{
    switch (statuNum) {
        case 1:
            _stateLabel.text = @"竞拍中";
            break;
        case 2:
            _stateLabel.text = @"等待认购";
            break;
        case 3:
            _stateLabel.text = @"已成功";
            [_bottomView removeFromSuperview];
            break;
        default:
            _stateLabel.text = @"等待确认";
            [_bottomView removeFromSuperview];
            break;
    }
}
/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"转让详情";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]  initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
//    // 导航条分享按钮
//    UIBarButtonItem *ShareItem=[[UIBarButtonItem alloc]  initWithImage:[UIImage imageNamed:@"nav_share"] style:UIBarButtonItemStyleDone target:self action:@selector(ShareClick)];
//    ShareItem.tintColor = [UIColor whiteColor];
//    [self.navigationItem setRightBarButtonItem:ShareItem];
}


#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
   
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    NSDictionary *dics = obj;
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        DLOG(@"==返回成功=======%@",obj);
        
        if (_num == 1) {
            
            _titleLabel.text  = [dics objectForKey:@"creditorTitle"];
            
            //剩余时间
            if (![[dics objectForKey:@"remainTime"] isEqual:[NSNull null]]) {
                
                NSString *timeStr = [[NSString stringWithFormat:@"%@",[dics objectForKey:@"remainTime"]] substringWithRange:NSMakeRange(0, 19)];
                [self timeDown:timeStr];
            }
            
            //借款标状态
            NSInteger statuNum = [[dics objectForKey:@"creditorStatus"] integerValue];
            [self updateAuctionState:statuNum];
            
            NSString *str = [NSString stringWithFormat:@"%@",[dics objectForKey:@"attentionId"]];
            if(str.length)
            {
                _attentionNum = 1;
                _attentionId = [NSString stringWithFormat:@"%@",[dics objectForKey:@"attentionId"]];
                
            }
            
            NSString *str2 = [NSString stringWithFormat:@"%@",[dics objectForKey:@"attentionDebtId"]];
            if(str2.length)
            {
                _collectNum = 1;
                _collectId = [NSString stringWithFormat:@"%@",[dics objectForKey:@"attentionDebtId"]];
                [_collectBtn setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
            }
            
            _moneyLabel1.text = [NSString stringWithFormat:@"¥ %@",[dics objectForKey:@"principal"]];//待收本金
            _moneyLabel2.text = [NSString stringWithFormat:@"¥ %@",[dics objectForKey:@"auctionBasePrice"]];//拍卖底价
            _moneyLabel3.text = [NSString stringWithFormat:@"¥ %@",[dics objectForKey:@"maxOfferPrice"]];//目前拍价
            _idLabel.text =  [NSString stringWithFormat:@"%@",[dics objectForKey:@"debtNo"]];   // 编号
            debtNo = [NSString stringWithFormat:@"%@",[dics objectForKey:@"debtNo"]];   // 编号
            
            //转让理由
            _detailView.text = [dics  objectForKey:@"creditorReason"];
            
            //借款人相关信息
            _borrowerId = [NSString stringWithFormat:@"%@",[dics objectForKey:@"borrowerId"]];
            _borrowerheadImg = [dics objectForKey:@"borrowerheadImg"];
            _borrowername = [dics objectForKey:@"borrowername"];
            _borrowid = [dics objectForKey:@"sign"];
            if( [dics objectForKey:@"creditRating"] != nil && ![[dics objectForKey:@"creditRating"] isEqual:[NSNull null]])
            {
                _creditRating = [dics objectForKey:@"creditRating"];
            }else{
                
                _creditRating = @"no";
            }
            _BorrowsucceedStr = [dics objectForKey:@"borrowSuccessNum"];
            _BorrowfailStr = [dics objectForKey:@"borrowFailureNum"];
            _repaymentnormalStr= [dics objectForKey:@"repaymentNormalNum"];
            _repaymentabnormalStr = [dics objectForKey:@"repaymentOverdueNum"];
            _VipStr = [NSString stringWithFormat:@"%@",[dics objectForKey:@"vipStatus"]];
            _debtUserIdSign = [NSString stringWithFormat:@"%@",[dics objectForKey:@"debtUserIdSign"]];
            
            
            //转标简介
            _borrowingStr = [NSString stringWithFormat:@"¥%@",[dics objectForKey:@"amount"]];
             _principalStr = [NSString stringWithFormat:@"¥%@",[dics objectForKey:@"corpus"]];
             _YearRateStr = [NSString stringWithFormat:@"%@%%",[dics objectForKey:@"apr"]];
            _interestStr = [NSString stringWithFormat:@"¥%@",[dics objectForKey:@"receiveMoney"]];
            _receivedStr = [NSString stringWithFormat:@"¥%@",[dics objectForKey:@"hasReceiveMoney"]];
            _remainingStr = [NSString stringWithFormat:@"¥%@",[dics objectForKey:@"remainReceiveMoney"]];
            _collectedStr = [NSString stringWithFormat:@"¥%@",[dics objectForKey:@"receiveCorpus"]];
            _isoverdue = [[dics objectForKey:@"hasOverdue"] boolValue];
            if (![[dics objectForKey:@"receiveTime"] isEqual:[NSNull null]]) {
                   _timeStr = [NSString stringWithFormat:@"%@",[dics objectForKey:@"receiveTime"]];
            }
            
            //借款详情描述
            _borrowDetails = [dics objectForKey:@"borrowDetails"];
            //CBO审核
            _CBOAuditStr =  [dics objectForKey:@"CBOAuditDetails"];
            
            //审核科目数组
            _list = [dics objectForKey:@"list"];
            for (NSDictionary* dic in _list) {
                [_AuditdataArr addObject:[dic  objectForKey:@"AuditSubjectName"]];
                [_auditStatusArr addObject:[dic  objectForKey:@"auditStatus"]];
                [_imgpathArr addObject:[dic  objectForKey:@"imgpath"]];
                [_isVisibleArray addObject:[dic  objectForKey:@"isVisible"]];
            }
            
            //历史纪录部分
            if( [dics objectForKey:@"registrationTime"] != nil &&![[dics objectForKey:@"registrationTime"] isEqual:[NSNull null]])
            {
                
                _registrationTime = [[NSString stringWithFormat:@"%@",[dics objectForKey:@"registrationTime"]] substringWithRange:NSMakeRange(0, 19)];
                
            }else{
                _registrationTime = @"";
            }

            _SuccessBorrowNum = [dics objectForKey:@"SuccessBorrowNum"];
            _NormalRepaymentNum = [dics objectForKey:@"NormalRepaymentNum"];
            _OverdueRepamentNum = [dics objectForKey:@"OverdueRepamentNum"];
            _reimbursementAmount = [dics objectForKey:@"reimbursementAmount"];
            _BorrowingAmount = [dics objectForKey:@"BorrowingAmount"];
            _FinancialBidNum = [dics objectForKey:@"FinancialBidNum"];
            _paymentAmount = [dics objectForKey:@"paymentAmount"];
           
            //投标奖励
            _awardString = [NSString stringWithFormat:@"%@",[dics objectForKey:@"bonus"]] ;//奖励
            
            [_listView reloadData];
            
        }else if (_num == 2)
        {
            DLOG(@"收藏信息===========%@",[obj objectForKey:@"msg"]);
            [SVProgressHUD showSuccessWithStatus:[obj objectForKey:@"msg"]];
            NSString *str = [NSString stringWithFormat:@"%@",[obj objectForKey:@"attentionDebtId"]];
            if(str.length)
            {
                _collectNum = 1;
                _collectId = [NSString stringWithFormat:@"%@",[dics objectForKey:@"attentionDebtId"]];
                [_collectBtn setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
            }
            
        } else if (_num == 5){
            
            [SVProgressHUD showSuccessWithStatus:[obj objectForKey:@"msg"]];
            _collectNum = 0;
            [_collectBtn setImage:[UIImage imageNamed:@"no_collection"] forState:UIControlStateNormal];
            
        }
        else if (_num == 3)
        {
            //关注用户
            [SVProgressHUD showSuccessWithStatus:[obj objectForKey:@"msg"]];
            NSString *str = [NSString stringWithFormat:@"%@",[obj objectForKey:@"attentionId"]];
            if(str.length)
            {
                _attentionNum = 1;
                _attentionId = [NSString stringWithFormat:@"%@",[obj objectForKey:@"attentionId"]];
                [_attBtn setTitle:@"取消关注" forState:UIControlStateNormal];
            }
            
        }else if (_num == 4){
            //取消用户
            [SVProgressHUD showSuccessWithStatus:[obj objectForKey:@"msg"]];
            _attentionNum = 0;
            [_attBtn setTitle:@"+关注" forState:UIControlStateNormal];
        }

    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
    }else{
        
        DLOG(@"返回失败===========%@",[obj objectForKey:@"msg"]);
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
    
  [SVProgressHUD showErrorWithStatus:@"无可用网络"];

}



#pragma mark UItableViewdelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [tableArr count]+1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 5.0f;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 95.0f;
    }
    else
        return 35.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 5.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        
        static  NSString *cellID = @"cellid";
        CreditorDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[CreditorDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([_borrowerheadImg hasPrefix:@"http"]) {
           
            [cell.HeadimgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_borrowerheadImg]]];
        }else{
        
         [cell.HeadimgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Baseurl,_borrowerheadImg]]];
        
        }
       
        if ([_VipStr isEqualToString:@"1"]) {
            cell.vipView.image = [UIImage imageNamed:@"member_vip"];
        }else{
            
            cell.vipView.image = [UIImage imageNamed:@"member_no_vip"];
            
        }
        
        if(_attentionNum){
            
            [cell.attentionBtn setTitle:@"取消关注" forState:UIControlStateNormal];
            
        }
        
        cell.NameLabel.text = [NSString stringWithFormat:@"%@***", [_borrowername substringWithRange:NSMakeRange(0, 1)]];
        cell.BorrowsucceedLabel.text = _BorrowsucceedStr;
        cell.BorrowfailLabel.text = _BorrowfailStr;
        cell.repaymentnormalLabel.text = _repaymentnormalStr;
        cell.repaymentabnormalLabel.text = _repaymentabnormalStr;
        if ([_creditRating hasPrefix:@"http"]) {
           
            [cell.LevelimgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_creditRating]]];
        }else
        {
            [cell.LevelimgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Baseurl,_creditRating]]];
        }
        
        [cell.attentionBtn addTarget:self action:@selector(attentionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.ReportBtn setImage:[UIImage imageNamed:@"loan_report"] forState:UIControlStateNormal];
        [cell.ReportBtn addTarget:self action:@selector(ReportBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.MailBtn setImage:[UIImage imageNamed:@"Loan_mail"] forState:UIControlStateNormal];
        [cell.MailBtn addTarget:self action:@selector(MailBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *expanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        expanBtn.frame = CGRectMake(self.view.frame.size.width-30, 35, 25, 20);
        [expanBtn setImage:[UIImage imageNamed:@"cell_more_btn"] forState:UIControlStateNormal];
        [expanBtn setTag:100];
        expanBtn.userInteractionEnabled = NO;
        [cell addSubview:expanBtn];
        
        return cell;
        
    }else {
        
        
        NSString *cellID2 = @"cellid2";
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2];
        }
        cell.textLabel.text = [tableArr objectAtIndex:indexPath.section-1];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIButton *expanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        expanBtn.frame = CGRectMake(self.view.frame.size.width-30, 8, 25, 20);
        [expanBtn setImage:[UIImage imageNamed:@"expan_down_btn"] forState:UIControlStateNormal];
        [expanBtn setImage:[UIImage imageNamed:@"expand_up_btn"] forState:UIControlStateSelected];
        [expanBtn setTag:indexPath.section];
        expanBtn.userInteractionEnabled = NO;
        if (indexPath.section == 2) {
            
            [expanBtn setImage:[UIImage imageNamed:@"cell_more_btn"] forState:UIControlStateNormal];
            
        }
        
        [cell addSubview:expanBtn];
        return cell;
        
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIFolderTableView *folderTableView = (UIFolderTableView *)tableView;
    
    UITableViewCell *cell1 = [_listView cellForRowAtIndexPath:indexPath];
    UIButton *btn = (UIButton *)[cell1 viewWithTag:indexPath.section];
    
    if (btn.selected==0) {
        btn.selected = 1;
    }
    
    
    
    switch (indexPath.section) {
        case 0:
        {
            BorrowerInfoViewController *BorrowerInfoView = [[BorrowerInfoViewController alloc] init];
            BorrowerInfoView.borrowerID = _borrowerId;
            BorrowerInfoView.creditorId = _creditorId;
            BorrowerInfoView.outTimeNum = _outTimeNum;
            BorrowerInfoView.status = _status;
            [self.navigationController pushViewController:BorrowerInfoView animated:NO];
           
            
        }
            break;
            
        case 1:
        {

            TransferSnapshotViewController *TransferSnapshotView = [[TransferSnapshotViewController alloc] init];
            _listView.scrollEnabled = NO;
            TransferSnapshotView.borrowingStr = _borrowingStr;
            TransferSnapshotView.principalStr = _principalStr;
            TransferSnapshotView.YearRateStr = _YearRateStr;
            TransferSnapshotView.interestStr = _interestStr;
            TransferSnapshotView.receivedStr =_receivedStr;
            TransferSnapshotView.remainingStr = _remainingStr;
            TransferSnapshotView.collectedStr = _collectedStr;
            if (_isoverdue) {
                 TransferSnapshotView.overdueStr =@"逾期";
            }else{
                TransferSnapshotView.overdueStr =@"无逾期";
            
            }
           
            TransferSnapshotView.timeStr = _timeStr;
            [folderTableView openFolderAtIndexPath:indexPath WithContentView:TransferSnapshotView.view
                                         openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                             // opening actions
                                             //[self CloseAndOpenACtion:indexPath];
                                              btn.selected = !btn.selected;
                                         }
                                        closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                            // closing actions
                                          
                                        }
                                   completionBlock:^{
                                       // completed actions
                                       _listView.scrollEnabled = YES;
                                   }];

            
        }
            break;
        case 2:
        {
            
            btn.selected = 0;
            AuctionRecordViewController *AuctionRecordView = [[AuctionRecordViewController alloc] init];
            AuctionRecordView.creditorId = _creditorId;
            AuctionRecordView.outTimeNum = _outTimeNum;
            AuctionRecordView.status = _status;
            [self.navigationController pushViewController:AuctionRecordView animated:YES];
            
//            DetailsDescriptionViewController *DetailsDescriptionView = [[DetailsDescriptionViewController alloc] init];
//            
//            NSString *result = nil;
//            
//            if(_borrowDetails!= nil && ![_borrowDetails isEqual:[NSNull null]])
//            {
//                result = [self filterHTML:_borrowDetails];
//                
//            }else{
//                
//                _borrowDetails = @"无更多描述";
//                result = _borrowDetails;
//            }
//            
//            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//            UIFont *font =[UIFont boldSystemFontOfSize:13.0f];
//            NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
//            
//            CGSize labelSize = [result boundingRectWithSize:CGSizeMake(MSWIDTH-30, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
//            
//            _listView.frame = CGRectMake(0, self.listView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height+labelSize.height+10);
//            
//            DetailsDescriptionView.textString = result;
//            DetailsDescriptionView.labelSize =labelSize;
//            
//            _listView.scrollEnabled = NO;
//            [folderTableView openFolderAtIndexPath:indexPath WithContentView:DetailsDescriptionView.view
//                                         openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
//                                             // opening actions
//                                             //[self CloseAndOpenACtion:indexPath];
//                                             btn.selected = !btn.selected;
//                                             
//                                             _ScrollView.contentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height+labelSize.height+tableArr.count*70);
//                                             
//                                         }
//                                        closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
//                                            // closing actions
//                                            //[self CloseAndOpenACtion:indexPath];
//                                            //[cell changeArrowWithUp:NO];
//                                            
//                                        }
//                                   completionBlock:^{
//                                       // completed actions
//                                       _listView.scrollEnabled = YES;
//                                   }];
//            
        
     
            
        }
            
            break;
        case 3:
        {
            
            
            MaterialAuditSubjectViewController *MaterialAuditSubjectView = [[MaterialAuditSubjectViewController alloc] init];
            _listView.scrollEnabled = NO;
            
            MaterialAuditSubjectView.view.frame = CGRectMake(0, 0, 1000, [_AuditdataArr count]*30+30);
            for (int i = 0; i<[_AuditdataArr count]; i++) {
                
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5+35*i, 100, 30)];
                titleLabel.font = [UIFont systemFontOfSize:13.0f];
                titleLabel.textAlignment = NSTextAlignmentCenter;
                titleLabel.text = [_AuditdataArr objectAtIndex:i];
                [MaterialAuditSubjectView.view addSubview:titleLabel];
                
                UIButton *lookBtn = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
                [lookBtn setTag:i+100];
                [lookBtn setFrame:CGRectMake(MSWIDTH-70, 5+35*i, 80, 30)];
                
                NSString *temp = [NSString stringWithFormat:@"%@", [_isVisibleArray objectAtIndex:i]];
                if([[_imgpathArr objectAtIndex:i] isEqual:[NSNull null]] || [temp isEqualToString:@"0"])
                {
                    [lookBtn setTitle:@"不可见" forState:UIControlStateNormal];
                    lookBtn.userInteractionEnabled = NO;
                }else {
                    [lookBtn setTitle:@"查看" forState:UIControlStateNormal];
                }
                
                [lookBtn setTintColor:[UIColor grayColor]];
                lookBtn.titleLabel.textColor = [UIColor grayColor];
                [lookBtn addTarget:self action:@selector(LookBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [MaterialAuditSubjectView.view addSubview:lookBtn];
                
                
                UIImageView *stateView = [[UIImageView alloc] initWithFrame:CGRectMake(130, 8+35*i, 25, 25)];
                [stateView setTag:i+100];
                
                
                UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(165, 0+35*i, 90, 40)];
                [stateLabel setTag:i+100];
                stateLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13.0f];
                
                
                if ([[_auditStatusArr objectAtIndex:i] isEqualToString:@"通过审核"]) {
                    [stateView setImage:[UIImage imageNamed:@"loan_pass"]];
                    stateLabel.text = @"通过审核";
                    stateLabel.textColor = BrownColor;
                }
                else if ([[_auditStatusArr objectAtIndex:i] isEqualToString:@"审核中"])
                {
                    [stateView setImage:[UIImage imageNamed:@"loan_wait"]];
                    stateLabel.text = @"审核中";
                    stateLabel.textColor = [UIColor grayColor];
                    
                    
                }else if([[_auditStatusArr objectAtIndex:i] isEqualToString:@"未通过审核"])
                {
                    
                    [stateView setImage:[UIImage imageNamed:@"loan_nopass"]];
                    stateLabel.text = @"未通过";
                    stateLabel.textColor = [UIColor grayColor];
                    
                    
                }else if([[_auditStatusArr objectAtIndex:i] isEqualToString:@"过期失效"])
                {
                    
                    [stateView setImage:[UIImage imageNamed:@"loan_nopass"]];
                    stateLabel.text = @"过期失效";
                    stateLabel.textColor = [UIColor grayColor];
                    
                    
                }else if([[_auditStatusArr objectAtIndex:i] isEqualToString:@"未提交"])
                {
                    
                    [stateView setImage:[UIImage imageNamed:@"loan_nopass"]];
                    stateLabel.text = @"未提交";
                    stateLabel.textColor = [UIColor grayColor];
                    
                    
                }
                
                [MaterialAuditSubjectView.view addSubview:stateView];
                [MaterialAuditSubjectView.view addSubview:stateLabel];
                
                
            }

            [folderTableView openFolderAtIndexPath:indexPath WithContentView:MaterialAuditSubjectView.view
                                         openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                             // opening actions
                                             //[self CloseAndOpenACtion:indexPath];
                                              btn.selected = !btn.selected;
                                         }
                                        closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                            // closing actions
                                            //[self CloseAndOpenACtion:indexPath];
                                            //[cell changeArrowWithUp:NO];
                                        }
                                   completionBlock:^{
                                       // completed actions
                                       _listView.scrollEnabled = YES;
                                   }];

            
        }
            break;
        case 4:
        {
            
            CBORiskControlSystemViewController *CBORiskControlSystemView = [[CBORiskControlSystemViewController alloc] init];
// 增加内容高度判断
            
            if(_CBOAuditStr!= nil && ![_CBOAuditStr isEqual:[NSNull null]])
            {
                CBORiskControlSystemView.CBOtextString= _CBOAuditStr;
                
            }else{
                
                _CBOAuditStr = @"暂无审核情况";
                CBORiskControlSystemView.CBOtextString = _CBOAuditStr;
            }
            //判断内容尺寸
            CGSize maxSize = CGSizeMake(MSWIDTH-60, 10000);
            CGSize ViewSize = [_CBOAuditStr boundingRectWithSize:maxSize
                                                         options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0f]}
                                                         context:nil].size;
            
            CBORiskControlSystemView.view.frame = CGRectMake(0, 0, MSWIDTH, ViewSize.height+10);
            CBORiskControlSystemView.textlabel.frame = CGRectMake(30, 0, MSWIDTH-60, ViewSize.height+8);

            _listView.scrollEnabled = NO;
            [folderTableView openFolderAtIndexPath:indexPath WithContentView:CBORiskControlSystemView.view
                                         openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                             // opening actions
                                             //[self CloseAndOpenACtion:indexPath];
                                              btn.selected = !btn.selected;
                                         }
                                        closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                            // closing actions
                                            //[self CloseAndOpenACtion:indexPath];
                                            //[cell changeArrowWithUp:NO];
                                        }
                                   completionBlock:^{
                                       // completed actions
                                       _listView.scrollEnabled = YES;
                                       
                                       
                                   }];
            
            
         //
        }
            break;
            
            
        case 5:
        {
            
            
            
            HistoricalRecordViewController *HistoricalRecordView = [[HistoricalRecordViewController alloc] init];
            HistoricalRecordView.timeString = _registrationTime;
            HistoricalRecordView.successfulnumString = [NSString stringWithFormat:@"%@  次",_SuccessBorrowNum];
            HistoricalRecordView.normalnumString = [NSString stringWithFormat:@"%@  次",_NormalRepaymentNum];
            HistoricalRecordView.limitnumString = [NSString stringWithFormat:@"%@  次",_OverdueRepamentNum];
            HistoricalRecordView.repaymentString = [NSString stringWithFormat:@"%@  元",_reimbursementAmount];
            HistoricalRecordView.borrowString = [NSString stringWithFormat:@"%@  元",_BorrowingAmount];
            HistoricalRecordView.tendernumString = [NSString stringWithFormat:@"%@  次",_FinancialBidNum];
            HistoricalRecordView.receiptString = [NSString stringWithFormat:@"%@  元",_paymentAmount];
            
            _listView.scrollEnabled = NO;
            [folderTableView openFolderAtIndexPath:indexPath WithContentView:HistoricalRecordView.view
                                         openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                             // opening actions
                                             //[self CloseAndOpenACtion:indexPath];
                                              btn.selected = !btn.selected;
                                         }
                                        closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                            // closing actions
                                            //[self CloseAndOpenACtion:indexPath];
                                            //[cell changeArrowWithUp:NO];
                                        }
                                   completionBlock:^{
                                       // completed actions
                                       _listView.scrollEnabled = YES;
                                   }];

          

        }
            break;
            
            
        case 6:
       {
           TenderAwardViewController *TenderAwardView = [[TenderAwardViewController alloc] init];
//           TenderAwardView.awardString = @"500000.00";
           
           
           UILabel *textlabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 120, 30)];
          
           textlabel1.font = [UIFont boldSystemFontOfSize:13.0f];
           textlabel1.textColor = [UIColor grayColor];
          
           
           UILabel *textlabel3 = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, 260, 30)];
           textlabel3.font = [UIFont systemFontOfSize:13.0f];
           textlabel3.textColor = [UIColor redColor];
           
           
           
           UILabel *textlabel2 = [[UILabel alloc] initWithFrame:CGRectMake(155, 20, 260, 30)];
           
           textlabel2.font = [UIFont boldSystemFontOfSize:13.0f];
           textlabel2.textColor = [UIColor grayColor];
           
           if([_awardString isEqualToString:@"0"])
           {
           
            textlabel2.text = @"不设置奖励";
               textlabel2.frame = CGRectMake(20, 20, 260, 30);
           
           }else{
           
            textlabel1.text = @"固定奖金";
            textlabel2.text = @"元，按投标比例分配。";
            textlabel3.text = _awardString;
               NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
               UIFont *font = [UIFont boldSystemFontOfSize:13.0f];
               NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
               
               
               CGSize _label3Sz = [textlabel3.text boundingRectWithSize:CGSizeMake(999, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
               CGSize _label2Sz = [textlabel2.text boundingRectWithSize:CGSizeMake(999, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
               
               textlabel3.frame = CGRectMake(80, 20,  _label3Sz.width+5, 30);
               textlabel2.frame = CGRectMake(textlabel3.frame.origin.x + textlabel3.frame.size.width+10, 20, _label2Sz.width + 15, 30);
           
           }
           
         
           
      
           
           [TenderAwardView.view addSubview:textlabel1];
           [TenderAwardView.view addSubview:textlabel3];
           [TenderAwardView.view addSubview:textlabel2];
           
           _listView.scrollEnabled = NO;
           [folderTableView openFolderAtIndexPath:indexPath WithContentView:TenderAwardView.view
                                        openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                            // opening actions
                                            //[self CloseAndOpenACtion:indexPath];
                                             btn.selected = !btn.selected;
                                        }
                                       closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                           // closing actions
                                           //[self CloseAndOpenACtion:indexPath];
                                           //[cell changeArrowWithUp:NO];
                                       }
                                  completionBlock:^{
                                      // completed actions
                                      _listView.scrollEnabled = YES;
                                  }];
    
        }
            break;
            

            
      case 7:
        {
            btn.selected = 0;
            AuctionRecordViewController *AuctionRecordView = [[AuctionRecordViewController alloc] init];
            AuctionRecordView.creditorId = _creditorId;
            AuctionRecordView.outTimeNum = _outTimeNum;
            [self.navigationController pushViewController:AuctionRecordView animated:YES];
        
        
        }
            
        break;
            
    }
    
    
}

-(void)CloseAndOpenACtion:(NSIndexPath *)indexPath
{
    if ([indexPath isEqual:self.selectIndex]) {
        self.isOpen = NO;
        [self didSelectCellRowFirstDo:NO nextDo:NO];
        self.selectIndex = nil;
    }
    else
    {
        if (!self.selectIndex) {
            self.selectIndex = indexPath;
            [self didSelectCellRowFirstDo:YES nextDo:NO];
            
        }
        else
        {
            [self didSelectCellRowFirstDo:NO nextDo:YES];
        }
    }
}
- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert
{
    self.isOpen = firstDoInsert;
    
    if (nextDoInsert) {
        self.isOpen = YES;
        self.selectIndex = [_listView indexPathForSelectedRow];
        [self didSelectCellRowFirstDo:YES nextDo:NO];
    }
}

#pragma mark 竞拍按钮
- (void)auctionBtnClick
{

    if (AppDelegateInstance.userInfo == nil) {
        
          [ReLogin goLogin:self];
        
    }else {
        
        DLOG(@"竞拍按钮！！！");
        AuctionViewController *auctionView = [[AuctionViewController alloc] init];
        auctionView.creditorId = _creditorId;
        auctionView.debtNo = debtNo;
        [self.navigationController pushViewController:auctionView animated:YES];
        
    }
}

#pragma mark 查看按钮
- (void)LookBtnClick:(UIButton *)btn
{
    
    DLOG(@"点击了查看按钮%ld", (long)btn.tag);
    
    if ([_imgpathArr objectAtIndex:btn.tag-100]) {
        scrollPanel = [[UIView alloc] initWithFrame:self.view.bounds];
        scrollPanel.backgroundColor = [UIColor lightGrayColor];
        scrollPanel.alpha = 0;
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 80, self.view.frame.size.width - 20, 370)];
        if ([[_imgpathArr objectAtIndex:btn.tag-100] hasPrefix:@"http"]) {
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_imgpathArr objectAtIndex:btn.tag-100]]]];
        }else{
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Baseurl,[_imgpathArr objectAtIndex:btn.tag-100]]]];
        }
        
        [imageView addGestureRecognizer:tap];
        [imageView setUserInteractionEnabled:YES];
        [scrollPanel addSubview:imageView];
        
        [self.view bringSubviewToFront:scrollPanel];
        scrollPanel.alpha = 1.0;
        [self.view addSubview:scrollPanel];
        
        
    }
    
}

#pragma 退出证件查看
-(void)tapClick
{
    
    [scrollPanel removeFromSuperview];
    
}

#pragma mark 关注按钮
- (void)attentionBtnClick:(UIButton *)btn
{
     _attBtn = btn;
    if (AppDelegateInstance.userInfo == nil) {
         [ReLogin outTheTimeRelogin:self];        
    }
    else
    {
        
        DLOG(@"关注按钮");
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
         if(_attentionNum == 0){
             
            _num = 3;
            //关注接口
            [parameters setObject:@"71" forKey:@"OPT"];
            [parameters setObject:@"" forKey:@"body"];
            [parameters setObject:[NSString stringWithFormat:@"%@",_debtUserIdSign] forKey:@"debtUserIdSign"];
            [parameters setObject:[NSString stringWithFormat:@"%@",AppDelegateInstance.userInfo.userId] forKey:@"id"];
             
         }else{
             
             _num = 4;
             //取消关注接口
             [parameters setObject:@"150" forKey:@"OPT"];
             [parameters setObject:@"" forKey:@"body"];
             [parameters setObject:_attentionId forKey:@"attentionId"];
             
             
         }
        
        if (_requestClient == nil) {
            _requestClient = [[NetWorkClient alloc] init];
            _requestClient.delegate = self;
         
        }
        [_requestClient requestGet:@"app/services" withParameters:parameters];

    }
    
}

#pragma mark 信件按钮
- (void)MailBtnClick
{
    if (AppDelegateInstance.userInfo == nil) {
    
          [ReLogin outTheTimeRelogin:self];        
    }else {
        
        DLOG(@"信件按钮");
        SendMessageViewController *SendMessageView = [[SendMessageViewController alloc] init];
        SendMessageView.borrowName = _borrowername;
        SendMessageView.borrowerid = _borrowerId;
        [self.navigationController pushViewController:SendMessageView animated:YES];
        
    }
}

#pragma mark 举报按钮
- (void)ReportBtnClick
{
    
    if (AppDelegateInstance.userInfo == nil) {
        
          [ReLogin outTheTimeRelogin:self];        
    }else {
        
        DLOG(@"举报按钮");
        ReportTwoViewController *reportView = [[ReportTwoViewController alloc] init];
        reportView.bidIdSign = _borrowid;
        reportView.borrowName = _borrowername;
        reportView.debtUserIdSign = _debtUserIdSign;
        reportView.reportName = AppDelegateInstance.userInfo.userName;
        [self.navigationController pushViewController:reportView animated:YES];
    }
}


#pragma mark 收藏按钮
bool collectBtnSelected = NO;
- (void)collectBtnClick:(UIButton *)btn
{
    if (AppDelegateInstance.userInfo == nil) {
        
         [ReLogin outTheTimeRelogin:self];    
    }else {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        if(_collectNum ==0)
        {
            _num = 2;
            //收藏债权标接口
            [parameters setObject:@"73" forKey:@"OPT"];
            [parameters setObject:@"" forKey:@"body"];
            [parameters setObject:[NSString stringWithFormat:@"%@",_borrowid] forKey:@"sign"];
            [parameters setObject:[NSString stringWithFormat:@"%@",AppDelegateInstance.userInfo.userId] forKey:@"id"];
            
        }else{
            
            _num = 5;
            //取消收藏接口
            [parameters setObject:@"154" forKey:@"OPT"];
             [parameters setObject:@"" forKey:@"body"];
            [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"userId"];
            [parameters setObject:_collectId forKey:@"attentionDebtId"];
        
        }
        
        if (_requestClient == nil) {
            _requestClient = [[NetWorkClient alloc] init];
            _requestClient.delegate = self;
           
        }
         [_requestClient requestGet:@"app/services" withParameters:parameters];
    }
    
}

#pragma  分享按钮
- (void)ShareClick
{
    if (AppDelegateInstance.userInfo == nil) {
        
          [ReLogin outTheTimeRelogin:self];        
    }else {
        DLOG(@"分享按钮");
        
//        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"];
        
        NSString *shareUrl = [NSString stringWithFormat:@"%@/front/debt/debtDetails?debtId=%@", Baseurl, _creditorId];
        DLOG(@"shareUrl -> %@", shareUrl);
        
        //构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:@"一路捞 债权标详情"
                                           defaultContent:@"默认分享内容，没内容时显示"
                                                    image:[ShareSDK pngImageWithImage:[UIImage imageNamed:@"logo"]]
                                                    title:@"一路捞 债权标"
                                                      url:shareUrl
                                              description:@"债权详情"
                                                mediaType:SSPublishContentMediaTypeNews];
        
        [ShareSDK showShareActionSheet:nil
                             shareList:nil
                               content:publishContent
                         statusBarTips:YES
                           authOptions:nil
                          shareOptions: nil
                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                    if (state == SSResponseStateSuccess)
                                    {
                                        DLOG(@"分享成功");
                                    }
                                    else if (state == SSResponseStateFail)
                                    {
                                        DLOG(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]]];
                                    }
                                }];
    }
}


#pragma mark 倒计时
- (void)timeDown:(NSString *)timeStr
{
    //剩余时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    NSDate *senddate=[NSDate date];
    //结束时间
    NSDate *endDate = [dateFormatter dateFromString:timeStr];
    //当前时间
    NSDate *senderDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:senddate]];
    //得到相差秒数
    _time=[endDate timeIntervalSinceDate:senderDate];
    int days = ((int)_time)/(3600*24);
    int hours = ((int)_time)%(3600*24)/3600;
    int minute = ((int)_time)%(3600*24)%3600/60;
    int seconds = ((int)_time)%(3600*24)%3600%60;
    
    if (days <= 0&&hours <= 0&&minute <= 0&&seconds<=0)
    {
        [_dateLabel2 removeFromSuperview];
        [_clockimg removeFromSuperview];
        [_dateBackView removeFromSuperview];
        [_dateLabel1 removeFromSuperview];
        
        _detailView.frame = CGRectMake(0, 80, MSWIDTH, 50);
        
        _listView.frame = CGRectMake(0, 140, MSWIDTH, 800);
        
        _outTimeNum = 1;
        [_bottomView removeFromSuperview];
    }
    else
    {
        _dateLabel2.text = [[NSString alloc] initWithFormat:@"%i天%i小时%i分%i秒",days,hours,minute,seconds];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod) userInfo:nil repeats:YES];
    }
    
    
}


- (void)timerFireMethod
{
    
    _time--;
    int days = ((int)_time)/(3600*24);
    int hours = ((int)_time)%(3600*24)/3600;
    int minute = ((int)_time)%(3600*24)%3600/60;
    int seconds = ((int)_time)%(3600*24)%3600%60;
    
    if (days <= 0&&hours <= 0&&minute <= 0&&seconds<=0)
    {
        [_dateLabel2 removeFromSuperview];
        [_clockimg removeFromSuperview];
        [_dateBackView removeFromSuperview];
        [_dateLabel1 removeFromSuperview];
        
        _detailView.frame = CGRectMake(0, 80, MSWIDTH, 50);
        
        _listView.frame = CGRectMake(0, 140, MSWIDTH, 800);
        
        _outTimeNum = 1;
        [_bottomView removeFromSuperview];
    }
    else
    {
        _dateLabel2.text = [[NSString alloc] initWithFormat:@"%i天%i小时%i分%i秒",days,hours,minute,seconds];
        
    }
}


#pragma 返回按钮触发方法
- (void)backClick
{
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
    // DLOG(@"返回按钮");
    [super setHidesBottomBarWhenPushed:NO];
    [self.navigationController popViewControllerAnimated:YES];
    
}


// *******  去掉 html字符串中所有标签  **********
- (NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    
    NSString * text = nil;
    
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    
    html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    
    return html;
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}
@end

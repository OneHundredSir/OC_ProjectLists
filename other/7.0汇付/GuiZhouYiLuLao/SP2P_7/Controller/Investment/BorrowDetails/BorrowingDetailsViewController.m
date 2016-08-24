//
//  BorrowingDetailsViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-7-1.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  借款详情
#import "BorrowingDetailsViewController.h"
#import "LDProgressView.h"
#import "ColorTools.h"
#import "BorrowDetailsCell.h"
#import "TenderOnceViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "UIFolderTableView.h"
#import "DetailsDescriptionViewController.h"
#import "MaterialAuditSubjectViewController.h"
#import "CBORiskControlSystemViewController.h"
#import "HistoricalRecordViewController.h"
#import "TenderAwardViewController.h"
#import "TenderRecordsViewController.h"
#import "AskBorrowerViewController.h"
#import "BorrowerInformationViewController.h"
#import "InterestcalculatorViewController.h"
#import "ReportViewController.h"
#import "SendMessageViewController.h"
#import "LiteratureAuditViewController.h"
#import "BorrowingBillViewController.h"
#import "FinancialBillsViewController.h"

@interface BorrowingDetailsViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,HTTPClientDelegate>
{
    
    NSArray *titleArr;
    NSArray *tableArr;
    NSMutableArray *_collectionArrays;
    UIView *scrollPanel;
    NSInteger num2;
    NSString *headertitles;
    NSString *borrowImgUrl;
    NSInteger _attentionNum;
    NSInteger _collectNum;
    
    float _paceNum;
    
    NSString *bidAmout;     // 投标金额
    float apr;          // 年利率
    float deadLine;     // 投标期限
    int repayType;    // 还款方式
    int deadperiodUnit;    // 投标类型（-1：年  0：月  1：日）
    int deadType;     // 投标奖励类型
    NSString *deadValue;    // 投标奖励
    float bonus;
    float awardScale;
    NSString *noId;    // 编号
}

@property (nonatomic, strong) UIFolderTableView *listView;
//  是否打开二级详情
@property (assign)BOOL isOpen;
@property (nonatomic,retain)NSIndexPath *selectIndex;

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIScrollView *ScrollView;
@property (nonatomic,strong)LDProgressView *progressView;
@property (nonatomic,strong)UILabel *progressLabel;

@property (nonatomic,strong)UILabel *usageLabel;
@property (nonatomic,strong)UIImageView *typeImg;
@property (nonatomic,strong)UILabel *wayLabel;
@property (nonatomic,strong)NSString *associatesStr;
@property (nonatomic,strong)NSString *CBOAuditStr;
@property (nonatomic,strong)UILabel *moneyLabel;
@property (nonatomic,strong)UILabel *rateLabel;
@property (nonatomic,strong)UILabel *deadlineLabel;
@property (nonatomic,strong)UILabel *dateLabel;
@property (nonatomic,strong)UILabel *dateLabel2;
@property (nonatomic,copy)NSString *borrowerId;
@property (nonatomic,copy)NSString *attentionId;
@property (nonatomic,copy)NSString *collectId;
@property (nonatomic,copy)NSString   *borrowerheadImg;
@property (nonatomic,copy)NSString   *borrowername;
@property (nonatomic,copy)NSString   *borrowid;
@property (nonatomic,copy)NSString   *borrowId;
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
@property (nonatomic,assign)NSInteger   statuNum;
@property (nonatomic,strong)NSMutableArray  *AuditdataArr;
@property (nonatomic,strong)NSMutableArray  *auditStatusArr;
@property (nonatomic,strong)NSMutableArray  *imgpathArr;
@property (nonatomic,copy)NSString  *bidIdSign;
@property (nonatomic,copy)NSString  *bidUserIdSign;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *organizationtextLabel;//合作机构
@property (nonatomic,strong)UILabel  *stateLabel;
@property (nonatomic)NSTimeInterval time;//相差时间
@property (nonatomic,strong)UIImageView *roundimgView;
@property(nonatomic ,strong) NetWorkClient *requestClient;
@property(nonatomic ,strong) UIButton *attBtn;
@property(nonatomic ,strong) UIButton *collectBtn;
@property(nonatomic ,strong) UIView *bottomView;
@property (nonatomic,strong) UILabel *idLabel; // 编号
@property (nonatomic,copy) NSMutableAttributedString *repayRecordStr; //贷款记录
@property (nonatomic,copy) NSMutableAttributedString *borrowRecordStr; //还款记录

@property (nonatomic,strong)NSMutableArray  *isVisibleArray;    // 是否可查看

@property (nonatomic,strong) UIView *dateBackView;
@property (nonatomic,strong) UIImageView *clockImg;
@property (nonatomic,strong) UILabel *dateLabel1;

@end

@implementation BorrowingDetailsViewController

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
    //投标成功刷新通知注册
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestdata) name:@"investRefresh" object:nil];
    // 初始化数据
    self.isOpen = NO;
    
    //初始化网络数据
    [self initData];
    
    // 初始化视图
    [self initView];
    
}

/**
 * 初始化数据
 */
- (void)initData
{
    _attentionNum = 0;
    _collectNum = 0;
    _paceNum = 0;
    _attentionId = [[NSString alloc] init];
    titleArr = @[@"拟筹资金额:   ",@"年化收益率:  ",@"利益分享方式:",@"用款周期:",@"还款日期:"];
    tableArr = @[@"详情描述",@"历史记录",@"附加利益",@"本项目众筹情况"];//,@"项目情况公示",@"必要材料审核科目",@"CBO风控体系审核"
    
    //展开行数组
    _collectionArrays =[[NSMutableArray alloc] init];
    _AuditdataArr = [[NSMutableArray alloc] init];
    _auditStatusArr = [[NSMutableArray alloc] init];
    _imgpathArr = [[NSMutableArray alloc] init];
    _isVisibleArray = [[NSMutableArray alloc] init];
    [self requestdata];
    
}

-(void)requestdata
{
    num2 = 1;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //2.2借款详情接口[借款详情详细信息]
    [parameters setObject:@"11" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:[NSString stringWithFormat:@"%@",_borrowID] forKey:@"borrowId"];
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
    _ScrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 920)];
    _ScrollView.userInteractionEnabled = YES;
    _ScrollView.scrollEnabled = YES;
    _ScrollView.showsHorizontalScrollIndicator = NO;
    _ScrollView.showsVerticalScrollIndicator = NO;
    _ScrollView.delegate = self;
    _ScrollView.backgroundColor = KblackgroundColor;
    _ScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1080);
    [self.view addSubview:_ScrollView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, MSWIDTH - 120, 35)];
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    _titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = BluewordColor;
    [_ScrollView addSubview:_titleLabel];
    
    //    UILabel *idtextLabel = [[UILabel alloc] initWithFrame:CGRectMake(225, 10, 80, 30)];
    //    idtextLabel.text = @"编号:";
    //    idtextLabel.textColor = [UIColor lightGrayColor];
    //    idtextLabel.font = [UIFont systemFontOfSize:12.0f];
    //    idtextLabel.textAlignment = NSTextAlignmentLeft;
    //    [_ScrollView addSubview:idtextLabel];
    
    _idLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 40, 30)];
    _idLabel.textColor = [UIColor grayColor];
    _idLabel.font = [UIFont systemFontOfSize:13.0f];
    _idLabel.adjustsFontSizeToFitWidth = YES;
    _idLabel.textAlignment = NSTextAlignmentRight;
    [_ScrollView addSubview:_idLabel];
    
    //    _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 38, 40, 20)];
    //    _stateLabel.textColor = [UIColor whiteColor];
    //    _stateLabel.adjustsFontSizeToFitWidth = YES;
    //    _stateLabel.textAlignment = NSTextAlignmentCenter;
    //    _stateLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    //    _stateLabel.backgroundColor = BrownColor;
    //    _stateLabel.layer.cornerRadius = 5.0f;
    //    _stateLabel.layer.masksToBounds = 0;
    //    [_ScrollView addSubview:_stateLabel];
    
    //    _usageLabel = [[UILabel alloc] initWithFrame:CGRectMake(69, 38, 52, 20)];
    //    _usageLabel.textColor = [UIColor darkGrayColor];
    //    _usageLabel.adjustsFontSizeToFitWidth = YES;
    //    _usageLabel.textAlignment = NSTextAlignmentCenter;
    //    _usageLabel.backgroundColor = [UIColor whiteColor];
    //    _usageLabel.font = [UIFont boldSystemFontOfSize:11.0f];
    //    [_ScrollView addSubview:_usageLabel];
    
    
    _typeImg = [[UIImageView alloc] initWithFrame:CGRectMake(MSWIDTH - 60, 10, 20, 20)];
    _typeImg.backgroundColor = [UIColor clearColor];
    [_ScrollView addSubview:_typeImg];
    
    
    _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _collectBtn.frame = CGRectMake(MSWIDTH - 30, 10, 20, 20);
    [_collectBtn setImage:[UIImage imageNamed:@"no_collection"] forState:UIControlStateNormal];
    [_collectBtn addTarget:self action:@selector(collectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_ScrollView addSubview:_collectBtn];
    
    
    _progressView = [[LDProgressView alloc] initWithFrame:CGRectMake(15, 50, self.view.frame.size.width - 55, 4)];
    //    _progressView = [[LDProgressView alloc] initWithFrame:CGRectMake(15, 70, 265, 4)];
    _progressView.color = GreenColor;
    _progressView.flat = @YES;// 是否扁平化
    _progressView.borderRadius = @0;
    _progressView.showBackgroundInnerShadow = @NO;
    _progressView.animate = @NO;
    _progressView.progressInset = @0;//内边的边距
    _progressView.showBackground = @YES;
    _progressView.outerStrokeWidth = @0;
    _progressView.showText = @NO;
    _progressView.showStroke = @NO;
    _progressView.background = [UIColor lightGrayColor];
    [_ScrollView addSubview:_progressView];
    
    _roundimgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 40, 36, 30, 30)];
//    _roundimgView.image = [UIImage imageNamed:@"round_back"];
    _roundimgView.userInteractionEnabled = NO;
    _roundimgView.layer.cornerRadius = 15;
    _roundimgView.backgroundColor = GreenColor;
    _roundimgView.layer.masksToBounds = YES;
    [_ScrollView addSubview:_roundimgView];
    
    _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 37, 44, 30, 15)];
    _progressLabel.font = [UIFont systemFontOfSize:10];
    _progressLabel.textColor = [UIColor whiteColor];
    _progressLabel.adjustsFontSizeToFitWidth = YES;
    [_ScrollView addSubview:_progressLabel];
    
    for (int i = 0; i<[titleArr count]; i++){
        
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.text = [titleArr objectAtIndex:i];
        textLabel.font = [UIFont systemFontOfSize:12.0f];
        textLabel.textAlignment = NSTextAlignmentLeft;
        if (i==3||i==4) {
            
            textLabel.frame = CGRectMake(155, 70+20*(i-3), 80, 20);
            
        }else {
            textLabel.frame = CGRectMake(10, 70+20*i, 80, 20);
        }
        textLabel.tag = 1000+i;
        [_ScrollView addSubview:textLabel];
        
    }
    
    _organizationtextLabel = [[UILabel alloc] init];
    _organizationtextLabel.font = [UIFont systemFontOfSize:12.0f];
    _organizationtextLabel.textAlignment = NSTextAlignmentRight;
    _organizationtextLabel.frame = CGRectMake(10, 70+20*3, 60, 20);
    [_ScrollView addSubview:_organizationtextLabel];
    
    _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(90,70, 100, 20)];
    _moneyLabel.textColor = PinkColor;
    _moneyLabel.font = [UIFont systemFontOfSize:12.0f];
    [_ScrollView addSubview:_moneyLabel];
    
    _rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 90, 100, 20)];
    _rateLabel.textColor = PinkColor;
    _rateLabel.font = [UIFont systemFontOfSize:12.0f];
    [_ScrollView addSubview:_rateLabel];
    
    _wayLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 110, 140, 20)];
    _wayLabel.textColor = [UIColor darkGrayColor];
    _wayLabel.font = [UIFont systemFontOfSize:12.0f];
    _wayLabel.adjustsFontSizeToFitWidth = YES;
    [_ScrollView addSubview:_wayLabel];
    
    _organizationLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 130, 100, 20)];
    _organizationLabel.textColor = [UIColor darkGrayColor];
    _organizationLabel.font = [UIFont systemFontOfSize:12.0f];
    [_ScrollView addSubview:_organizationLabel];
    
    _deadlineLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 70, 100, 20)];
    _deadlineLabel.textColor = [UIColor darkGrayColor];
    _deadlineLabel.font = [UIFont systemFontOfSize:12.0f];
    [_ScrollView addSubview:_deadlineLabel];
    
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 90, 80, 20)];
    _dateLabel.textColor = [UIColor darkGrayColor];
    _dateLabel.font = [UIFont systemFontOfSize:12.0f];
    [_ScrollView addSubview:_dateLabel];
    
    _dateBackView = [[UIView alloc] initWithFrame:CGRectMake(10, 160, 110, 30)];
    _dateBackView.backgroundColor = PinkColor;
    [_ScrollView addSubview:_dateBackView];
    
    _dateLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(50, 160, 110, 30)];
    _dateLabel1.text = @"剩余时间";
    _dateLabel1.textColor = [UIColor whiteColor];
    _dateLabel1.font = [UIFont boldSystemFontOfSize:14.0f];
    [_ScrollView addSubview:_dateLabel1];
    
    _clockImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 165, 22, 22)];
    _clockImg.image = [UIImage imageNamed:@"clock_big"];
    _clockImg.backgroundColor = [UIColor clearColor];
    [_ScrollView addSubview:_clockImg];
    
    //    _dateLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(120, 180, 190, 30)];
    _dateLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(120, 160, self.view.frame.size.width - 130, 30)];
    _dateLabel2.textColor = PinkColor;
    _dateLabel2.backgroundColor = [UIColor whiteColor];
    _dateLabel2.textAlignment = NSTextAlignmentCenter;
    _dateLabel2.font = [UIFont boldSystemFontOfSize:14.0f];
    [_ScrollView addSubview:_dateLabel2];
    
    _listView = [[UIFolderTableView alloc] initWithFrame:CGRectMake(0, 195, self.view.frame.size.width, 800)  style:UITableViewStyleGrouped];
    _listView.delegate = self;
    _listView.dataSource = self;
    [_listView setBackgroundColor:KblackgroundColor];
    [_ScrollView addSubview:_listView];
    
    //底部背景视图
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 60, MSWIDTH, 60)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    
    
    //    UIButton *calculateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    calculateBtn.frame = CGRectMake(0, 0, 42, 50);
    //    calculateBtn.backgroundColor = BrownColor;
    //    [calculateBtn setImage:[UIImage imageNamed:@"menu_calculator1"] forState:UIControlStateNormal];
    //    [calculateBtn addTarget:self action:@selector(CalculateBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //    [_bottomView addSubview:calculateBtn];
    
    switch (_stateNum) {
        case 0:
        {
            if (AppDelegateInstance.userInfo != nil) {
                _ScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1130);
                
                [self.view insertSubview:_bottomView aboveSubview:_ScrollView];
                
                UIButton *tenderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                tenderBtn.frame = CGRectMake(0, 0, MSWIDTH,60);
                tenderBtn.backgroundColor = BrownColor;
                [tenderBtn setTitle:@"立即投标" forState:UIControlStateNormal];
                [tenderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                tenderBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:18.0];
                [tenderBtn addTarget:self action:@selector(tenderBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [_bottomView addSubview:tenderBtn];
            }
        }
            break;
        case 1:
        {
            _ScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1030);
            
            tableArr = @[@"详情描述",@"历史记录",@"投标奖励"];//,@"必要材料审核科目",@"CBO风控体系审核"
            [_listView reloadData];
            
            [_roundimgView removeFromSuperview];
            [_progressLabel removeFromSuperview];
            [_progressView removeFromSuperview];
            
            if (AppDelegateInstance.userInfo != nil) {
                
                [self.view insertSubview:_bottomView aboveSubview:_ScrollView];
                
                UIButton *tenderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                tenderBtn.frame = CGRectMake(0, 0, MSWIDTH, 60);
                tenderBtn.backgroundColor = BrownColor;
                [tenderBtn setTitle:@"提交资料" forState:UIControlStateNormal];
                [tenderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                tenderBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:18.0];
                [tenderBtn addTarget:self action:@selector(postInfoClick) forControlEvents:UIControlEventTouchUpInside];
                [_bottomView addSubview:tenderBtn];
            }
            
        }
            break;
        case 2:
        {
            tableArr = @[@"详情描述",@"历史记录",@"投标奖励",@"投标记录"];//,@"必要材料审核科目",@"CBO风控体系审核"
            [_listView reloadData];
            
            if (AppDelegateInstance.userInfo != nil) {
                
                [self.view insertSubview:_bottomView aboveSubview:_ScrollView];
                
                UIButton *tenderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                tenderBtn.frame = CGRectMake(0, 0, MSWIDTH, 60);
                tenderBtn.backgroundColor = BrownColor;
                [tenderBtn setTitle:@"提交资料" forState:UIControlStateNormal];
                [tenderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                tenderBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:18.0];
                [tenderBtn addTarget:self action:@selector(postInfoClick) forControlEvents:UIControlEventTouchUpInside];
                [_bottomView addSubview:tenderBtn];
            }
            
        }
            break;
        case 3:
        case 4:
        {
            tableArr = @[@"详情描述",@"历史记录",@"投标奖励",@"投标记录"];//,@"必要材料审核科目",@"CBO风控体系审核"
            [_listView reloadData];
            
            if (AppDelegateInstance.userInfo != nil) {
                
                [self.view insertSubview:_bottomView aboveSubview:_ScrollView];
                
                UIButton *tenderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                tenderBtn.frame = CGRectMake(0, 0, MSWIDTH, 60);
                tenderBtn.backgroundColor = BrownColor;
                [tenderBtn setTitle:@"查看账单" forState:UIControlStateNormal];
                [tenderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                tenderBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:18.0];
                [tenderBtn addTarget:self action:@selector(seeBillClick) forControlEvents:UIControlEventTouchUpInside];
                [_bottomView addSubview:tenderBtn];
                
            }
            
        }
            break;
        case 5:
        {
            if (AppDelegateInstance.userInfo != nil) {
                _ScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1080);
                
                [self.view insertSubview:_bottomView aboveSubview:_ScrollView];
                
                UIButton *tenderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                tenderBtn.frame = CGRectMake(0, 0, MSWIDTH, 60);
                tenderBtn.backgroundColor = BrownColor;
                [tenderBtn setTitle:@"查看账单" forState:UIControlStateNormal];
                [tenderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                tenderBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:18.0];
                [tenderBtn addTarget:self action:@selector(finaBillClick) forControlEvents:UIControlEventTouchUpInside];
                [_bottomView addSubview:tenderBtn];
                
            }
            
        }
            break;
            
    }
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"标的详情";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    // 导航条分享按钮
    UIBarButtonItem *shareItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_share"] style:UIBarButtonItemStyleDone target:self action:@selector(shareClick)];
    shareItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:shareItem];
    
    
}


#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    
}


// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    
    DLOG(@"==返回成功=======%@",obj);
    NSDictionary *dics = obj;
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        if (num2 == 1) {
            
            _titleLabel.text  = [NSString stringWithFormat:@"%@",[dics objectForKey:@"borrowTitle"]];
            _idLabel.text = [dics objectForKey:@"no"];
            if (![[dics objectForKey:@"borrowtype"] isEqual:[NSNull null]]) {
                if ([[dics objectForKey:@"borrowtype"] hasPrefix:@"http"]) {
                    [_typeImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dics objectForKey:@"borrowtype"]]] placeholderImage:[UIImage imageNamed:@"logo"]];
                }else{
                    
                    [_typeImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Baseurl,[dics objectForKey:@"borrowtype"]]] placeholderImage:[UIImage imageNamed:@"logo"]];
                }
            }
            
            //            //借款标状态
            //            _statuNum = [[dics objectForKey:@"borrowStatus"] integerValue];
            //            switch (_statuNum) {
            //                case 1:
            //                case 2:
            //                case 3:
            //                    _stateLabel.text = @"借款中";
            //                    break;
            //                case 4:
            //                     _stateLabel.text = @"还款中";
            //                    break;
            //                case 5:
            //                    _stateLabel.text = @"已还款";
            //                    break;
            //                default:
            //                    _stateLabel.text = @"流 标";
            //                    break;
            //            }
            NSString *str = [NSString stringWithFormat:@"%@",[dics objectForKey:@"attentionId"]];
            if(str.length)
            {
                _attentionNum = 1;
                _attentionId = [NSString stringWithFormat:@"%@",[dics objectForKey:@"attentionId"]];
                
            }
            
            NSString *str2 = [NSString stringWithFormat:@"%@",[dics objectForKey:@"attentionBidId"]];
            if(str2.length)
            {
                _collectNum = 1;
                _collectId = [NSString stringWithFormat:@"%@",[dics objectForKey:@"attentionBidId"]];
                [_collectBtn setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
            }
            
            _progressLabel.text = [NSString stringWithFormat:@"%0.0f%%",[[dics objectForKey:@"schedules"] floatValue]];
            _progressView.progress = [[dics objectForKey:@"schedules"] floatValue]/100;
            _paceNum =  [[dics objectForKey:@"schedules"] floatValue];
            if (_stateNum == 0) {
                
                if ([[dics objectForKey:@"schedules"] floatValue] >= 100.0) {
                    
                    [_bottomView removeFromSuperview];
                }
            }
            
            _wayLabel.text = [dics objectForKey:@"paymentMode"];//还款方式
            _bidIdSign = [dics objectForKey:@"bidIdSign"];//加密ID
            _moneyLabel.text = [NSString stringWithFormat:@"¥%0.0f",[[dics objectForKey:@"borrowAmount"] floatValue]];
            _rateLabel.text = [NSString stringWithFormat:@"%0.1f%%",[[dics objectForKey:@"annualRate"] floatValue]];
            _deadlineLabel.text = [dics objectForKey:@"deadline"]; // 期限
            bidAmout = [NSString stringWithFormat:@"%0.0f",[[dics objectForKey:@"borrowAmount"] floatValue]];
            apr = [[dics objectForKey:@"annualRate"] floatValue];
            deadLine = [[dics objectForKey:@"period"] floatValue]; // 期限
            deadperiodUnit = [[dics objectForKey:@"periodUnit"] intValue]; // 期限类型
            repayType = [[dics objectForKey:@"paymentType"] intValue];    // 还款方式
            deadType = [[dics objectForKey:@"bonusType"] intValue];
            bonus = [[dics objectForKey:@"bonus"] intValue];
            awardScale = [[dics objectForKey:@"awardScale"] intValue];
            
            DLOG(@"deadperiodUnit - >%d", deadperiodUnit);
            
            if(![[dics objectForKey:@"paymentTime"] isEqual:[NSNull null]])
            {
                NSString *dataStr = [dics objectForKey:@"paymentTime"];
                _dateLabel.text =   [dataStr   substringWithRange:NSMakeRange(0,10)];//截取字符串
                
            }else {
                
                _dateLabel.text = nil;
                UILabel *dateLabel = (UILabel*)[_ScrollView viewWithTag:1004];
                [dateLabel removeFromSuperview];
                
            }
            
            //合作机构
            if( ![[dics objectForKey:@"associates"] isEqualToString:@""])
            {
                _organizationLabel.text = [dics objectForKey:@"associates"];
                _organizationtextLabel.text = @"合作机构:";
                
            }
            
            if (_statuNum == 1 || _statuNum == 2 || _statuNum == 3) {
                
                if( [dics objectForKey:@"remainTime"] != nil &&![[dics objectForKey:@"remainTime"] isEqual:[NSNull null]])
                {
                    NSString  *timeStr = [[NSString stringWithFormat:@"%@",[dics objectForKey:@"remainTime"]] substringWithRange:NSMakeRange(0, 19)];
                    [self timeDown:timeStr];
                }
                
            }else {
                
//                _dateBackView.hidden = YES;
//                _dateLabel1.hidden = YES;
//                _clockImg.hidden = YES;
//                _dateLabel2.hidden = YES;
//                _listView.frame = CGRectMake(0, 150, self.view.frame.size.width, 800);
                
            }
            
            // 借款中
            if ([_progressLabel.text isEqualToString:@"100%"])
            {
                _dateBackView.hidden = YES;
                _dateLabel1.hidden = YES;
                _clockImg.hidden = YES;
                _dateLabel2.hidden = YES;
                _listView.frame = CGRectMake(0, 150, self.view.frame.size.width, 800);
            }
            
            if( [dics objectForKey:@"remainTime"] != nil &&![[dics objectForKey:@"remainTime"] isEqual:[NSNull null]])
            {
                
                NSString  *timeStr = [[NSString stringWithFormat:@"%@",[dics objectForKey:@"remainTime"]] substringWithRange:NSMakeRange(0, 19)];
                [self timeDown:timeStr];
            }
            
            
            borrowImgUrl = [NSString stringWithFormat:@"%@",[dics objectForKey:@"imageFilename"]];
            _VipStr = [NSString stringWithFormat:@"%@",[dics objectForKey:@"vipStatus"]];
            //借款详情描述
            _borrowDetails = [dics objectForKey:@"borrowDetails"];
            //CBO审核
            _CBOAuditStr =  [dics objectForKey:@"CBOAuditDetails"];
            _borrowerId = [NSString stringWithFormat:@"%@",[dics objectForKey:@"bidUserIdSign"]];
            _borrowId = [NSString stringWithFormat:@"%@",[dics objectForKey:@"borrowid"]];
            _borrowerheadImg = [dics objectForKey:@"borrowerheadImg"];
            
            //            _idLabel.text = [NSString stringWithFormat:@"%@",[dics objectForKey:@"no"]];
            noId = [NSString stringWithFormat:@"%@",[dics objectForKey:@"no"]];
            
            if( [dics objectForKey:@"borrowername"] != nil &&![[dics objectForKey:@"borrowername"] isEqual:[NSNull null]])
            {
                _borrowername = [dics objectForKey:@"borrowername"];
            }
            
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
            
            //借贷记录
            NSString *borrowStr = [NSString stringWithFormat:@"众筹记录: %@ 次成功, %@ 次失败",_BorrowsucceedStr,_BorrowfailStr];
            //            _borrowRecordLabel.text = borrowStr;
            _borrowRecordStr = [[NSMutableAttributedString alloc] initWithString:borrowStr];
            [_borrowRecordStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(0, borrowStr.length)];
            [_borrowRecordStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, borrowStr.length)];
            NSInteger nameLen = _BorrowsucceedStr.length;
            NSInteger amountLen = _BorrowfailStr.length;
            [_borrowRecordStr addAttribute:NSForegroundColorAttributeName value:BrownColor range:NSMakeRange(6,nameLen)];
            [_borrowRecordStr addAttribute:NSForegroundColorAttributeName value:BrownColor range:NSMakeRange(nameLen+12,amountLen)];
            
            //还款记录
            NSString *repayStr = [NSString stringWithFormat:@"利益分享: %@ 次成功, %@ 次逾期",_repaymentnormalStr,_repaymentabnormalStr];
            _repayRecordStr = [[NSMutableAttributedString alloc] initWithString:repayStr];
            [_repayRecordStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(0, repayStr.length)];
            [_repayRecordStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, repayStr.length)];
            NSInteger fristLen = _repaymentnormalStr.length;
            NSInteger secondLen = _repaymentabnormalStr.length;
            [_repayRecordStr addAttribute:NSForegroundColorAttributeName value:BrownColor range:NSMakeRange(6,fristLen)];
            [_repayRecordStr addAttribute:NSForegroundColorAttributeName value:BrownColor range:NSMakeRange(fristLen+12,secondLen)];
           
            
            //审核科目数组
            if( [dics objectForKey:@"list"] != nil && ![[dics objectForKey:@"list"] isEqual:[NSNull null]])
            {
                _list = [dics objectForKey:@"list"];
                for (NSDictionary* dic in _list) {
                    NSLog(@"isVisible : %@", [dic objectForKey:@"isVisible"]);
                    
                    [_AuditdataArr addObject:[dic  objectForKey:@"AuditSubjectName"]];
                    [_auditStatusArr addObject:[dic  objectForKey:@"statusNum"]];
                    [_imgpathArr addObject:[dic  objectForKey:@"imgpath"]];
                    [_isVisibleArray addObject:[dic  objectForKey:@"isVisible"]];
                }
            }
            
            //历史纪录部分
            if( [dics objectForKey:@"registrationTime"] != nil &&![[dics objectForKey:@"registrationTime"] isEqual:[NSNull null]])
            {
                
                _registrationTime = [[NSString stringWithFormat:@"%@",[dics objectForKey:@"registrationTime"]] substringWithRange:NSMakeRange(0, 19)];
                
            }else{
                _registrationTime = @"";
            }
            
            _SuccessBorrowNum = [NSString stringWithFormat:@"%@",[dics objectForKey:@"SuccessBorrowNum"]];
            _NormalRepaymentNum = [NSString stringWithFormat:@"%@",[dics objectForKey:@"NormalRepaymentNum"]];
            _OverdueRepamentNum = [NSString stringWithFormat:@"%@",[dics objectForKey:@"OverdueRepamentNum"]];
            _reimbursementAmount = [NSString stringWithFormat:@"%@",[dics objectForKey:@"reimbursementAmount"]];
            _BorrowingAmount = [NSString stringWithFormat:@"%@",[dics objectForKey:@"BorrowingAmount"]];
            _FinancialBidNum = [NSString stringWithFormat:@"%@",[dics objectForKey:@"FinancialBidNum"]];
            _paymentAmount = [NSString stringWithFormat:@"%@",[dics objectForKey:@"paymentAmount"]];
            
            //投标奖励
            _awardString = [NSString stringWithFormat:@"%@",[dics objectForKey:@"bonus"]] ;//奖励
            
            [_listView reloadData];
            
        }else if (num2 == 2) {
            DLOG(@"收藏信息===========%@",[obj objectForKey:@"msg"]);
            [SVProgressHUD showSuccessWithStatus:[obj objectForKey:@"msg"]];
            NSString *str = [NSString stringWithFormat:@"%@",[obj objectForKey:@"attentionBidId"]];
            
            if(str.length)
            {
                _collectNum = 1;
                _collectId = [NSString stringWithFormat:@"%@",[dics objectForKey:@"attentionBidId"]];
                [_collectBtn setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
            }
            
        }else if (num2 == 5){
            
            [SVProgressHUD showSuccessWithStatus:[obj objectForKey:@"msg"]];
            _collectNum = 0;
            [_collectBtn setImage:[UIImage imageNamed:@"no_collection"] forState:UIControlStateNormal];
            
        }else if (num2 == 3) {
            //关注用户
            [SVProgressHUD showSuccessWithStatus:[obj objectForKey:@"msg"]];
            NSString *str = [NSString stringWithFormat:@"%@",[obj objectForKey:@"attentionId"]];
            
            if(str.length)
            {
                _attentionNum = 1;
                _attentionId = [NSString stringWithFormat:@"%@",[obj objectForKey:@"attentionId"]];
                [_attBtn setTitle:@"取消关注" forState:UIControlStateNormal];
            }
            
        }else if (num2 == 4){
            //取消用户
            [SVProgressHUD showSuccessWithStatus:[obj objectForKey:@"msg"]];
            _attentionNum = 0;
            [_attBtn setTitle:@"+关注" forState:UIControlStateNormal];
        }
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
        
    }else {
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
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"无可用网络"]];
}

#pragma mark - UItableViewdelegate
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
    }else {
        return 35.0f;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 5.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        static  NSString *cellID = @"cellid";
        BorrowDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[BorrowDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([_borrowerheadImg hasPrefix:@"http"]) {
            
            [cell.headimgBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_borrowerheadImg]] forState:UIControlStateNormal  placeholderImage:[UIImage imageNamed:@"default_head"]];
        }else{
            [cell.headimgBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Baseurl,_borrowerheadImg]] forState:UIControlStateNormal  placeholderImage:[UIImage imageNamed:@"default_head"]];
        }
        
        if ([_VipStr isEqualToString:@"1"]) {
            cell.vipView.image = [UIImage imageNamed:@"member_vip"];
        }else{
            
            cell.vipView.image = [UIImage imageNamed:@"member_no_vip"];
            
        }
        
        cell.NameLabel.text = [NSString stringWithFormat:@"%@***", [_borrowername substringWithRange:NSMakeRange(0, 1)]];
        cell.borrowRecordLabel.attributedText = _borrowRecordStr;
        cell.repayRecordLabel.attributedText = _repayRecordStr;
        if ([_creditRating hasPrefix:@"http"]) {
            
            [cell.LevelimgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_creditRating]]];
            
        }else{
            
            [cell.LevelimgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Baseurl,_creditRating]]];
        }
        
        if(_attentionNum){
            
            [cell.attentionBtn setTitle:@"取消关注" forState:UIControlStateNormal];
            
        }
        
        // 点击借款人头像，查看借款人详细信息
        [cell.headimgBtn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
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
        
        
        UIButton *expanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        expanBtn.frame = CGRectMake(self.view.frame.size.width-30, 8, 25, 20);
        [expanBtn setImage:[UIImage imageNamed:@"expan_down_btn"] forState:UIControlStateNormal];
        [expanBtn setImage:[UIImage imageNamed:@"expand_up_btn"] forState:UIControlStateSelected];
        [expanBtn setTag:indexPath.section];
        expanBtn.userInteractionEnabled = NO;
        if (indexPath.section == 4||indexPath.section == 7) {
            
            [expanBtn setImage:[UIImage imageNamed:@"cell_more_btn"] forState:UIControlStateNormal];
            
        }
        [cell addSubview:expanBtn];
        
        return cell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell1 = [_listView cellForRowAtIndexPath:indexPath];
    UIButton *btn = (UIButton *)[cell1 viewWithTag:indexPath.section];
    
    if (btn.selected == 0) {
        btn.selected = 1;
    }
    
    UIFolderTableView *folderTableView = (UIFolderTableView *)tableView;
    switch (indexPath.section) {
        case 0:
        {
            BorrowerInformationViewController *BorrowerInformationView = [[BorrowerInformationViewController alloc] init];
            BorrowerInformationView.borrowerID = _borrowerId;
            BorrowerInformationView.borrowId = _borrowId;
            BorrowerInformationView.paceNum = _paceNum;
            [self.navigationController pushViewController:BorrowerInformationView animated:YES];
        }
            break;
            
        case 1:
        {
            
            DetailsDescriptionViewController *DetailsDescriptionView = [[DetailsDescriptionViewController alloc] init];
            
            NSString *result = nil;
            
            if(_borrowDetails!= nil && ![_borrowDetails isEqual:[NSNull null]])
            {
                result = [self filterHTML:_borrowDetails];
                
            }else{
                
                _borrowDetails = @"无更多描述";
                result = _borrowDetails;
                
            }
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            UIFont *font =[UIFont boldSystemFontOfSize:13.0f];
            NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
            
            CGSize labelSize = [result boundingRectWithSize:CGSizeMake(MSWIDTH-30, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            
            _listView.frame = CGRectMake(0, self.listView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height+labelSize.height+10);
            
            DetailsDescriptionView.textString = result;
            DetailsDescriptionView.labelSize =labelSize;
            
            _listView.scrollEnabled = NO;
            [folderTableView openFolderAtIndexPath:indexPath WithContentView:DetailsDescriptionView.view
                                         openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                             // opening actions
                                             //[self CloseAndOpenACtion:indexPath];
                                             
                                             btn.selected = !btn.selected;
                                             
                                             _ScrollView.contentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height+labelSize.height+tableArr.count*70);
                                             
                                         }
                                        closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                            // closing actions
                                            //[self CloseAndOpenACtion:indexPath];
                                            //[cell changeArrowWithUp:NO];
                                            
                                        }
                                   completionBlock:^{
                                       // completed actions
                                       _listView.scrollEnabled = YES;
                                       _ScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1080);
                                   }];
            
        }
            break;
            /*
        case 2:
        {
            MaterialAuditSubjectViewController *MaterialAuditSubjectView = [[MaterialAuditSubjectViewController alloc] init];
            _listView.scrollEnabled = NO;
            MaterialAuditSubjectView.view.frame = CGRectMake(0, 0, 1000, [_AuditdataArr count]*30+30);
            
            if (_AuditdataArr.count) {
                for (int i = 0; i<[_AuditdataArr count]; i++) {
                    
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5+35*i, 100, 30)];
                    titleLabel.font = [UIFont systemFontOfSize:13.0f];
                    titleLabel.textAlignment = NSTextAlignmentCenter;
                    titleLabel.text = [_AuditdataArr objectAtIndex:i];
                    [MaterialAuditSubjectView.view addSubview:titleLabel];
                    
                    UIButton *lookBtn = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
                    [lookBtn setTag:i+100];
                    [lookBtn setFrame:CGRectMake(MSWIDTH-70, 5 + 35 * i, 80, 30)];
                    
                    NSLog(@"isVisible: %@", [_isVisibleArray objectAtIndex:i]);
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
                    
                    switch ([[_auditStatusArr objectAtIndex:i] integerValue]) {
                        case 0:
                        {
                            [stateView setImage:[UIImage imageNamed:@"loan_nopass"]];
                            stateLabel.text = @"未提交";
                            stateLabel.textColor = [UIColor grayColor];
                        }
                            break;
                        case 1:
                        {
                            [stateView setImage:[UIImage imageNamed:@"loan_wait"]];
                            stateLabel.text = @"审核中";
                            stateLabel.textColor = [UIColor grayColor];
                        }
                            break;
                        case 2:
                        {
                            [stateView setImage:[UIImage imageNamed:@"loan_pass"]];
                            stateLabel.text = @"通过审核";
                            stateLabel.textColor = BrownColor;
                        }
                            break;
                        case 3:
                        {
                            [stateView setImage:[UIImage imageNamed:@"loan_nopass"]];
                            stateLabel.text = @"过期失效";
                            stateLabel.textColor = [UIColor grayColor];
                        }
                            break;
                        case -1:
                        {
                            [stateView setImage:[UIImage imageNamed:@"loan_nopass"]];
                            stateLabel.text = @"未通过审核";
                            stateLabel.textColor = [UIColor grayColor];
                        }
                            break;
                    }
                    
                    [MaterialAuditSubjectView.view addSubview:stateView];
                    [MaterialAuditSubjectView.view addSubview:stateLabel];
                    
                }
            }
            
            [folderTableView openFolderAtIndexPath:indexPath WithContentView:MaterialAuditSubjectView.view
                                         openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                             // opening actions
                                             //[self CloseAndOpenACtion:indexPath];
                                             btn.selected = !btn.selected;
                                             
                                             _ScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1260);
                                             
                                         }
                                        closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                            _ScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1080);
                                        }
                                   completionBlock:^{
                                       // completed actions
                                       _listView.scrollEnabled = YES;
                                   }];
            
        }
            
            break;*/
            
            /*
        case 3:
        {
            
            
            CBORiskControlSystemViewController *CBORiskControlSystemView = [[CBORiskControlSystemViewController alloc] init];
            
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
                                             _ScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1150);
                                         }
                                        closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                            // closing actions
                                            _ScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1080);
                                            
                                        }
                                   completionBlock:^{
                                       // completed actions
                                       _listView.scrollEnabled = YES;
                                   }];
            
        }
            break;*/
        case 2:
        {
            // 历史记录
            HistoricalRecordViewController *HistoricalRecordView = [[HistoricalRecordViewController alloc] init];
            
            HistoricalRecordView.timeString = _registrationTime;
            HistoricalRecordView.successfulnumString = [NSString stringWithFormat:@"%@  次",_SuccessBorrowNum];
            HistoricalRecordView.normalnumString = [NSString stringWithFormat:@"%@  次",_NormalRepaymentNum];
//            HistoricalRecordView.limitnumString = [NSString stringWithFormat:@"%@  次",_OverdueRepamentNum];
//            HistoricalRecordView.repaymentString = [NSString stringWithFormat:@"%@  元",_reimbursementAmount];
//            HistoricalRecordView.borrowString = [NSString stringWithFormat:@"%@  元",_BorrowingAmount];
//            HistoricalRecordView.tendernumString = [NSString stringWithFormat:@"%@  次",_FinancialBidNum];
//            HistoricalRecordView.receiptString = [NSString stringWithFormat:@"%@  元",_paymentAmount];
            
            
            _listView.scrollEnabled = NO;
            [folderTableView openFolderAtIndexPath:indexPath WithContentView:HistoricalRecordView.view
                                         openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                             // opening actions
                                             //[self CloseAndOpenACtion:indexPath];
                                             btn.selected = !btn.selected;
                                             _ScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1280);
                                         }
                                        closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                            // closing actions
                                            _ScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1080);
                                        }
                                   completionBlock:^{
                                       // completed actions
                                       _listView.scrollEnabled = YES;
                                   }];
            
        }
            break;
            
            
        case 3:
        {
            
            // 投标奖励
            TenderAwardViewController *TenderAwardView = [[TenderAwardViewController alloc] init];
            
            UILabel *textlabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 120, 30)];
            textlabel1.font = [UIFont boldSystemFontOfSize:13.0f];
            textlabel1.textColor = [UIColor grayColor];
            
            UILabel *textlabel3 = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, 260, 30)];
            textlabel3.font = [UIFont systemFontOfSize:13.0f];
            textlabel3.textColor = [UIColor redColor];
            
            UILabel *textlabel2 = [[UILabel alloc] initWithFrame:CGRectMake(155, 20, 260, 30)];
            textlabel2.font = [UIFont boldSystemFontOfSize:13.0f];
            textlabel2.textColor = [UIColor grayColor];
            
            if(deadType == 0)
            {
                
                textlabel2.text = @"不设置奖励";
                textlabel2.frame = CGRectMake(20, 20, 260, 30);
                
            }else {
                
                if (deadType == 1) {
                    textlabel1.text = @"固定奖金";
                    textlabel2.text = @"元。";
                    textlabel3.text = [NSString stringWithFormat:@"%.0f", bonus];
                }else if (deadType == 2) {
                    textlabel1.text = @"百分比奖金";
                    textlabel2.text = @"%。";
                    textlabel3.text = [NSString stringWithFormat:@"%.0f", awardScale];
                }
                
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                UIFont *font = [UIFont boldSystemFontOfSize:13.0f];
                NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
                
                CGSize _label3Sz = [textlabel3.text boundingRectWithSize:CGSizeMake(999, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                CGSize _label2Sz = [textlabel2.text boundingRectWithSize:CGSizeMake(999, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                
                if (deadType == 1) {
                    textlabel3.frame = CGRectMake(85, 20,  _label3Sz.width + 5, 30);
                }else if(deadType == 2) {
                    textlabel3.frame = CGRectMake(100, 20,  _label3Sz.width + 5, 30);
                }
                
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
                                             _ScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1140);
                                         }
                                        closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                            _ScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1080);
                                        }
                                   completionBlock:^{
                                       // completed actions
                                       _listView.scrollEnabled = YES;
                                   }];
            
        }
            break;
            
        case 4:
        {
            // 投标记录
            btn.selected = 0;
            TenderRecordsViewController *TenderRecordsView = [[TenderRecordsViewController alloc] init];
            TenderRecordsView.borrowID = _borrowId;
            TenderRecordsView.paceNum = _paceNum;
            [self.navigationController pushViewController:TenderRecordsView animated:YES];
            
        }
            break;
            
            
        case 5:
        {
            // 向借款人提问
            btn.selected = 0;
            AskBorrowerViewController *AskBorrowerView = [[AskBorrowerViewController alloc] init];
            AskBorrowerView.borrowId = _borrowId;
            AskBorrowerView.bidUserIdSign = _borrowerId;
            AskBorrowerView.paceNum = _paceNum;
            [self.navigationController pushViewController:AskBorrowerView animated:YES];
            
        }
            break;
    }
    
}


#pragma mark - 证件审核查看按钮
- (void)LookBtnClick:(UIButton *)btn
{
    
    DLOG(@"点击了查看按钮%ld", (long)btn.tag);
    
    if ([_imgpathArr objectAtIndex:btn.tag-100]) {
        scrollPanel = [[UIView alloc] initWithFrame:self.view.bounds];
        scrollPanel.backgroundColor = [UIColor lightGrayColor];
        scrollPanel.alpha = 0;
        
        //点击手势
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
        
    }else{
        
        DLOG(@"关注按钮");
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        if(_attentionNum == 0){
            num2 = 3;
            //关注接口
            [parameters setObject:@"71" forKey:@"OPT"];
            [parameters setObject:@"" forKey:@"body"];
            [parameters setObject:[NSString stringWithFormat:@"%@",_borrowerId] forKey:@"bidUserIdSign"];
            [parameters setObject:[NSString stringWithFormat:@"%@",AppDelegateInstance.userInfo.userId] forKey:@"id"];
        }else{
            
            num2 = 4;
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
        ReportViewController *reportView = [[ReportViewController alloc] init];
        reportView.bidIdSign = _bidIdSign;
        reportView.borrowName = _borrowername;
        reportView.bidUserIdSign = _borrowerId;
        reportView.reportName = AppDelegateInstance.userInfo.userName;
        [self.navigationController pushViewController:reportView animated:YES];
        
    }
    
}

#pragma mark 计算器按钮
- (void)CalculateBtnClick
{
    //    DLOG(@"repayType -> %d", repayType);
    //
    //    DLOG(@"利率计算器按钮");
    //    InterestcalculatorViewController *interestcalculatorView = [[InterestcalculatorViewController alloc] init];
    //    interestcalculatorView.status = 1;
    //    interestcalculatorView.bidAmout = bidAmout;
    //    interestcalculatorView.apr = apr;
    //    interestcalculatorView.deadLine = deadLine;
    //    interestcalculatorView.repayType = repayType;
    //    interestcalculatorView.bonus = bonus;
    //    interestcalculatorView.deadType = deadType;
    //    interestcalculatorView.awardScale = awardScale;
    //    interestcalculatorView.deadperiodUnit = deadperiodUnit;
    //    [self.navigationController pushViewController:interestcalculatorView animated:YES];
}

#pragma mark 收藏按钮
- (void)collectBtnClick:(UIButton *)btn
{
    DLOG(@"收藏按钮");
    if (AppDelegateInstance.userInfo == nil) {
        [ReLogin outTheTimeRelogin:self];
    }else {
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        if(_collectNum ==0)
        {
            num2 = 2;
            //收藏借款标接口
            [parameters setObject:@"72" forKey:@"OPT"];
            [parameters setObject:@"" forKey:@"body"];
            [parameters setObject:[NSString stringWithFormat:@"%@",_bidIdSign] forKey:@"bidIdSign"];
            [parameters setObject:[NSString stringWithFormat:@"%@",AppDelegateInstance.userInfo.userId] forKey:@"id"];
            
        }else{
            num2 = 5;
            //取消收藏接口
            [parameters setObject:@"153" forKey:@"OPT"];
            [parameters setObject:@"" forKey:@"body"];
            [parameters setObject:[NSString stringWithFormat:@"%@",_borrowId] forKey:@"bidId"];
            [parameters setObject:[NSString stringWithFormat:@"%@",AppDelegateInstance.userInfo.userId] forKey:@"userId"];
        }
        
        if (_requestClient == nil) {
            _requestClient = [[NetWorkClient alloc] init];
            _requestClient.delegate = self;
            
        }
        [_requestClient requestGet:@"app/services" withParameters:parameters];
    }
    
}

#pragma  分享按钮
- (void)shareClick
{
    
    if (AppDelegateInstance.userInfo == nil) {
        
        [ReLogin outTheTimeRelogin:self];
    }else {
        DLOG(@"分享按钮 -> %@", _borrowID);
        NSString *urlStr;
        if ([borrowImgUrl hasPrefix:@"http"]) {
            
            urlStr = [NSString stringWithFormat:@"%@",borrowImgUrl];
            
        }else{
            urlStr = [NSString stringWithFormat:@"%@%@",Baseurl,borrowImgUrl];
            
        }
        
        //        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"];
        
        NSString *shareUrl = [NSString stringWithFormat:@"%@/app/shareBid?bidId=%@&recommend=%@", Baseurl, _borrowID,AppDelegateInstance.userInfo.userName];
        DLOG(@"dfdfdfdfdf%@",shareUrl);
        
        //构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:_titleLabel.text
                                           defaultContent:@"默认分享内容，没内容时显示"
                                                    image:[ShareSDK imageWithUrl:urlStr]
                                                    title:@"优质标推荐再不投就晚了"
                                                      url:shareUrl
                                              description:@"这是一条测试信息"
                                                mediaType:SSPublishContentMediaTypeNews];
        
        
        //定制微信好友信息
        [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                             content:_titleLabel.text
                                               title:@"优质标推荐再不投就晚了"
                                                 url:shareUrl
                                          thumbImage:[ShareSDK imageWithUrl:urlStr]
                                               image:INHERIT_VALUE
                                        musicFileUrl:nil
                                             extInfo:nil
                                            fileData:nil
                                        emoticonData:nil];
        
        
        //定制微信朋友圈信息
        [publishContent addWeixinTimelineUnitWithType:INHERIT_VALUE
                                              content:_titleLabel.text
                                                title:@"优质标推荐再不投就晚了"
                                                  url:shareUrl
                                           thumbImage:[ShareSDK imageWithUrl:urlStr]
                                                image:INHERIT_VALUE
                                         musicFileUrl:nil
                                              extInfo:nil
                                             fileData:nil
                                         emoticonData:nil];
        
        
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
                                        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [error errorDescription]]];
                                    }
                                }];
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


#pragma 立即投标ann
- (void)tenderBtnClick
{
    
    if (AppDelegateInstance.userInfo == nil) {
        
        [ReLogin outTheTimeRelogin:self];
    }else {
        
        TenderOnceViewController *tenderOnceView = [[TenderOnceViewController alloc] init];
        tenderOnceView.level = 1;
        tenderOnceView.borrowId = _borrowId;
        tenderOnceView.noId = noId;
        [self.navigationController pushViewController:tenderOnceView animated:YES];
        
    }
    
}


#pragma 提交资料
- (void)postInfoClick
{
    
    LiteratureAuditViewController *literatureAuditView = [[LiteratureAuditViewController alloc] init];
    [self.navigationController pushViewController:literatureAuditView animated:YES];
    
}

#pragma 查看理财账单
- (void)finaBillClick
{
    
    FinancialBillsViewController *financialBillsView = [[FinancialBillsViewController alloc] init];
    [self.navigationController pushViewController:financialBillsView animated:YES];
    
}

#pragma 查看账单
- (void)seeBillClick
{
    
    BorrowingBillViewController *borrowbillView = [[BorrowingBillViewController alloc] init];
    [self.navigationController pushViewController:borrowbillView animated:YES];
    
}

#pragma 查看借款人详细信息
- (void)headBtnClick:(UIButton *)btn {
    
    BorrowerInformationViewController *BorrowerInformationView = [[BorrowerInformationViewController alloc] init];
    BorrowerInformationView.borrowerID = _borrowerId;
    BorrowerInformationView.borrowId = _borrowId;
    BorrowerInformationView.paceNum = _paceNum;
    [self.navigationController pushViewController:BorrowerInformationView animated:YES];
    
}

//剩余时间倒计时
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
        _dateLabel2.text =@"已过期";
    }
    else
    {
        _dateLabel2.text = [[NSString alloc] initWithFormat:@"%i天%i小时%i分%i秒",days,hours,minute,seconds];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod) userInfo:nil repeats:YES];
    }
    
    
}

//剩余时间倒计时(每秒钟调用一次)
- (void)timerFireMethod
{
    
    _time--;
    int days = ((int)_time)/(3600*24);
    int hours = ((int)_time)%(3600*24)/3600;
    int minute = ((int)_time)%(3600*24)%3600/60;
    int seconds = ((int)_time)%(3600*24)%3600%60;
    
    if (days <= 0&&hours <= 0&&minute <= 0&&seconds<=0)
    {
        _dateLabel2.text =@"已过期";
    }
    else
    {
        _dateLabel2.text = [[NSString alloc] initWithFormat:@"%i天%i小时%i分%i秒",days,hours,minute,seconds];
        
    }
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

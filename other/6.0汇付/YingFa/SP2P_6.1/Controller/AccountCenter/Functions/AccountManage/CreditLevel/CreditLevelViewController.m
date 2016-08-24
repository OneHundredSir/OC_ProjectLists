//
//  CreditLevelViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-6-19.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//账户中心--》账户管理--》我的信用等级
#import "CreditLevelViewController.h"
#import "ApplyOverBorrowViewController.h"
#import "IntegralDetailViewController.h"
#import "ColorTools.h"

#import "UIImageView+WebCache.h"

#import "CreditLevel.h"

@interface CreditLevelViewController ()<HTTPClientDelegate>

@property (nonatomic ,strong) UILabel *userName;// 用户名称

@property (nonatomic ,strong) UILabel *creditIntegrallabel;// 信用积分

@property (nonatomic ,strong) UILabel *creditLimitlabel;// 信用额度

@property (nonatomic ,strong) UIImageView *creditLevel;// 信用等级

@property (nonatomic ,strong) UILabel *overCreditLinelabel;// 超额借款信用额度

@property(nonatomic ,strong) NetWorkClient *requestClient;

@property (nonatomic, strong) CreditLevel *creditLevelModel;

@end

@implementation CreditLevelViewController

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
    [self initData];
    
    // 初始化视图
    [self initView];
    
    [self requestData];
}

/**
 * 初始化数据
 */
- (void)initData
{

    
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
 
    self.view.backgroundColor = [UIColor whiteColor];
    _userName = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, MSWIDTH-20, 30)];
    _userName.font = [UIFont boldSystemFontOfSize:16.0f];
    _userName.text = [NSString stringWithFormat:@"尊敬的会员：%@", AppDelegateInstance.userInfo.userName];
    [self.view addSubview:_userName];
    
    UILabel *textlabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 300, 30)];
    textlabel2.text = @"您的信用等级为:";
    textlabel2.font = [UIFont boldSystemFontOfSize:16.0f];
    [self.view addSubview:textlabel2];
    
    _creditLevel = [[UIImageView alloc] initWithFrame:CGRectMake(135, 102, 25, 25)];
   // _creditLevel.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_creditLevel];
    
    UILabel *textlabel3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 130, 300, 30)];
    textlabel3.text = @"信用积分:";
    textlabel3.font = [UIFont boldSystemFontOfSize:16.0f];
    [self.view addSubview:textlabel3];

    _creditIntegrallabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 130, 150, 30)];
    _creditIntegrallabel.textColor = PinkColor;
    _creditIntegrallabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [self.view addSubview:_creditIntegrallabel];
    
    UILabel *textlabel4 = [[UILabel alloc] initWithFrame:CGRectMake(10, 160, 300, 30)];
    textlabel4.text = @"当前信用额度:";
    textlabel4.font = [UIFont boldSystemFontOfSize:16.0f];
    [self.view addSubview:textlabel4];
    
    _creditLimitlabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 160, 300, 30)];
    _creditLimitlabel.font = [UIFont boldSystemFontOfSize:16.0f];
    _creditLimitlabel.textColor = PinkColor;
    [self.view addSubview:_creditLimitlabel];
    
    _overCreditLinelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 220, MSWIDTH-20, 20)];
    _overCreditLinelabel.font = [UIFont boldSystemFontOfSize:12.0f];
    _overCreditLinelabel.textColor = [UIColor darkGrayColor];
    _overCreditLinelabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:_overCreditLinelabel];
    
    
    
    //申请按钮
    UIButton *ApplyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ApplyBtn.frame = CGRectMake(10, 260, self.view.frame.size.width-20, 45);
    [ApplyBtn setTitle:@"申请超额借款" forState:UIControlStateNormal];
    ApplyBtn.layer.cornerRadius = 3.0f;
    ApplyBtn.layer.masksToBounds = YES;
    ApplyBtn.backgroundColor = GreenColor;
    [ApplyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ApplyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [ApplyBtn addTarget:self action:@selector(ApplyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ApplyBtn];

}

-(void) setView
{
    [_creditLevel sd_setImageWithURL:[NSURL URLWithString:_creditLevelModel.creditRating] placeholderImage:[UIImage imageNamed:@""]];
    
    _creditIntegrallabel.text = [NSString stringWithFormat:@"%.2f", _creditLevelModel.creditScore];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    UIFont *font = [UIFont boldSystemFontOfSize:16.0f];
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize CreditIntegrallabelSiZe = [_creditIntegrallabel.text boundingRectWithSize:CGSizeMake(999, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    UILabel *textlabel31 = [[UILabel alloc] initWithFrame:CGRectMake(_creditIntegrallabel.frame.origin.x+CreditIntegrallabelSiZe.width+5, 130, 300, 30)];
    textlabel31.text = @"分";
    textlabel31.font = [UIFont boldSystemFontOfSize:16.0f];
    [self.view addSubview:textlabel31];
    
    DLOG(@"overCreditLine -> %f", _creditLevelModel.overCreditLine);
    DLOG(@"creditLimit -> %f", _creditLevelModel.creditLimit);
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"信用等级";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];

    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    // 导航条返回按钮
    UIBarButtonItem *RightItem=[[UIBarButtonItem alloc] initWithTitle:@"积分明细" style:UIBarButtonItemStyleDone target:self action:@selector(RightItemClick)];
    RightItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:RightItem];
    
}

#pragma mark 申请超额借款按钮
- (void)ApplyBtnClick
{
    DLOG(@"申请超额借款按钮");
    if(AppDelegateInstance.userInfo.userId == nil)
    {
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
    
    }else{
        ApplyOverBorrowViewController *ApplyOverBorrowView = [[ApplyOverBorrowViewController alloc] init];
        [self.navigationController pushViewController:ApplyOverBorrowView animated:YES];
        
    }
}

#pragma 返回按钮触发方法
- (void)backClick
{
    // DLOG(@"返回按钮");
   // [self.navigationController popToRootViewControllerAnimated:NO];
    [self dismissViewControllerAnimated:YES completion:^(){}];
    
}

#pragma 积分明细
- (void)RightItemClick
{
    IntegralDetailViewController *IntegralDetailView = [[IntegralDetailViewController alloc] init];
    [self.navigationController pushViewController:IntegralDetailView animated:YES];
}



#pragma 请求数据
-(void) requestData
{
    if (AppDelegateInstance.userInfo == nil) {
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"112" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"id"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    
    [_requestClient requestGet:@"app/services" withParameters:parameters];
    
}

#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{

    NSDictionary *dics = obj;
    DLOG(@"===%@=======", dics);
    DLOG(@"msg  -> %@", [obj objectForKey:@"msg"]);
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        _creditLevelModel = [[CreditLevel alloc] init];
        _creditLevelModel.creditScore = [[dics objectForKey:@"creditScore"] floatValue];
       
        if ([dics objectForKey:@"creditRating"]!= nil && ![[dics objectForKey:@"creditRating"]isEqual:[NSNull null]])
        {
            if ([[dics objectForKey:@"creditRating"] hasPrefix:@"http"]) {
                
                _creditLevelModel.creditRating = [NSString stringWithFormat:@"%@",  [dics objectForKey:@"creditRating"]];
                
            }else{
                
                _creditLevelModel.creditRating = [NSString stringWithFormat:@"%@%@", Baseurl, [dics objectForKey:@"creditRating"]];
                
            }
        }
        _creditLevelModel.lastCreditLine = [[dics objectForKey:@"lastCreditLine"] floatValue];
        _creditLevelModel.creditLimit = [[dics objectForKey:@"creditLimit"] floatValue];
        _creditLevelModel.overCreditLine = [[dics objectForKey:@"overCreditLine"] floatValue];
        
        _creditLimitlabel.text = [NSString stringWithFormat:@"%d", [[dics objectForKey:@"creditLimit"] intValue]];
        
        _overCreditLinelabel.text = [NSString stringWithFormat:@"【标准信用额度:%d元,超额申请信用额度:%d元】", [[dics objectForKey:@"lastCreditLine"] intValue], [[dics objectForKey:@"overCreditLine"] intValue]];
       
        [self setView];

    } else {
        // 服务器返回数据异常
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

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}

@end

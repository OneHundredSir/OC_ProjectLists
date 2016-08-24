//
//  ProductDescriptionViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-7-3.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//产品描述
#import "ProductDescriptionViewController.h"
#import "ColorTools.h"
#import "ReleaseBorrowInfoViewController.h"
#import "ActivationViewController.h"
#import "AccountInfoViewController.h"

@interface ProductDescriptionViewController ()<HTTPClientDelegate>
{
    
    NSArray *titleArr;
    NSInteger _isBaseInfo;
    NSInteger _isEmail;
    
    UIView *backView2;
    UIView *backView1;
    UIView *backView4;
    
    NSString *RangeStr;
    
}

@property (nonatomic , strong) UITextView *featuretextView;
@property (nonatomic , strong) UITextView *crowdtextView;
@property (nonatomic , strong) UIView *backView3;
@property (nonatomic , strong) NSMutableArray *infoArr;
@property (nonatomic , strong) UITextView *chargetextView;
@property (nonatomic,strong)UIScrollView  *scrollView;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation ProductDescriptionViewController

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
    
}

/**
 * 初始化数据
 */
- (void)initData
{
    _isBaseInfo = 2;
    _isEmail = 2;
    titleArr = @[@"额度范围:",@"贷款利率:",@"贷款期限:",@"投标时间:",@"审核时间:",@"还款方式:"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    //3.1客户端借款标产品列表接口
    [parameters setObject:@"19" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:[NSString stringWithFormat:@"%@",self.productid]   forKey:@"productId"];
    if (AppDelegateInstance.userInfo.userId != nil) {
        [parameters setObject:AppDelegateInstance.userInfo.userId   forKey:@"id"];
    }else
        [parameters setObject:@""   forKey:@"id"];
    
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
    _scrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, -64, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height+64)];
    _scrollView.userInteractionEnabled = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator =NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = KblackgroundColor;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 620);
    [self.view addSubview:_scrollView];
    
    backView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 145)];
    backView1.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:backView1];
    
    UILabel  *textlabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 260,30)];
    textlabel1.numberOfLines = 0;
    textlabel1.backgroundColor = [UIColor whiteColor];
    textlabel1.lineBreakMode = NSLineBreakByCharWrapping;
    textlabel1.font = [UIFont systemFontOfSize:13.0f];
    textlabel1.text = @"产品特点:";
    [backView1 addSubview:textlabel1];
    
    _featuretextView = [[UITextView alloc] initWithFrame:CGRectMake(70, 10, self.view.frame.size.width-80, 70)];
    _featuretextView.font = [UIFont systemFontOfSize:13.0f];
    //    _featuretextView.text = @"放款时间快，借款额度高，还款方式灵活。认证两项审核资料即可借款，95%的成年人均可成功借款。";
    _featuretextView.backgroundColor = [UIColor clearColor];
    _featuretextView.textColor = [UIColor lightGrayColor];
    _featuretextView.userInteractionEnabled = NO;
    [backView1 addSubview:_featuretextView];
    
    
    
    backView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 230, self.view.frame.size.width, 60)];
    backView2.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:backView2];
    
    UILabel  *textlabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 260,30)];
    textlabel2.numberOfLines = 0;
    textlabel2.lineBreakMode = NSLineBreakByCharWrapping;
    textlabel2.font = [UIFont systemFontOfSize:13.0f];
    textlabel2.text = @"适合人群:";
    [backView2 addSubview:textlabel2];
    
    _crowdtextView = [[UITextView alloc] initWithFrame:CGRectMake(70, 5, 220, 50)];
    _crowdtextView.font = [UIFont systemFontOfSize:13.0f];
    //    _crowdtextView.text = @"学生，工薪族，个体工商及私企业主，创业梦想家。";
    _crowdtextView.backgroundColor = [UIColor clearColor];
    _crowdtextView.textColor = [UIColor lightGrayColor];
    _crowdtextView.userInteractionEnabled = NO;
    [backView2 addSubview:_crowdtextView];
    
    
    _backView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 170)];
    _backView3.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_backView3];
    
    
    for (int i = 0; i<[titleArr count]; i++) {
        UILabel  *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 7+i*25, 120,30)];
        titlelabel.numberOfLines = 0;
        titlelabel.lineBreakMode = NSLineBreakByCharWrapping;
        titlelabel.font = [UIFont systemFontOfSize:13.0f];
        titlelabel.text = [titleArr objectAtIndex:i];
        [_backView3 addSubview:titlelabel];
        
    }
    
    
    backView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 450, self.view.frame.size.width, 98)];
    backView4.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:backView4];
    
    UILabel  *chargelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 260,30)];
    chargelabel.numberOfLines = 0;
    chargelabel.lineBreakMode = NSLineBreakByCharWrapping;
    chargelabel.font = [UIFont systemFontOfSize:13.0f];
    chargelabel.text = @"手 续 费:";
    [backView4 addSubview:chargelabel];
    
    _chargetextView = [[UITextView alloc] initWithFrame:CGRectMake(70, 5, self.view.frame.size.width-75, 90)];
    _chargetextView.font = [UIFont systemFontOfSize:12.5f];
    //    _chargetextView.text = @"借款期限6个月（含）以下，借款成功后，本金的2%；借款期限6个月以上，借款成功后，本金的4%（不成功不收取成交服务费）";
    _chargetextView.backgroundColor = [UIColor clearColor];
    _chargetextView.textColor = [UIColor lightGrayColor];
    _chargetextView.userInteractionEnabled = NO;
    [backView4 addSubview:_chargetextView];
    
    
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"产品描述";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    
    // 导航条返回按钮
    UIBarButtonItem *publishItem=[[UIBarButtonItem alloc] initWithTitle:@"发布借款" style:UIBarButtonItemStyleDone target:self action:@selector(publishClick)];
    publishItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:publishItem];
    
    
}




#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    
    DLOG(@"==产品描述返回成功=======%@",obj);
    NSDictionary *dics = obj;
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        
        
        _isEmail = [[dics objectForKey:@"isEmailVerified"] integerValue];
        _isBaseInfo = [[dics objectForKey:@"isAddBaseInfo"] integerValue];
        
        
        NSString *productFeaturesstr =  [NSString stringWithFormat:@"%@",[dics objectForKey:@"productFeatures"]];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        UIFont *font = [UIFont fontWithName:@"Arial" size:13];
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        CGSize _label1Sz = [productFeaturesstr boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 20, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        
        DLOG(@"_label1Sz.height -> %f", _label1Sz.height);
        
        // 根据文本的内容，自定义 frame 值。 CGRectMake(25, 320, 80, 40)
        _featuretextView.frame = CGRectMake(70, 10, self.view.frame.size.width-80,_label1Sz.height*1.5 + 20);
        
        backView1.frame = CGRectMake(0, 64, self.view.frame.size.width, _label1Sz.height*1.5+30);
        
        backView2.frame = CGRectMake(0,64+_label1Sz.height*1.5+40+5 , self.view.frame.size.width, 60);
        _backView3.frame =CGRectMake(0,64+_label1Sz.height*1.5+45+60+15 , self.view.frame.size.width, 170);
        backView4.frame= CGRectMake(0, 64+_label1Sz.height*1.5+45+60+15 +170+15, self.view.frame.size.width, 98);
        
        _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 620+_label1Sz.height*1.5);
        
        _featuretextView.text = [NSString stringWithFormat:@"%@",[dics objectForKey:@"productFeatures"]];
        _crowdtextView.text = [NSString stringWithFormat:@"%@",[dics objectForKey:@"suitsCrowd"]];
        
        //infoArr = @[@"3000-500000.00元",@"16%~26.24%(即月利率：1.33%~2.18%)",@"3,6,12,24个月",@"3,6,8天",@"满标后1~3个工作日",@"等额本息"];
        
        RangeStr = [NSString stringWithFormat:@"%@",[dics objectForKey:@"limitRange"]];
        NSString *loanRateStr = [NSString stringWithFormat:@"%@",[dics objectForKey:@"loanRate"]];//利率
        NSString *monRateStr = [NSString stringWithFormat:@"%@",[dics objectForKey:@"monRate"]];//月利率
        NSString *RateStr = [NSString stringWithFormat:@"%@%%(即月利率:%@%%)",loanRateStr,monRateStr];//利率
        NSString *periodYearStr = [NSString stringWithFormat:@"%@(年)",[dics objectForKey:@"periodYear"]]; //贷款期限 年
        NSString *periodMonthStr = [NSString stringWithFormat:@"%@(月)",[dics objectForKey:@"periodMonth"]]; //月
        NSString *periodDayStr = [NSString stringWithFormat:@"%@(日)",[dics objectForKey:@"periodDay"]]; //日
        NSString *periodStr = [NSString stringWithFormat:@"%@,%@,%@",periodYearStr,periodMonthStr,periodDayStr];//贷款期限
        NSString *tenderTimeStr = [NSString stringWithFormat:@"%@日",[dics objectForKey:@"tenderTime"]]; //投标时间
        NSString *AuditTimeStr = [NSString stringWithFormat:@"满标后%@个工作日",[dics objectForKey:@"uditTime"]]; //审核时间
        
        
        NSArray *dataArr = [dics objectForKey:@"repayWay"];
        NSString *repayStr = @"";
        for (NSDictionary *dic in dataArr) {
            repayStr = [repayStr stringByAppendingFormat:@"%@,", [dic objectForKey:@"name"]];
            
        }
        
        
        NSString *poundage = [NSString stringWithFormat:@"%@",[dics objectForKey:@"poundage"]];//手续费
        _chargetextView.text = poundage;
        
        _infoArr = [[NSMutableArray alloc]  initWithObjects:RangeStr,RateStr,periodStr,tenderTimeStr,AuditTimeStr,repayStr,nil];
        
        for (int i = 0; i<[titleArr count]; i++) {
            
            UITextView *infotextView = [[UITextView alloc] initWithFrame:CGRectMake(70, 7+25*i, 250, 30)];
            infotextView.font = [UIFont systemFontOfSize:12.5f];
            infotextView.text = [_infoArr objectAtIndex:i];
            if (i==2) {
                infotextView.frame = CGRectMake(70, 25*i, 250, 40);
            }else if(i==3|| i==5)
            {
                infotextView.frame = CGRectMake(70, 5+25*i, 250, 40);
                
            }
            infotextView.textColor = [UIColor lightGrayColor];
            infotextView.backgroundColor = [UIColor clearColor];
            infotextView.userInteractionEnabled = NO;
            [_backView3 addSubview:infotextView];
        }
        
    }
    else{
        
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


#pragma 返回按钮触发方法
- (void)backClick
{
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
    
    // DLOG(@"返回按钮");
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma 发布借款方法
- (void)publishClick
{
    DLOG(@"发布借款按钮");
    if (AppDelegateInstance.userInfo == nil) {
        
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
    }
    else
    {
        
        if (_isBaseInfo == 1 && _isEmail == 1)//已激活且完善资料
        {
            
            ReleaseBorrowInfoViewController *ReleaseBorrowInfoView = [[ReleaseBorrowInfoViewController alloc] init];
            ReleaseBorrowInfoView.productID = self.productid;
            ReleaseBorrowInfoView.edfwStr = RangeStr;
            [self.navigationController pushViewController:ReleaseBorrowInfoView animated:NO];
            
            
        }
        else if (_isBaseInfo == 0 && _isEmail == 1)//已激活未完善资料
        {
            [SVProgressHUD showErrorWithStatus:@"请先完善资料!"];
            AccountInfoViewController *infoView = [[AccountInfoViewController alloc] init];
            UINavigationController *infoVc = [[UINavigationController alloc] initWithRootViewController:infoView];
            [self.navigationController presentViewController:infoVc animated:YES completion:nil];
            
            
        }
        else if (_isEmail == 0)//未激活
        {
            
            [SVProgressHUD showErrorWithStatus:@"请先激活帐号!"];
            DLOG(@"fjdjfkdfjdfjkdhfjkd 未激活");
            ActivationViewController *activatView = [[ActivationViewController alloc] init];
            [self.navigationController pushViewController:activatView animated:YES];
            
            
        }
        
        
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

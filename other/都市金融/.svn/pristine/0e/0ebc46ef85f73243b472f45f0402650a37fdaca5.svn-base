//
//  AuctionViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-7-28.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "AuctionViewController.h"
#import "ColorTools.h"
#import "RechargeViewController.h"
#import "AccuontSafeViewController.h"
#import "SetNewDealPassWordViewController.h"

#define NUMBERS @"0123456789.\n"
@interface AuctionViewController ()<UITextFieldDelegate,HTTPClientDelegate,UIScrollViewDelegate>
{

    NSInteger _num;
    float minAmount;
    float maxAmount;

}

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong)UILabel *idLabel;
@property(nonatomic, strong)UILabel *borrowname;
@property(nonatomic, strong)UIImageView *leveimg;
@property(nonatomic, strong)UILabel *rentalLabel;
@property(nonatomic, strong)UILabel *balancelLabel;
@property(nonatomic, strong)UILabel *capitalLabel;
@property(nonatomic, strong)UILabel *basepriceLabel;
@property(nonatomic, strong)UITextField *TendermoneyField;
@property(nonatomic, strong)UITextField *passwordField;
@property(nonatomic, strong)UILabel *passwordLabel;
@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)UIButton *setBtn;
@property(nonatomic, strong)UIView *backView2;
@property(nonatomic ,strong) NetWorkClient *requestClient;
@property(nonatomic, strong)UIButton *tenderBtn;

@property (nonatomic,strong)UISlider *slider;
@property (nonatomic,strong)UILabel *needLabel;
@property (nonatomic,strong)UILabel *minValue;

@end

@implementation AuctionViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 初始化数据
    [self initData];
    
    // 初始化视图
    [self initView1];
    
}

/**
 * 初始化数据
 */
- (void)initData
{
    
    _num = 1;
    
    minAmount = 0;
    maxAmount = 0;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //竞拍相关信息
    [parameters setObject:@"33" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:[NSString stringWithFormat:@"%@",_creditorId] forKey:@"creditorId"];
    [parameters setObject:[NSString stringWithFormat:@"%@",AppDelegateInstance.userInfo.userId] forKey:@"id"];
    
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
     [_requestClient requestGet:@"app/services" withParameters:parameters];
    
}

/**
 初始化数据
 */
- (void)initView1
{
    [self initNavigationBar];
    self.view.backgroundColor = KblackgroundColor;
    
    UIView *backView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MSWIDTH, 164)];
    backView1.backgroundColor = KColor;
//    backView1.alpha = 0.8;
    [self.view addSubview:backView1];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(15,30, 30, 30);
    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [backView1 addSubview:backBtn];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(MSWIDTH/2 -50, 30, 100, 30)];
    //    titleLabel.backgroundColor = GreenColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:18.0];
    titleLabel.text = @"竞 拍";
    [backView1 addSubview:titleLabel];

    
    _balancelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 79, MSWIDTH, 40)];
    _balancelLabel.textAlignment = NSTextAlignmentCenter;
    _balancelLabel.font = [UIFont boldSystemFontOfSize:30.0f];
    _balancelLabel.textColor = [UIColor whiteColor];
    [backView1 addSubview:_balancelLabel];
    
    UILabel *availabelTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_balancelLabel.frame), MSWIDTH, 15)];
    availabelTextLabel.textAlignment = NSTextAlignmentCenter;
    availabelTextLabel.font = [UIFont systemFontOfSize:13.0f];
    availabelTextLabel.text = @"可用余额(元)";
    availabelTextLabel.textColor = [UIColor whiteColor];
    [backView1 addSubview:availabelTextLabel];
    
    _backView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 164, MSWIDTH, 200)];
    _backView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_backView2];
    
    UIControl *viewControl = [[UIControl alloc] initWithFrame:_backView2.bounds];
    [viewControl addTarget:self action:@selector(ControlAction) forControlEvents:UIControlEventTouchUpInside];
    [_backView2 addSubview:viewControl];
    
    UIButton *cutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cutBtn setImage:[UIImage imageNamed:@"icon_cut"] forState:UIControlStateNormal];
    cutBtn.frame = CGRectMake(18, 28, 30, 30);
    //button长按事件
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cutValue)];
    longPress.minimumPressDuration = 0.8;
    [cutBtn addGestureRecognizer:longPress];
    [cutBtn addTarget:self action:@selector(cutValue) forControlEvents:UIControlEventTouchUpInside];
    [_backView2 addSubview:cutBtn];
    
    _minValue = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(cutBtn.frame)-25, CGRectGetMaxY(cutBtn.frame)+5,70, 15)];
    _minValue.textColor = [UIColor lightGrayColor];
    _minValue.textAlignment = NSTextAlignmentCenter;
    _minValue.adjustsFontSizeToFitWidth = YES;
    _minValue.font = [UIFont boldSystemFontOfSize:14.0f];
    [_backView2 addSubview:_minValue];
    
    
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(50, 35, MSWIDTH-100, 15)];
    [_slider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
    [_backView2 addSubview:_slider];
    
    
    UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [plusBtn setImage:[UIImage imageNamed:@"icon_plus"] forState:UIControlStateNormal];
    plusBtn.frame = CGRectMake(MSWIDTH - 48, 28, 30, 30);
    //button长按事件
    UILongPressGestureRecognizer *longPress2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addValue)];
    longPress2.minimumPressDuration = 0.8;
    [plusBtn addGestureRecognizer:longPress2];
    [plusBtn addTarget:self action:@selector(addValue) forControlEvents:UIControlEventTouchUpInside];
    [_backView2 addSubview:plusBtn];
    
    _needLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(plusBtn.frame)-40, CGRectGetMaxY(plusBtn.frame)+5, 70, 15)];
    _needLabel.textColor = [UIColor lightGrayColor];
    _needLabel.textAlignment = NSTextAlignmentCenter;
    _needLabel.font = [UIFont systemFontOfSize:14.0f];
    _needLabel.adjustsFontSizeToFitWidth = YES;
    _needLabel.textAlignment = NSTextAlignmentCenter;
    [_backView2 addSubview:_needLabel];
    

    
    _TendermoneyField = [[UITextField alloc] initWithFrame:CGRectMake(MSWIDTH/2 - 65,CGRectGetMaxY(_needLabel.frame)+20, 130,25)];
    _TendermoneyField.font = [UIFont systemFontOfSize:13.0f];
    _TendermoneyField.delegate = self;
    _TendermoneyField.tag = 101;
    _TendermoneyField.userInteractionEnabled = YES;
    _TendermoneyField.textAlignment = NSTextAlignmentCenter;
    _TendermoneyField.placeholder = @"0";
    _TendermoneyField.borderStyle = UITextBorderStyleRoundedRect;
    _TendermoneyField.keyboardType = UIKeyboardTypeNumberPad;
//    [_TendermoneyField addTarget:self action:@selector(valueChange) forControlEvents:UIControlEventEditingChanged];
    [_backView2 addSubview:_TendermoneyField];
    
    
    UILabel *TendermoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(_TendermoneyField.frame) - 130, CGRectGetMaxY(_needLabel.frame)+20, 80, 30)];
    TendermoneyLabel.text = @"出价金额";
    TendermoneyLabel.textColor = [UIColor blackColor];
    TendermoneyLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    TendermoneyLabel.textAlignment = NSTextAlignmentLeft;
    [_backView2 addSubview:TendermoneyLabel];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_TendermoneyField.frame)+10, CGRectGetMaxY(_needLabel.frame)+20, 30, 30)];
    textLabel.textColor = [UIColor blackColor];
    textLabel.text = @"元";
    textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    textLabel.textAlignment = NSTextAlignmentLeft;
    [_backView2 addSubview:textLabel];
    
//    UIButton *RechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    RechargeBtn.frame = CGRectMake(260, CGRectGetMaxY(_needLabel.frame)+25,50, 20);
//    RechargeBtn.backgroundColor = PinkColor;
//    [RechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
//    [RechargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//    RechargeBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:11.0];
//    [RechargeBtn.layer setMasksToBounds:YES];
//    [RechargeBtn.layer setCornerRadius:3.0];
//    [RechargeBtn addTarget:self action:@selector(RechargeBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [_backView2 addSubview:RechargeBtn];
//    
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(_TendermoneyField.frame)-130, CGRectGetMaxY(_TendermoneyField.frame)+20, 80, 30)];
    passwordLabel.text = @"交易密码";
    passwordLabel.textColor = [UIColor blackColor];
    passwordLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    passwordLabel.textAlignment = NSTextAlignmentLeft;
    passwordLabel.tag = 1008;
    [_backView2 addSubview:passwordLabel];
    
    _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(MSWIDTH/2 - 65, CGRectGetMaxY(_TendermoneyField.frame)+20, 130,25)];
    _passwordField.font = [UIFont systemFontOfSize:13.0f];
    _passwordField.delegate = self;
    _passwordField.placeholder = @"请输入交易密码";
    _passwordField.tag = 102;
    _passwordField.secureTextEntry = YES;
    _passwordField.borderStyle = UITextBorderStyleRoundedRect;
    [_backView2 addSubview:_passwordField];
    
    _setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _setBtn.frame = CGRectMake(CGRectGetMaxX(_passwordField.frame)+5, CGRectGetMaxY(_TendermoneyField.frame)+20,70, 25);
    _setBtn.backgroundColor = PinkColor;
    [_setBtn setTitle:@"设置交易密码" forState:UIControlStateNormal];
    [_setBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    _setBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:11.0];
    [_setBtn.layer setMasksToBounds:YES];
    [_setBtn.layer setCornerRadius:3.0];
    [_setBtn addTarget:self action:@selector(setBtnClick) forControlEvents:UIControlEventTouchUpInside];


    
    
    _tenderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _tenderBtn.frame = CGRectMake(20, 400,MSWIDTH-40, 50);
    _tenderBtn.backgroundColor = GreenColor;
    [_tenderBtn setTitle:@"立即竞拍" forState:UIControlStateNormal];
    [_tenderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    _tenderBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
    [_tenderBtn.layer setMasksToBounds:YES];
    [_tenderBtn.layer setCornerRadius:3.0];
    [_tenderBtn addTarget:self action:@selector(tenderBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:_tenderBtn];

    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([_TendermoneyField.text floatValue] > maxAmount) {
        
        _TendermoneyField.text = [NSString stringWithFormat:@"%d",(int)maxAmount];
       
    }
    else  if ([_TendermoneyField.text floatValue] < minAmount) {
        
        _TendermoneyField.text = [NSString stringWithFormat:@"%d",(int)minAmount];
    }
    float num = [_TendermoneyField.text floatValue];
    [_slider setValue:num animated:YES];
}

-(void)cutValue{
    
    float num = _slider.value;
    num--;
    [_slider setValue:num animated:YES];
    int num2 = _slider.value;
    _TendermoneyField.text = [NSString stringWithFormat:@"%d",num2];
    
}

-(void)addValue{
    
    float num = _slider.value;
    num ++;
    [_slider setValue:num animated:YES];
    int num2 = _slider.value;
    _TendermoneyField.text = [NSString stringWithFormat:@"%d",num2];
    
    
}

-(void)sliderChange:(UISlider*)slider1
{
    
    DLOG(@"当前的值为:%f",slider1.value);
    int num = 100;
    num = slider1.value;
    _TendermoneyField.text = [NSString stringWithFormat:@"%d",num];
    
    
}


//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"竞拍";
//    [self.navigationController.navigationBar setBarTintColor:KColor];
//    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
//                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
//                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
//    
//    
//    
//    // 导航条返回按钮
//    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]  initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
//    backItem.tintColor = [UIColor whiteColor];
//    [self.navigationItem setLeftBarButtonItem:backItem];
    
//    // 导航条分享按钮
//    UIBarButtonItem *ShareItem=[[UIBarButtonItem alloc]  initWithImage:[UIImage imageNamed:@"nav_share"] style:UIBarButtonItemStyleDone target:self action:@selector(ShareClick)];
//    ShareItem.tintColor = [UIColor whiteColor];
//    [self.navigationItem setRightBarButtonItem:ShareItem];
}



#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    
}
- (NSString *)formatString:(id)Value
{// _balancelLabel.text = [self formatString:dics[@"availableBalance"]];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"###,##0.00;"];
    NSString *Text =  [NSString stringWithFormat:@"%.2f",[Value doubleValue]];
    
    return  [formatter stringFromNumber:@([Text doubleValue])];
}
// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
   
    
    DLOG(@"==竞拍返回成功=======%@",obj);
    NSDictionary *dics = obj;
    _tenderBtn.enabled = YES;
    if(_num == 1)
    {
    
        if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
            _titleLabel.text = [dics objectForKey:@"title"];
            _borrowname.text = [dics objectForKey:@"Name"];
            if ([[dics objectForKey:@"creditRating"] hasPrefix:@"http"]) {
                [_leveimg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dics objectForKey:@"creditRating"]]]];
            }
            else
            {
            
                [_leveimg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Baseurl,[dics objectForKey:@"creditRating"]]]];
            }
//            _rentalLabel.text = [NSString stringWithFormat:@"¥%0.1f",[[dics objectForKey:@"accountAmount"] floatValue]];

            _balancelLabel.text = [self formatString:dics[@"availableBalance"]];
            _needLabel.text = [NSString stringWithFormat:@"%0.0f元",[[dics objectForKey:@"principal"] floatValue]];
            _minValue.text = [NSString stringWithFormat:@"%.0f元",[[dics objectForKey:@"auctionBasePrice"] floatValue]];
            NSString *paypwd = [NSString stringWithFormat:@"%@",[dics objectForKey:@"payPassword"]];
            
            _slider.minimumValue = [_minValue.text floatValue];
            _slider.maximumValue = [_needLabel.text floatValue];
            minAmount = [_minValue.text floatValue];
            maxAmount = [_needLabel.text floatValue];
            _TendermoneyField.text = [NSString stringWithFormat:@"%ld",[_minValue.text integerValue]];
            
            if([paypwd isEqualToString:@"0"]){
                
                _passwordField.placeholder = @"请先设置交易密码";
                _passwordField.userInteractionEnabled = NO;
                [_backView2 addSubview:_setBtn];
                
            }
            
            
               NSString *dealpwd = [NSString stringWithFormat:@"%@",[dics objectForKey:@"isDealPassword"]];
            DLOG(@"交易密码%@",dealpwd);
            if([dealpwd isEqualToString:@"0"]){
                
                [_passwordField removeFromSuperview];
                [_setBtn removeFromSuperview];
                UILabel *pwdLabel = (UILabel*)[_backView2 viewWithTag:1008];
                [pwdLabel removeFromSuperview];
            }
            
        
            
        }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
            
           [ReLogin outTheTimeRelogin:self];
        }else {
            
            DLOG(@"返回失败===========%@",[obj objectForKey:@"msg"]);
           [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
            
        }
    }
    
    if (_num == 2)
    {
            
            
         if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
             
                DLOG(@"返回成功===========%@",[obj objectForKey:@"msg"]);
             //增加这句代码：
             [[NSNotificationCenter defaultCenter] postNotificationName:@"AuctionRefresh" object:self];
             
              [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
             
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * 600000000ull)), dispatch_get_main_queue(), ^{
                   [self.navigationController popViewControllerAnimated:YES];
                });
             
        
        }else{
             
             DLOG(@"返回失败===========%@",[obj objectForKey:@"msg"]);
             [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
             }
    }
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    // 服务器返回数据异常
//    [SVProgressHUD showErrorWithStatus:@"网络异常"];
     _tenderBtn.enabled = YES;
}

// 无可用的网络
-(void) networkError
{
     _tenderBtn.enabled = YES;
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
}


#pragma mark 点击空白处收回键盘
- (void)ControlAction
{
    
    for (UITextField *textField in [_backView2 subviews])
    {
        if ([textField isKindOfClass: [UITextField class]]) {
            
            [textField  resignFirstResponder];
        }
    }
}

#pragma 输入框代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma 限制只能输入数字和.
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL canChange;
    if (textField.tag == 101) {
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS]invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
        
        canChange = [string isEqualToString:filtered];
    }
    else
    {
        canChange = YES;
        
    }
    
    return canChange;
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

#pragma mark 竞拍按钮
- (void)tenderBtnClick
{

    DLOG(@"竞拍按钮！！");
    _tenderBtn.enabled = NO;
    _num = 2;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //竞拍相关信息
    [parameters setObject:@"34" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:[NSString stringWithFormat:@"%@",_creditorId] forKey:@"creditorId"];
    [parameters setObject:[NSString stringWithFormat:@"%@",AppDelegateInstance.userInfo.userId] forKey:@"id"];
    [parameters setObject:_TendermoneyField.text forKey:@"amount"];
    if(_passwordField.text){
       
          NSString *dealpwd = [NSString encrypt3DES:_passwordField.text key:DESkey];
        [parameters setObject:dealpwd forKey:@"dealPwd"];
        
    }else
    [parameters setObject:@"" forKey:@"dealPwd"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
       
    }
     [_requestClient requestGet:@"app/services" withParameters:parameters];
  
}


#pragma mark 设置交易密码按钮
- (void)setBtnClick
{
    
    if (!AppDelegateInstance.userInfo.isTeleStatus || !AppDelegateInstance.userInfo.isSecretStatus || !AppDelegateInstance.userInfo.isSecretStatus) {
        
           [SVProgressHUD showErrorWithStatus:@"请先设置相关安全问题!"];
        AccuontSafeViewController *AccuontSafeView = [[AccuontSafeViewController alloc] init];
        UINavigationController *NaVController20 = [[UINavigationController alloc] initWithRootViewController:AccuontSafeView];
        AccuontSafeView.backTypeNum = 2;
        [self presentViewController:NaVController20 animated:YES completion:nil];
        
    
    }else{
        
       SetNewDealPassWordViewController *dealView = [[SetNewDealPassWordViewController alloc] init];
       dealView.ispayPasswordStatus = NO;
       dealView.statuStr = @"竞拍设置";
       UINavigationController *dealNav = [[UINavigationController alloc] initWithRootViewController:dealView];
       [self.navigationController presentViewController:dealNav animated:NO completion:nil];
    
    }
}

#pragma mark 充值按钮
- (void)RechargeBtnClick
{
    
    DLOG(@"充值按钮！！");
    RechargeViewController *RechargeView = [[RechargeViewController alloc] init];
    [self.navigationController pushViewController:RechargeView animated:YES];
//    UINavigationController *RechargeNav = [[UINavigationController alloc] initWithRootViewController:RechargeView];
//    [self.navigationController presentViewController:RechargeNav animated:NO completion:nil];
}




#pragma 分享按钮
- (void)ShareClick
{
    DLOG(@"分享按钮");
    
    if (AppDelegateInstance.userInfo == nil) {
        
          [ReLogin outTheTimeRelogin:self];        
    }else {
        DLOG(@"分享按钮");
        
//        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"];
        
        NSString *shareUrl = [NSString stringWithFormat:@"%@/front/invest/invest?bidId=1111", Baseurl];
        
        //构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:@"sp2p 7.1.2晓风网贷 我要投资 借款详情"
                                           defaultContent:@"默认分享内容，没内容时显示"
                                                    image:[ShareSDK pngImageWithImage:[UIImage imageNamed:@"logo"]]
                                                    title:@"借款详情"
                                                      url:shareUrl
                                              description:@"这是一条测试信息"
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
                                        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [error errorDescription]]];
                                    }
                                }];
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}

@end

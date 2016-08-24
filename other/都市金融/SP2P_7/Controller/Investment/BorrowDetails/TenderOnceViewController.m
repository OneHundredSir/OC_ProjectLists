//
//  TenderOnceViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-7-24.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  投标

#import "TenderOnceViewController.h"
#import "ColorTools.h"
#import "LDProgressView.h"
#import "AccuontSafeViewController.h"
#import "RechargeViewController.h"
#define NUMBERS @"0123456789.\n"
#import "MyRechargeViewController.h"

@interface TenderOnceViewController ()<UITextFieldDelegate,UIAlertViewDelegate,HTTPClientDelegate,UIScrollViewDelegate>
{

    NSArray *titleArr;
    NSInteger _num;
    float minAmount;
    float maxAmount;
    NSNumber *progressnum;
    NSInteger isPayPwdSet;// 是否设置了交易密码
    NSInteger isdealPwdNeed;//投标是否需要交易密码

}
@property (nonatomic,strong)LDProgressView *progressView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *idLabel;
@property (nonatomic,strong)UILabel *borrowerLabel;
@property (nonatomic,strong)UIImageView *leveImg;
@property (nonatomic,strong)UILabel *rentalLabel;
@property (nonatomic,strong)UILabel *balancelLabel;
@property (nonatomic,strong)UITextField *TendermoneyField;
@property (nonatomic,strong)UITextField *passwordField;
@property (nonatomic,strong)UILabel *borrowsum;
@property (nonatomic,strong)UILabel *rateLabel;
@property (nonatomic,strong)UILabel *deadlineLabel;
@property (nonatomic,strong)UILabel *dateLabel;
@property (nonatomic,strong)UILabel *needLabel;
@property (nonatomic,strong)UILabel *thenLabel;
@property (nonatomic,strong)UILabel *minLabel;
@property (nonatomic,strong)UILabel *minValue;
@property (nonatomic,strong)UILabel *sumLabel;
@property (nonatomic,strong)UILabel *browseLabel;
@property (nonatomic,strong)UILabel *wayLabel;
@property (nonatomic,strong)UILabel *passwordLabel;
@property (nonatomic,strong)UILabel *xLabel;
@property (nonatomic,strong)UIView *backView2;
@property (nonatomic,strong)UIScrollView  *scrollView;

@property (nonatomic,strong)UILabel *textLabel;
@property (nonatomic,strong)UILabel *needValueLabel; // 剩余份数
@property (nonatomic,strong) UILabel *interestLabel;  //实际利息
@property (nonatomic,strong)UISlider *slider;
@property (nonatomic,strong)UIButton *tenderBtn;


@property (nonatomic,assign) float period;
@property (nonatomic,assign) NSInteger unitType;
@property (nonatomic,assign) float apr;
@property (nonatomic,assign) NSInteger rType;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation TenderOnceViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    // 初始化数据
    [self initData];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    // 初始化视图
    [self initView];
    
}

/**
 * 初始化数据
 */
- (void)initData
{
    
    titleArr = @[@"借款金额:",@"年利率:",@"还款方式:",@"已投金额:",@"借款期限:",@"还需金额:",@"还款日期:"];
    
    minAmount = 0;
    maxAmount = 0;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
  
    _num = 1;
    //获取投标相关信息接口(opt=15)
    [parameters setObject:@"15" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:[NSString stringWithFormat:@"%@",_borrowId] forKey:@"borrowId"];
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
- (void)initView
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
    titleLabel.text = @"投标";
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
    longPress.minimumPressDuration = 1;
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
    longPress2.minimumPressDuration = 1;
    [plusBtn addGestureRecognizer:longPress2];
    [plusBtn addTarget:self action:@selector(addValue) forControlEvents:UIControlEventTouchUpInside];
    [_backView2 addSubview:plusBtn];
    
    _needLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(plusBtn.frame)-40, CGRectGetMaxY(plusBtn.frame)+5, 70, 15)];
    _needLabel.textColor = [UIColor lightGrayColor];
    _needLabel.textAlignment = NSTextAlignmentCenter;
    _needLabel.font = [UIFont systemFontOfSize:14.0f];
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
    
    UILabel *TendermoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(_TendermoneyField.frame)-130, CGRectGetMaxY(_needLabel.frame)+20, 80, 30)];
    TendermoneyLabel.text = @"投入金额";
    TendermoneyLabel.textColor = [UIColor blackColor];
    TendermoneyLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    TendermoneyLabel.textAlignment = NSTextAlignmentLeft;
    [_backView2 addSubview:TendermoneyLabel];
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_TendermoneyField.frame)+10, CGRectGetMaxY(_needLabel.frame)+20, 30, 30)];
    _textLabel.textColor = [UIColor blackColor];
    _textLabel.text = @"元";
    _textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    _textLabel.textAlignment = NSTextAlignmentLeft;
    [_backView2 addSubview:_textLabel];
    
    _interestLabel = [[UILabel alloc] initWithFrame:CGRectMake(MSWIDTH/2 - 100, CGRectGetMaxY(_TendermoneyField.frame)+10, 200,25)];
    _interestLabel.font = [UIFont systemFontOfSize:13.0f];
    _interestLabel.textColor = PinkColor;
    _interestLabel.textAlignment = NSTextAlignmentCenter;
    _interestLabel.backgroundColor = [UIColor clearColor];
    _interestLabel.text = @"总收益  0  元";
    [_backView2 addSubview:_interestLabel];
    
    
    _tenderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _tenderBtn.frame = CGRectMake(20, 400,MSWIDTH-40, 50);
    _tenderBtn.backgroundColor = GreenColor;
    [_tenderBtn setTitle:@"确认投标" forState:UIControlStateNormal];
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
//        [SVProgressHUD showErrorWithStatus:@"不能超过最大额度"];
    }
    else  if ([_TendermoneyField.text floatValue] < minAmount) {
        
        _TendermoneyField.text = [NSString stringWithFormat:@"%d",(int)minAmount];
    }
    
    float num = [_TendermoneyField.text floatValue];
    [_slider setValue:num animated:YES];
    [self getInterest:_period units:_unitType apr:_apr amount:num rType:_rType];
}

-(void)cutValue{
    
    float num = _slider.value;
    num--;
    [_slider setValue:num animated:YES];
     int num2 = _slider.value;
    _TendermoneyField.text = [NSString stringWithFormat:@"%d",num2];
     [self getInterest:_period units:_unitType apr:_apr amount:num rType:_rType];

}

-(void)addValue{
    
    float num = _slider.value;
    num ++;
    [_slider setValue:num animated:YES];
    int num2 = _slider.value;
    _TendermoneyField.text = [NSString stringWithFormat:@"%d",num2];
    [self getInterest:_period units:_unitType apr:_apr amount:num rType:_rType];
    
    
}

-(void)sliderChange:(UISlider*)slider1
{

    DLOG(@"当前的值为:%f",slider1.value);
    int num = 100;
    num = slider1.value;
    _TendermoneyField.text = [NSString stringWithFormat:@"%d",num];
    [self getInterest:_period units:_unitType apr:_apr amount:num rType:_rType];

}
/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"投标";
//    [self.navigationController.navigationBar setBarTintColor:KColor];
//    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
//                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
//                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
//    
//    // 导航条返回按钮
//    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
//    backItem.tintColor = [UIColor whiteColor];
//    [self.navigationItem setLeftBarButtonItem:backItem];
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
    
        if (_num == 1) {
//            _titleLabel.text = [NSString stringWithFormat:@"%@",[dics objectForKey:@"title"]];
//            _borrowerLabel.text = [NSString stringWithFormat:@"%@",[dics objectForKey:@"Name"]];
            
//            if ([[dics objectForKey:@"creditRating"] hasPrefix:@"http"]) {
//                
//                [_leveImg  sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dics objectForKey:@"creditRating"]]]];
//            }else{
//                
//                [_leveImg  sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Baseurl,[dics objectForKey:@"creditRating"]]]];
//                
//            }
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setPositiveFormat:@"###,##0.00;"];
            
              NSString *_rentalLabelText =  [NSString stringWithFormat:@"%.2f",[[dics objectForKey:@"accountAmount"] doubleValue]];
            _rentalLabel.text = [NSString stringWithFormat:@"¥ %@",[formatter stringFromNumber:@([_rentalLabelText doubleValue])]];
            
             NSString *_balancelLabelText =  [NSString stringWithFormat:@"%.2f",[[dics objectForKey:@"availableBalance"] doubleValue]];
            _balancelLabel.text = [formatter stringFromNumber:@([_balancelLabelText doubleValue])];
            
            _progressView.progress = [[dics objectForKey:@"schedules"] floatValue] /100;
            _borrowsum.text = [NSString stringWithFormat:@"¥ %@",[dics objectForKey:@"borrowAmount"]];
            _rateLabel.text =  [NSString stringWithFormat:@"%@%%",[dics objectForKey:@"annualRate"]];
            _deadlineLabel.text = [NSString stringWithFormat:@"%@",[dics objectForKey:@"deadline"]];
            _wayLabel.text = [NSString stringWithFormat:@"%@",[dics objectForKey:@"paymentMode"]];
            
            if ([[dics objectForKey:@"paymentTime"]  isEqual:[NSNull null]]) {
                _dateLabel.text  = @"";
                UILabel *textLabel = (UILabel *)[_scrollView viewWithTag:1006];
                [textLabel removeFromSuperview];
            }else {
                _dateLabel.text = [[NSString stringWithFormat:@"%@",[dics objectForKey:@"paymentTime"]]substringWithRange:NSMakeRange(0, 10)];
            }
            DLOG(@"_dateLabel.text is %@",_dateLabel.text);
            _needLabel.text =[NSString stringWithFormat:@"%.0f元", [[dics objectForKey:@"needAmount"] floatValue]];
            _thenLabel.text = [NSString stringWithFormat:@"¥ %@",[dics objectForKey:@"InvestmentAmount"]];
            _sumLabel.text = [NSString stringWithFormat:@"总投标数: %@ | 浏览量: %@",[dics objectForKey:@"investNum"],[dics objectForKey:@"views"]];
            isPayPwdSet = [[dics objectForKey:@"payPassword"] integerValue];
            isdealPwdNeed = [[dics objectForKey:@"isDealPassword"] integerValue];
                
            if (isdealPwdNeed == 1) {
                
                
                _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(MSWIDTH/2 - 65, CGRectGetMaxY(_TendermoneyField.frame)+10, 130,25)];
                _passwordField.font = [UIFont systemFontOfSize:13.0f];
                _passwordField.delegate = self;
                _passwordField.placeholder = @"请输入交易密码";
                _passwordField.tag = 102;
                _passwordField.secureTextEntry = YES;
                _passwordField.borderStyle = UITextBorderStyleRoundedRect;
                [_backView2 addSubview:_passwordField];
                
                _passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(_TendermoneyField.frame)-130, CGRectGetMaxY(_TendermoneyField.frame)+5, 80, 30)];
                _passwordLabel.text = @"交易密码";
                _passwordLabel.textColor = [UIColor blackColor];
                _passwordLabel.font = [UIFont boldSystemFontOfSize:14.0f];
                _passwordLabel.textAlignment = NSTextAlignmentLeft;
                [_backView2 addSubview:_passwordLabel];
                
                 _interestLabel.frame = CGRectMake(MSWIDTH/2 - 100, CGRectGetMaxY(_passwordField.frame)+10, 200,25);
            }
            
            
            
            if ([[dics objectForKey:@"minTenderedSum"] intValue] > 0) {
                _textLabel.text = @"元";
//                _minLabel.text = @"最低投标金额：";
                _minValue.text = [NSString stringWithFormat:@"%.0f元",[[dics objectForKey:@"minTenderedSum"] floatValue]];
                _slider.minimumValue = [_minValue.text floatValue];
                _slider.maximumValue = [_needLabel.text floatValue];
                minAmount = [_minValue.text floatValue];
                maxAmount = [_needLabel.text floatValue];
                _TendermoneyField.text = [NSString stringWithFormat:@"%ld",[_minValue.text integerValue]];
                float num = [_TendermoneyField.text floatValue];
                _period = [[dics objectForKey:@"period"] floatValue];
                _unitType = [[dics objectForKey:@"unit"] integerValue];
                _apr = [[dics objectForKey:@"annualRate"] floatValue];
                _rType = [[dics objectForKey:@"repayType"] integerValue];
                [self getInterest:_period units:_unitType apr:_apr amount:num rType:_rType];
                
                
            }else {
                _textLabel.text = @"份";
//                _minLabel.text = @"最小认购金额：";
                _minValue.text = @"1份";
                _needLabel.text = [NSString stringWithFormat:@"%@份",[dics objectForKey:@"needAccount"]];
                _slider.minimumValue = [_minValue.text floatValue];
                _slider.maximumValue = [_needLabel.text floatValue];
                minAmount = [_minValue.text floatValue];
                maxAmount = [_needLabel.text floatValue];
                _TendermoneyField.text = [NSString stringWithFormat:@"%ld",[_minValue.text integerValue]];
                _interestLabel.text = [NSString stringWithFormat:@"每份金额为: %@ 元",[dics objectForKey:@"averageInvestAmount"]];
            }
            
            
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            UIFont *font = [UIFont fontWithName:@"Arial" size:14];
            NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
            CGSize _label1Sz = [_borrowerLabel.text boundingRectWithSize:CGSizeMake(999, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            _borrowerLabel.frame = CGRectMake(60, 40, _label1Sz.width + 10, 20);
            _leveImg.frame = CGRectMake(_borrowerLabel.frame.origin.x + _borrowerLabel.frame.size.width, 40, 20, 20);
            
        }else if (_num == 2) {
            DLOG(@"返回成功===========%@",[obj objectForKey:@"msg"]);

            //列表刷新通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"investRefresh" object:self];
            [SVProgressHUD showSuccessWithStatus1:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * 600000000ull)), dispatch_get_main_queue(), ^{
                
                
                self.navigationController.navigationBarHidden = NO;
                [self.navigationController popToRootViewControllerAnimated:YES];
                
                
            });
        }
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
    }else {
            DLOG(@"返回失败===========%@",[obj objectForKey:@"msg"]);
        NSString *errStr = [obj objectForKey:@"msg"];
        if ([errStr rangeOfString:@"余额不足"].location !=NSNotFound){
            
            RechargeViewController *reachargeView = [[RechargeViewController alloc] init];
            [self.navigationController pushViewController:reachargeView animated:YES];
            
        }else
            [SVProgressHUD showErrorWithStatus1:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
    }
     _tenderBtn.enabled = YES;
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    
    // 服务器返回数据异常
    [SVProgressHUD showErrorWithStatus:@"服务器维护中"];
     _tenderBtn.enabled = YES;
}


// 无可用的网络
-(void) networkError
{
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"无可用网络"]];
      _tenderBtn.enabled = YES;
}

#pragma mark 点击空白处收回键盘
- (void)ControlAction
{
    
    [_TendermoneyField resignFirstResponder];
    
    for (UITextField *textField in [_backView2 subviews])
    {
        if ([textField isKindOfClass: [UITextField class]]) {
            
            [textField  resignFirstResponder];
        }
        
    }

    
    
}

#pragma mark 年利率自动计算方法
- (void)getInterest:(float)period units:(NSInteger)unit  apr:(float)apr  amount:(float)amount rType:(NSInteger)rType
{
    
    float interest = 0; // 总利息
//    long accuracy = 1000000;
//    long monthApr = 0.01* apr / 12 *accuracy;
//    NSString *monthAprStr = [NSString stringWithFormat:@"%.01f", (float)monthApr];
//    float moth = [monthAprStr floatValue];
    CGFloat monthApr = 0.01* apr / 12;
    float rperiod = 0; // 还款期数
    
    /* 根据借款期限算出利息 */
    switch(unit){
            /* 年 */
        case -1:
            interest = apr/100*period*amount;
            rperiod = period * 12;
            break;
            /* 月 */
        case 0:
            interest = apr/12/100*period*amount;
            rperiod = period;
            break;
            /* 日 */
        case 1:
            interest = apr/360/100*period*amount;
            rperiod = 1;
            break;
    }
    
    /* 根据还款方式算出利息 */
    switch(rType){
            /* 按月还款、等额本息 */
        case 1:{
//            if (_aprNum) {
            double monthSum = amount * monthApr *powf((1 + monthApr), rperiod) / (powf((1 + monthApr), rperiod) - 1);
            
                DLOG(@"fdhfjdhfjkdhfjkdhkf %f",monthSum * rperiod - amount);
            
                _interestLabel.text = [NSString stringWithFormat:@"总收益  %.2f 元",monthSum * rperiod - amount];
//            }
            
        }
            break;
            /* 按月付息、一次还款; 一次还款 */
        case 2:
        case 3:
            DLOG(@"fdhfjdhfjkdhfjkdhkf %f",interest);
            _interestLabel.text = [NSString stringWithFormat:@"总收益  %.2f 元",interest];
            break;
    }
    
}


#pragma mark UIalerviewdelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000050) {
        if (buttonIndex==1) {
            
            MyRechargeViewController  *controller = [[MyRechargeViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }

    }else{
        DLOG(@"bttonindex is %ld",(long)buttonIndex);
        
        if (buttonIndex==0) {
            self.navigationController.navigationBarHidden = NO;
            [self.navigationController popToRootViewControllerAnimated:YES];
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
        
    }else {
        
        canChange = YES;
    
    }
    
    return canChange;
}

#pragma mark -
#pragma 投标按钮
- (void)tenderBtnClick
{
//    NSLog(@"isdealPwdNeed -> %ld", (long)isdealPwdNeed);
//    NSLog(@"isPayPwdSet -> %ld", (long)isPayPwdSet);
    _tenderBtn.enabled = NO;
    
    // isdealPwdNeed 判断投标是否需要交易密码（0：不需要   1：需要）
    // isPayPwdSet 判断是否设置了交易密码（0：没设置   1：已设置）
    if(isdealPwdNeed == 1 && isPayPwdSet == 0 ){
        _tenderBtn.enabled = YES;
        [SVProgressHUD showErrorWithStatus:@"请先设置交易密码保障安全"];
        AccuontSafeViewController *AccuontSafeView = [[AccuontSafeViewController alloc] init];
        UINavigationController *NaVController20 = [[UINavigationController alloc] initWithRootViewController:AccuontSafeView];
          AccuontSafeView.backTypeNum =2;
         self.navigationController.navigationBarHidden = NO;
        [self presentViewController:NaVController20 animated:YES completion:nil];
        return;
    }
    
    //        [SVProgressHUD show];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //我要投标接口(opt=16)
    [parameters setObject:@"16" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:_TendermoneyField.text forKey:@"amount"];
    [parameters setObject:[NSString stringWithFormat:@"%@",_borrowId] forKey:@"borrowId"];
    if(isdealPwdNeed == 0)
    {
        [parameters setObject:@"" forKey:@"dealPwd"];
        
    }else {
        NSString *dealpwd = [NSString encrypt3DES:_passwordField.text key:DESkey];
        [parameters setObject:dealpwd forKey:@"dealPwd"];
        
    }
    [parameters setObject:[NSString stringWithFormat:@"%@",AppDelegateInstance.userInfo.userId] forKey:@"userId"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
    }
    _num = 2;
    if (IS_TRUSTEESHIP) {
        
        if (AppDelegateInstance.userInfo.ipsAcctNo.length == 0) { // 如果是企业账户，先判断账户金额，如不够就跳转到充值
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"可用余额不足，是否现在充值？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
            alertView.tag = 1000050;
            
        }else{
             [_requestClient requestGet:self withParameters:parameters payType:TYPE_INVEST navLevel:[self.navigationController.viewControllers indexOfObject:self]];
        }
        
       
    }else{
        [_requestClient requestGet:@"app/services" withParameters:parameters];
    }

}

#pragma 返回按钮触发方法
- (void)backClick
{
    // DLOG(@"返回按钮");
     self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    
    self.navigationController.navigationBarHidden = NO;
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
   
}

@end

//
//  CreditcalViewController.m
//  SP2P_7
//
//  Created by kiu on 14/12/2.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  财富工具箱 -> 信用计算器

#import "CreditcalViewController.h"
#import "ColorTools.h"
#import "QCheckBox.h"

@interface CreditcalViewController ()<UIScrollViewDelegate, HTTPClientDelegate>
{
    NSMutableArray *titleArr;
    NSMutableArray *creditScoreArr;
    
    NSString *amountKey;
}

@property (nonatomic,strong)UIScrollView *ScrollView;
@property (nonatomic,assign)NSInteger integralSum;
@property (nonatomic,assign)NSInteger  balanceSum;
@property (nonatomic,strong)UILabel *label1;
@property (nonatomic,strong)UILabel *label11;
@property (nonatomic,strong)UILabel *label111;
@property (nonatomic,strong)UILabel *label2;
@property (nonatomic,strong)UILabel *label22;
@property (nonatomic,strong)UILabel *label222;
@property (nonatomic,strong)QCheckBox *check;
@property (nonatomic,strong)UIView *downView;
@property (nonatomic, strong)UIButton *submitBtn;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation CreditcalViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self requestData];
}

- (void)viewDidLoad {
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
    
}

/**
 初始化数据
 */
- (void)initView
{
    
    self.view.backgroundColor = KblackgroundColor;
    [self initNavigationBar];
    
    //滚动视图
    _ScrollView =[[UIScrollView alloc] initWithFrame:self.view.bounds];
    _ScrollView.userInteractionEnabled = YES;
    _ScrollView.scrollEnabled = YES;
    _ScrollView.showsHorizontalScrollIndicator = NO;
    _ScrollView.showsVerticalScrollIndicator = NO;
    _ScrollView.delegate = self;
    _ScrollView.backgroundColor = KblackgroundColor;
    [self.view addSubview:_ScrollView];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, MSWIDTH-20, 60)];
    topView.backgroundColor = [UIColor whiteColor];
    [topView.layer setMasksToBounds:YES];
    [topView.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [_ScrollView addSubview:topView];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
    iconView.image = [UIImage imageNamed:@"account_calculator_tishi"];
    [topView addSubview:iconView];
    
    //提示文字
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 8, 230, 50)];
    textLabel.text = @"亲，以下有哪些材料，您可以提供？提供的材料越多，借款额度越高哦！";
    textLabel.numberOfLines = 0;
    textLabel.lineBreakMode =  NSLineBreakByCharWrapping;
    textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [textLabel setTextColor:[UIColor redColor]];
    [topView addSubview:textLabel];
    
    _downView = [[UIView alloc] initWithFrame:CGRectZero];
    _downView.backgroundColor = [UIColor whiteColor];
    [_downView.layer setCornerRadius:4.0f];
    [_ScrollView addSubview:_downView];
    
    //提交按钮
    _submitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_submitBtn setFrame:CGRectZero];
    [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitBtn.layer setCornerRadius:3.0f];
    _submitBtn.backgroundColor = BrownColor;
    [_submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_downView addSubview:_submitBtn];
    
    _label1 = [[UILabel alloc] initWithFrame:CGRectZero];
    _label1.font = [UIFont systemFontOfSize:15.0f];
    _label1.textColor = [UIColor grayColor];
    [_downView addSubview:_label1];
    
    _label11 = [[UILabel alloc] initWithFrame:CGRectZero];
    _label11.font = [UIFont systemFontOfSize:16.0f];
    _label11.textColor = [UIColor redColor];
    [_downView addSubview:_label11];
    
    _label111 = [[UILabel alloc] initWithFrame:CGRectZero];
    _label111.font = [UIFont systemFontOfSize:15.0f];
    _label111.textColor = [UIColor grayColor];
    [_downView addSubview:_label111];
    
    _label2 = [[UILabel alloc] initWithFrame:CGRectZero];
    _label2.font = [UIFont systemFontOfSize:15.0f];
    _label2.textColor = [UIColor grayColor];
    [_downView addSubview:_label2];
    
    _label22 = [[UILabel alloc] initWithFrame:CGRectZero];
    _label22.font = [UIFont systemFontOfSize:16.0f];
    _label22.textColor = [UIColor redColor];
    [_downView addSubview:_label22];
    
    _label222 = [[UILabel alloc] initWithFrame:CGRectZero];
    _label222.font = [UIFont systemFontOfSize:15.0f];
    _label222.textColor = [UIColor grayColor];
    [_downView addSubview:_label222];
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"信用计算器";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
}

#pragma mark 返回按钮
- (void)backClick
{
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma 单选框选中触发方法
- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked {
    DLOG(@"did tap on CheckBox:%@ checked:%d", checkbox.titleLabel.text, checked);
}

#pragma 点击提交按钮触发方法
- (void)submitBtnClick
{
    _integralSum = 0;
    _balanceSum = 0;
    
    for(QCheckBox *check in [_downView subviews])
    {
        if([check isKindOfClass:[QCheckBox class]])
        {
            
            if ([check checked]) {
                _integralSum  += [[creditScoreArr objectAtIndex:check.tag] integerValue];
                _balanceSum = _integralSum * [amountKey integerValue];
            }
            
        }
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    UIFont *font = [UIFont fontWithName:@"Arial" size:15];
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    _label1.text = @"您可以获得";
    _label11.text = [NSString stringWithFormat:@"%ld",(long)_integralSum];
    _label111.text = @"的信用积分";
    
    _label2.text = @"您一共可以借";
    _label22.text = [NSString stringWithFormat:@"%ld",(long)_balanceSum];
    _label222.text = @"元的余款";
    
    
    CGSize _label1Sz = [_label1.text boundingRectWithSize:CGSizeMake(999, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    CGSize _label11Sz = [_label11.text boundingRectWithSize:CGSizeMake(999, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    CGSize _label2Sz = [_label2.text boundingRectWithSize:CGSizeMake(999, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    CGSize _label22Sz = [_label22.text boundingRectWithSize:CGSizeMake(999, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    
    // 根据文本的内容，自定义 frame 值。 CGRectMake(25, 320, 80, 40)
    _label1.frame = CGRectMake(25, _submitBtn.frame.origin.y + 60, _label1Sz.width + 10, 40);
    _label11.frame = CGRectMake(_label1.frame.origin.x + _label1Sz.width + 10, _submitBtn.frame.origin.y + 60, _label11Sz.width + 10, 40);
    _label111.frame = CGRectMake(_label11.frame.origin.x + _label11Sz.width + 10, _submitBtn.frame.origin.y + 60, 80, 40);
    _label2.frame = CGRectMake(25, _submitBtn.frame.origin.y + 90, _label2Sz.width + 10, 40);
    _label22.frame = CGRectMake(_label2.frame.origin.x + _label2Sz.width + 10, _submitBtn.frame.origin.y + 90, _label22Sz.width + 10, 40);
    _label222.frame = CGRectMake(_label22.frame.origin.x + _label22Sz.width + 10, _submitBtn.frame.origin.y + 90, 70, 40);
}

- (void)requestData {
    
    DLOG(@"获取网络启动图片");
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //信用计算器接口
    [parameters setObject:@"124" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
}

#pragma mark HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    NSDictionary *dics = obj;
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        DLOG(@"返回成功===========%@",[obj objectForKey:@"msg"]);
        
        titleArr =[[NSMutableArray alloc] init];
        creditScoreArr =[[NSMutableArray alloc] init];
        
        NSArray *dataArr = [dics objectForKey:@"list"];
        for (NSDictionary *item in dataArr) {
            
            [titleArr addObject:[item objectForKey:@"name"]];
            [creditScoreArr addObject:[item objectForKey:@"creditScore"]];
            
        }
        
        amountKey = [dics objectForKey:@"amountKey"];
        
        // 单选按钮及文本
        for (int i = 0; i < titleArr.count; i++) {
            
            //单选按钮
            _check = [[QCheckBox alloc] initWithDelegate:self];
            [_check setImage:[UIImage imageNamed:@"checkbox3_unchecked.png"] forState:UIControlStateNormal];
            [_check setImage:[UIImage imageNamed:@"checkbox3_checked.png"] forState:UIControlStateSelected];
            
            // 根据 取模 来布局
            if (i % 2) {
                
                _check.frame = CGRectMake(175, 20 + (i -1) * 20, 140, 35);
            }else {
                
                _check.frame = CGRectMake(35 , 20 + i * 20, 140, 35);
                
            }
            
            [_check setTitle:[titleArr objectAtIndex:i] forState:UIControlStateNormal];
            [_check setTag:i];
            
            [_check setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [_check.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
            [_downView addSubview:_check];
        }
        
        if (titleArr.count % 2) {
            
            _downView.frame = CGRectMake(10, 80, MSWIDTH-20, 205 + (titleArr.count * 0.5) * 35 + 50);
            
        }else {
            
            _downView.frame = CGRectMake(10, 80, MSWIDTH-20, 195 + titleArr.count * 0.5 * 35 + 50);
            
        }
        _submitBtn.frame = CGRectMake(self.view.frame.size.width * 0.5 - 60, _downView.frame.size.height - 150, 100, 40);
        _ScrollView.contentSize = CGSizeMake(self.view.frame.size.width, _downView.frame.origin.y + _downView.frame.size.height + 10);
        
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
    }else {
        
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

@end

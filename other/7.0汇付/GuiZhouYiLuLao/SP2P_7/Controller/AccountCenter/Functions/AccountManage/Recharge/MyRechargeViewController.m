//
//  MyRechargeViewController.m
//  SP2P_6.1
//
//  Created by EIMS-IOS on 15-3-1.
//  Copyright (c) 2015年 EIMS. All rights reserved.
//

#import "MyRechargeViewController.h"
#import "MyWebViewController.h"
#import "MSKeyboardScrollView.h"
#import "OpenAccountViewController.h"
#define fontsize 15.0f

@interface MyRechargeViewController ()<UITextFieldDelegate,HTTPClientDelegate,UIScrollViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong)UITextField *rechargeField;
@property (nonatomic,strong) NetWorkClient *requestClient;
@property (nonatomic,strong)UILabel *rentallabel;
@property (nonatomic,strong)UILabel *balancelabel;
@property (nonatomic,strong)UILabel *yuanlabel1;
@property (nonatomic,strong)UILabel *yuanlabel2;
@property (nonatomic,strong)MSKeyboardScrollView *scrollView;
@property (nonatomic,assign)NSInteger requestType;
@end

@implementation MyRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initView];
}

- (void)initData
{
    _requestType = 1;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@"145" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"user_id"];
    
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    [_requestClient requestGet:@"app/services" withParameters:parameters];
}

- (void)initView
{
    [self initNavigationBar];
    self.view.backgroundColor = KblackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //滚动视图
    _scrollView = [[MSKeyboardScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = KblackgroundColor;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 500);
    [self.view addSubview:_scrollView];
    
    //文本
    NSArray *titleArr = @[@"账户总额:",@"其中可用余额为:",@"充值金额"];
    
    for (int i=0; i<3; i++) {
        UILabel *titlelabel = [[UILabel alloc] init];
        titlelabel.font = [UIFont boldSystemFontOfSize:14.0f];
        titlelabel.text = [titleArr objectAtIndex:i];
        titlelabel.frame = CGRectMake(10, 5+i*25, 130, 30);
        if(i == 2)
        {
            titlelabel.frame = CGRectMake(10, 75, 175, 30);
        }
        [_scrollView addSubview:titlelabel];
        
    }

    //总额文本
    _rentallabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 5, 120, 30)];
    _rentallabel.font = [UIFont systemFontOfSize:fontsize];
    _rentallabel.text = @"0.00";
    _rentallabel.textColor = [UIColor redColor];
    [_scrollView addSubview:_rentallabel];
    
    //余额文本
    _balancelabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 30, 120, 30)];
    _balancelabel.font = [UIFont systemFontOfSize:fontsize];
    _balancelabel.text = @"0.00";
    _balancelabel.textColor = [UIColor redColor];
    [_scrollView addSubview:_balancelabel];
    
    _yuanlabel1 = [[UILabel alloc] init];
    _yuanlabel1.frame = CGRectMake(_rentallabel.frame.origin.x+35, 5, 30, 30);
    _yuanlabel1.font = [UIFont systemFontOfSize:fontsize];
    _yuanlabel1.text = @"元";
    [_scrollView addSubview:_yuanlabel1];
    
    _yuanlabel2 = [[UILabel alloc] init];
    _yuanlabel2.frame = CGRectMake(_balancelabel.frame.origin.x+35, 30, 30, 30);
    _yuanlabel2.font = [UIFont systemFontOfSize:fontsize];
    _yuanlabel2.text = @"元";
    [_scrollView addSubview:_yuanlabel2];
    


    _rechargeField = [[UITextField alloc] initWithFrame:CGRectMake(10, 105, self.view.frame.size.width-20, 35)];
    _rechargeField.borderStyle = UITextBorderStyleNone;
    _rechargeField.backgroundColor = [UIColor whiteColor];
    _rechargeField.layer.borderWidth = 0.8f;
    _rechargeField.layer.cornerRadius =3.0f;
    _rechargeField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _rechargeField.layer.masksToBounds = YES;
    _rechargeField.placeholder = @"请输入充值金额";
    _rechargeField.font = [UIFont systemFontOfSize:15.0f];
    [_rechargeField setTag:1];
    _rechargeField.delegate = self;
    _rechargeField.keyboardType = UIKeyboardTypeDecimalPad;
    [_scrollView addSubview:_rechargeField];
    
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sureBtn.frame = CGRectMake(10, CGRectGetMaxY(_rechargeField.frame)+35, self.view.frame.size.width-20, 40);
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.layer.cornerRadius = 3.0f;
    sureBtn.layer.masksToBounds = YES;
    sureBtn.backgroundColor = BrownColor;
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [sureBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(SureClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:sureBtn];
    
}

- (void)initNavigationBar
{
    self.title = @"充值";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    
}

#pragma 返回按钮触发方法
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark 确定点击触发方法
- (void)SureClick
{
      
    if (AppDelegateInstance.userInfo == nil) {
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
        return;
    }
    if (_rechargeField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"输入充值金额!"];
        return;
    }
    
    [_rechargeField resignFirstResponder];
    
    _requestType = 2;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"177" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"userId"];
    [parameters setObject:_rechargeField.text forKey:@"amount"];            // 申请金额
    
    
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
    NSLog(@"充值返回 -> %@",obj);
    NSLog(@"成功 -> %@", [obj objectForKey:@"msg"]);
    
    NSDictionary *dics = obj;
    
    NSString *error = [NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]];
    NSString *msg = [NSString stringWithFormat:@"%@",[dics objectForKey:@"msg"]];
    
    if (_requestType == 1) {
        
        if ([error isEqualToString:@"-1"])
        {
            _rentallabel.text = [NSString stringWithFormat:@"%.2f",[[dics objectForKey:@"userBalance"] doubleValue]];
            _balancelabel.text = [NSString stringWithFormat:@"%.2f", [[dics objectForKey:@"withdrawalAmount"] doubleValue]];
            
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            UIFont *font = [UIFont boldSystemFontOfSize:fontsize];
            NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
            
            
            CGSize rentallabelSiZe = [_rentallabel.text boundingRectWithSize:CGSizeMake(999, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            
            CGSize balancelabelSiZe = [_balancelabel.text boundingRectWithSize:CGSizeMake(999, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            _yuanlabel1.frame = CGRectMake(_rentallabel.frame.origin.x+rentallabelSiZe.width+5, 5, 30, 30);
            _yuanlabel2.frame = CGRectMake(_balancelabel.frame.origin.x+balancelabelSiZe.width+5, 30, 30, 30);
            
        }
        else {
            // 服务器返回数据异常
            [SVProgressHUD showErrorWithStatus:msg];
        }
        
    }
    else if (_requestType == 2)
    {
        if ([error isEqualToString:@"-1"])
        {
            if (![[dics objectForKey:@"htmlParam"]isEqual:[NSNull null]] && [dics objectForKey:@"htmlParam"] != nil)
            {
                NSString *htmlParam = [NSString stringWithFormat:@"%@",[dics objectForKey:@"htmlParam"]];
                MyWebViewController *web = [[MyWebViewController alloc]init];
                web.html = htmlParam;
                web.type = @"2";
                web.level = self.level;
                [self.navigationController pushViewController:web animated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:msg];

            }
        }
        else if ([error isEqualToString:@"-31"])
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您未开通资金托管账户" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"开通", nil];
            alertView.tag = 50;
            [alertView show];
        }
        else {
            // 服务器返回数据异常
            [SVProgressHUD showErrorWithStatus:msg];
        }
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

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_rechargeField resignFirstResponder];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}

#pragma mark UIalerviewdelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    DLOG(@"bttonindex is %ld",(long)buttonIndex);
    
    if (alertView.tag == 50)
    {
        if (buttonIndex == 1)
        {
            OpenAccountViewController *openAccount = [[OpenAccountViewController alloc]init];
            [self.navigationController pushViewController:openAccount animated:YES];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

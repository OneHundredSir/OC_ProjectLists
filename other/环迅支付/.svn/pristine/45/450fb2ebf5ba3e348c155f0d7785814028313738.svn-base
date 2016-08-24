//
//  MyRechargeMYViewController.m
//  SP2P_6.1
//
//  Created by EIMS-IOS on 15-3-1.
//  Copyright (c) 2015年 EIMS. All rights reserved.
//

#import "MyRechargeMYViewController.h"
#import "MSKeyboardScrollView.h"
#import <IPSSDK/RechargeViewController.h>
#import "HXData.h"
#import "LwHXKHViewController.h"

#define fontsize 14.0f

@interface MyRechargeMYViewController ()<UITextFieldDelegate,HTTPClientDelegate,UIScrollViewDelegate,rechargeDelegate,UIAlertViewDelegate>

@property (nonatomic,strong)UITextField *rechargeField;
@property (nonatomic,strong) NetWorkClient *requestClient;
@property (nonatomic,strong)UILabel *rentallabel;
@property (nonatomic,strong)UILabel *balancelabel;
@property (nonatomic,strong)UILabel *yuanlabel1;
@property (nonatomic,strong)UILabel *yuanlabel2;
@property (nonatomic,strong)MSKeyboardScrollView *scrollView;
@property (nonatomic,assign)NSInteger requestType;
@end

@implementation MyRechargeMYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(initData) name:@"rechargeUpdate" object:nil];
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
    _scrollView.userInteractionEnabled = YES;
    _scrollView.scrollEnabled = YES;
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
        
        if (i==0||i==1)
        {
           titlelabel.frame = CGRectMake(10, 5+i*25, 130, 30);
        }
        else if(i==2)
        {
            titlelabel.frame = CGRectMake(10, 75, 180, 30);
        }
        [_scrollView addSubview:titlelabel];
        
    }

    //总额文本
    _rentallabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 5, 120, 30)];
    _rentallabel.font = [UIFont systemFontOfSize:fontsize];
    _rentallabel.text = @"";
    _rentallabel.textColor = [UIColor redColor];
    [_scrollView addSubview:_rentallabel];
    
    //余额文本
    _balancelabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 30, 120, 30)];
    _balancelabel.font = [UIFont systemFontOfSize:fontsize];
    _balancelabel.text = @"";
    _balancelabel.textColor = [UIColor redColor];
    [_scrollView addSubview:_balancelabel];
    
    _yuanlabel1 = [[UILabel alloc] init];
    _yuanlabel1.font = [UIFont systemFontOfSize:fontsize];
    _yuanlabel1.text = @"元";
    [_scrollView addSubview:_yuanlabel1];
    
    _yuanlabel2 = [[UILabel alloc] init];
    _yuanlabel2.font = [UIFont systemFontOfSize:fontsize];
    _yuanlabel2.text = @"元";
    [_scrollView addSubview:_yuanlabel2];
    
    _rechargeField = [[UITextField alloc] initWithFrame:CGRectMake(10, 105, self.view.frame.size.width-20, 30)];
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
    sureBtn.frame = CGRectMake(10, CGRectGetMaxY(_rechargeField.frame)+35, self.view.frame.size.width-20, 35);
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.layer.cornerRadius = 3.0f;
    sureBtn.layer.masksToBounds = YES;
    sureBtn.backgroundColor = GreenColor;
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
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
//    [self dismissViewControllerAnimated:YES completion:^(){}];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 充值
- (void)SureClick
{
      
    if (AppDelegateInstance.userInfo == nil) {
        [SVProgressHUD showErrorWithStatus:@"请登录!"];
        return;
    }
    [_rechargeField resignFirstResponder];
    
    _requestType = 2;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"203" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"userId"];
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"user_id"];
    [parameters setObject:_rechargeField.text forKey:@"money"];            // 申请金额
    [parameters setObject:_rechargeField.text forKey:@"amount"];
    [parameters setObject:@"2" forKey:@"app"];//客户端类型
    
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
    
    NSLog(@"%@",dics);
    
    if (_requestType == 1) {
        
        if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
            
            NSLog(@"成功 -> %@", dics);
            NSLog(@"msg -> %@", [obj objectForKey:@"msg"]);
            
            _rentallabel.text = [NSString stringWithFormat:@"%.2f", [[obj objectForKey:@"userBalance"] floatValue]];
            _balancelabel.text = [NSString stringWithFormat:@"%.2f", [[obj objectForKey:@"withdrawalAmount"] doubleValue]];
            
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            UIFont *font = [UIFont boldSystemFontOfSize:fontsize];
            NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
            
            
            CGSize rentallabelSiZe = [_rentallabel.text boundingRectWithSize:CGSizeMake(999, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            
            CGSize balancelabelSiZe = [_balancelabel.text boundingRectWithSize:CGSizeMake(999, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            _yuanlabel1.frame = CGRectMake(_rentallabel.frame.origin.x+rentallabelSiZe.width+5, 5, 30, 30);
            _yuanlabel2.frame = CGRectMake(_balancelabel.frame.origin.x+balancelabelSiZe.width+5, 30, 30, 30);
            
        }
    }
    else if (_requestType == 2)
    {
        
        //        if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-31"])
        //        {
        //
        //            UIAlertView * alert  = [[UIAlertView alloc] initWithTitle:@"消息提示" message:[dics objectForKey:@"msg"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去开通", nil];
        //            [alert show];
        //            return;
        //
        //        }
        
        
        if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"])
        {
            NSLog(@"充值返回 -> %@",dics);
            //NSLog(@"成功 -> %@", [obj objectForKey:@"msg"]);
            
            HXData * item = [[HXData alloc] init];
            
            item.pMerCode = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pMerCode"]];
            item.pMerBillNo = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pMerBillNo"]];
            item.pAcctType = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pAcctType"]];
            item.pIdentNo = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pIdentNo"]];
            item.pRealName = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pRealName"]];
            item.pIpsAcctNo = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pIpsAcctNo"]];
            item.pTrdDate = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pTrdDate"]];
            item.pTrdAmt = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pTrdAmt"]];
            item.pChannelType = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pChannelType"]];
            item.pTrdBnkCode = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pTrdBnkCode"]];
            item.pMerFee = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pMerFee"]];
            item.pIpsFeeType = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pIpsFeeType"]];
            item.pS2SUrl = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pS2SUrl"]];
            item.pMemo1 = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pMemo1"]];
            item.pMemo2 = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pMemo2"]];
            item.pMemo3 = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pMemo3"]];
            
            
//            NSLog(@"%@",item.pMerCode);
            [RechargeViewController rechargeWithPlatform:nil pMerCode:item.pMerCode pMerBillNo:item.pMerBillNo pAcctType:item.pAcctType pIdentNo:item.pIdentNo pRealName:item.pRealName pIpsAcctNo:item.pIpsAcctNo pTrdDate:item.pTrdDate pTrdAmt:item.pTrdAmt pChannelType:item.pChannelType pTrdBnkCode:item.pTrdBnkCode pMerFee:item.pMerFee pIpsFeeType:item.pIpsFeeType pS2SUrl:item.pS2SUrl pWhichAction:@"2" ViewController:self Delegate:self pMemo1:item.pMemo1 pMemo2:item.pMemo2 pMemo3:item.pMemo3];

            [[NSNotificationCenter defaultCenter] postNotificationName:@"rechargeUpdate" object:nil];

        }
        else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-31"])
        {
            //            OpenAccountViewController *openAccount = [[OpenAccountViewController alloc] init];
            //            [self.navigationController pushViewController:openAccount animated:YES];
            
            
            UIAlertView * alert  = [[UIAlertView alloc] initWithTitle:@"消息提示" message:[dics objectForKey:@"msg"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去开通", nil];
            [alert show];
            
            
        }
        else {
            // 服务器返回数据异常
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
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

- (void)rechargeResult:(NSString *)pErrCode ErrMsg:(NSString *)pErrMsg MerCode:(NSString *)pMerCode BillNO:(NSString *)pBillNO IpsAcctNo:(NSString *)pIpsAcctNo AcctType:(NSString *)pAcctType IdentNo:(NSString *)pIdentNo RealName:(NSString *)pRealName TrdDate:(NSString *)pTrdDate TrdAmt:(NSString *)pTrdAmt TrdBnkCode:(NSString *)pTrdBnkCode IpsBillNo:(NSString *)pIpsBillNo CupBillNo:(NSString *)pCupBillNo Memo1:(NSString *)pMemo1 Memo2:(NSString *)pMemo2 Memo3:(NSString *)pMemo3
{
    DLOG(@"%@",pErrMsg);
//    [SVProgressHUD showErrorWithStatus:pErrMsg];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        LwHXKHViewController *openAccount = [[LwHXKHViewController alloc] init];
        [self.navigationController pushViewController:openAccount animated:YES];
        
        
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}



-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

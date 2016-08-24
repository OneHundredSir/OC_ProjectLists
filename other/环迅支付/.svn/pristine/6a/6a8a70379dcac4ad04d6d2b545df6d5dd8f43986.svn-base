//
//  LwHXKHViewController.m
//  SP2P_6.1
//
//  Created by cassfile on 15-8-11.
//  Copyright (c) 2015年 EIMS. All rights reserved.
//

//环迅开户

#import "LwHXKHViewController.h"
#import "HXData.h"
#import <IPSSDK/OpenAccountViewController.h>
#import "AccountInfoViewController.h"

@interface LwHXKHViewController ()<HTTPClientDelegate,openAccountBankInfoDelegate,UIAlertViewDelegate>


@property (nonatomic,strong) NetWorkClient *requestClient;

@end

@implementation LwHXKHViewController

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self khcshRequest];
//    
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initNavigationBar];
    
    [self khcshRequest];
}

- (void)initNavigationBar
{
    self.title = @"环迅资金托管开户";
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)khcshRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@"201" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:AppDelegateInstance.userInfo.userId forKey:@"userId"];
    [parameters setObject:@"2" forKey:@"app"];
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
    
      if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
          
          //增加资料是否完善判断
          NSLog(@"pEmail = %@ ",[dics objectForKey:@"pEmail"]);
          if (![dics objectForKey:@"pEmail"] || ![dics objectForKey:@"pIdentNo"] || ![dics objectForKey:@"pRealName"] || ![dics objectForKey:@"pMobileNo"]) {
              UIAlertView * alert  = [[UIAlertView alloc] initWithTitle:@"消息提示" message:@"请先完善个人资料" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
              [alert show];
          }else{
              
              HXData * item = [[HXData alloc] init];
              
              item.pIdentNo = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pIdentNo"]];
              item.pMobileNo = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pMobileNo"]];
              item.pRealName = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pRealName"]];
              item.pEmail = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pEmail"]];
              item.pS2SUrl = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pS2SUrl"]];
              item.pWebUrl = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pWebUrl"]];
              item.pMerCode = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pMerCode"]];
              item.pSmDate = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pSmDate"]];
              item.pMerBillNo = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pMerBillNo"]];
              item.pIdentType = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pIdentType"]];
              item.pMemo1 = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pMemo1"]];
              item.pMemo2 = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pMemo2"]];
              item.pMemo3 = [NSString stringWithFormat:@"%@",[dics objectForKey:@"pMemo3"]];
              
              [OpenAccountViewController openAccountVerityWithPlatform:@"" pMerCode:item.pMerCode pMerBillNo:item.pMerBillNo pIdentType:item.pIdentType pIdentNo:item.pIdentNo pRealName:item.pRealName pMobileNo:item.pMobileNo pEmail:item.pEmail pSmDate:item.pSmDate pS2SUrl:item.pS2SUrl pWhichAction:@"1" ViewController:self Delegate:self pMemo1:item.pMemo1 pMemo2:item.pMemo2 pMemo3:item.pMemo3];
              
              //          [OpenAccountViewController openAccountVerityWithPlatform:@"" pMerCode:item.pMerCode pMerBillNo:item.pMerBillNo pIdentType:item.pIdentType pIdentNo:item.pIdentNo pRealName:item.pRealName pMobileNo:item.pMobileNo pEmail:item.pEmail pSmDate:item.pSmDate pS2SUrl:item.pS2SUrl pMemo1:@"1" pMemo2:item.pMemo2 pMemo3:item.pMemo3 ViewController:self Delegate:self];
          }
          

          
          
      }else {
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
    [SVProgressHUD showErrorWithStatus:@"无可用网络"];
}

- (void)openAccountResult:(NSString *)pErrCode ErrMsg:(NSString *)pErrMsg MerCode:(NSString *)pMerCode MerBillNo:(NSString *)pMerBillNo SmDate:(NSString *)pSmDate Email:(NSString *)pEmail IdentNo:(NSString *)pIdentNo RealName:(NSString *)pRealName MobileNo:(NSString *)pMobileNo BkName:(NSString *)pBankName BkAccName:(NSString *)pBkAccName BkAccNo:(NSString *)pBkAccNo CardStatus:(NSString *)pCardStatus PhStatus:(NSString *)pPhStatus IpsAcctNo:(NSString *)pIpsAcctNo IpsAcctDate:(NSString *)pIpsAcctDate Status:(NSString *)pStatus Memo1:(NSString *)pMemo1 Memo2:(NSString *)pMemo2 Memo3:(NSString *)pMemo3
{
    DLOG(@"%@",pErrMsg);
//    [SVProgressHUD showErrorWithStatus:pErrMsg];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        AccountInfoViewController *AccountInfo = [[AccountInfoViewController alloc] init];
        AccountInfo.popType = 1;
        [self.navigationController pushViewController:AccountInfo animated:YES];
        
        
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

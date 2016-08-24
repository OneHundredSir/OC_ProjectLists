//
//  RechargeViewController.h
//  CapitalManagementPlatform
//
//  Created by push pull on 15-2-15.
//  Copyright (c) 2015年 zhangxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyConnection.h"
#import "AppDelegate.h"
#import "UPPayPluginDelegate.h"
#import "UPPayPlugin.h"
#import "PassGuardCtrl.h"

@class RechargeViewController;
@protocol rechargeDelegate <NSObject>

@optional
-(void)rechargeResult:(NSString *) pErrCode
               ErrMsg:(NSString *) pErrMsg
              MerCode: (NSString *) pMerCode
               BillNO: (NSString *) pBillNO
           IpsAcctNo : (NSString *) pIpsAcctNo
             AcctType: (NSString *) pAcctType
              IdentNo: (NSString *) pIdentNo
             RealName: (NSString *) pRealName
              TrdDate: (NSString *) pTrdDate
               TrdAmt: (NSString *) pTrdAmt
           TrdBnkCode: (NSString *) pTrdBnkCode
            IpsBillNo: (NSString *) pIpsBillNo
            CupBillNo: (NSString *) pCupBillNo
               Memo1:  (NSString *)pMemo1
               Memo2:  (NSString *)pMemo2
               Memo3:  (NSString *)pMemo3;

@end

@interface RechargeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,UPPayPluginDelegate,DoneDelegate>{
    
    MyConnection *jsonConnection;
    NSURLConnection *con;
    UITableView *retableViewInfo;
    PassGuardTextField *tranPassword;
    
    UIView *alertView1;
    
    NSString * pErrCode;//返回码
    NSString * pErrMsg;//返回原因
    NSString * pMerBillNo;//订单号
    NSString * pMerCode;//商户号
    NSString * pIpsAcctNo;//IPS账户号
    NSString * pAcctType;//账户类型
    NSString * pIdentNo;//证件号码
    NSString * pRealName;//姓名
    NSString * pTrdDate;//
    NSString * pTrdAmt;//充值金额
    NSString * pTrdBnkCode;//
    NSString * pIpsBillNo;//IPS充值订单号
    NSString * pCupBillNo;//银联流水号
    NSString * pMemo1;
    NSString * pMemo2;
    NSString * pMemo3;
}

@property (nonatomic, assign) UIViewController *controller;
@property (weak, nonatomic) id<rechargeDelegate> delegate;
@property (nonatomic, copy) NSString * tnMode;
@property (nonatomic) BOOL isRechargeVerityOK;;
@property (nonatomic, strong)  UILabel * lable;

+(void)rechargeWithPlatform:(NSString *)platform pMerCode:(NSString *)pMerCode pMerBillNo:(NSString *)pMerBillNo pAcctType:(NSString *)pAcctType pIdentNo:(NSString *)pIdentNo pRealName:(NSString *)pRealName pIpsAcctNo:(NSString *)pIpsAcctNo pTrdDate:(NSString *)pTrdDate pTrdAmt:(NSString *)pTrdAmt pChannelType:(NSString *)pChannelType pTrdBnkCode:(NSString *)pTrdBnkCode pMerFee:(NSString *)pMerFee pIpsFeeType:(NSString *)pIpsFeeType pS2SUrl:(NSString *)pS2SUrl pWhichAction:(NSString*)pWhichAction ViewController:(UIViewController *)selfViewController Delegate:(id<rechargeDelegate>)delegate pMemo1:(NSString *)pMemo1 pMemo2:(NSString *)pMemo2 pMemo3:(NSString *)pMemo3;

@end

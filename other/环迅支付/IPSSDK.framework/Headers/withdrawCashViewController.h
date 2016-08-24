//
//  withdrawCashViewController.h
//  CapitalManagementPlatform
//
//  Created by push pull on 15-2-16.
//  Copyright (c) 2015年 zhangxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyConnection.h"
#import "AppDelegate.h"
#import "PassGuardCtrl.h"

@class withdrawCashViewController;
@protocol withdrawCashDelegate <NSObject>

@optional
-(void)extractMoneyResult:(NSString *) pErrCode
                   ErrMsg:(NSString *) pErrMsg
                  MerCode: (NSString *) pMerCode
                MerBillNo: (NSString *) pMerBillNo
                 AcctType: (NSString *) pAcctType
                  IdentNo: (NSString *) pIdentNo
                 RealName: (NSString *) pRealName
               IpsAcctNo : (NSString *) pIpsAcctNo
                   DwDate: (NSString *) pDwDate
                   TrdAmt: (NSString *) pTrdAmt
                IpsBillNo: (NSString *) pIpsBillNo
                    Memo1:  (NSString *)pMemo1
                    Memo2:  (NSString *)pMemo2
                    Memo3:  (NSString *)pMemo3;

//- (void)drawCashResultWithData:(NSDictionary *)data;

@end

@interface withdrawCashViewController : UIViewController<UINavigationControllerDelegate,UINavigationBarDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,DoneDelegate>{
    MyConnection *jsonConnection;
    NSURLConnection *con;
    UITableView *withdrawtableViewInfo;
    PassGuardTextField *tranPasswordwithdraw;
}

@property (nonatomic, assign) UIViewController *controller;
@property (weak, nonatomic) id<withdrawCashDelegate> delegate;
@property (nonatomic) BOOL isDrawCashVerityOK;;
@property (nonatomic, strong)  UILabel * lable;

//4.7 外部提现
+(void)extractMoneyWithPlatform:(NSString *)platform pMerCode:(NSString *)pMerCode pMerBillNo:(NSString *)pMerBillNo pAcctType:(NSString *)pAcctType pOutType:(NSString *)pOutType pBidNo:(NSString *)pBidNo pContractNo:(NSString *)pContractNo pDwTo:(NSString *)pDwTo pIdentNo:(NSString *)pIdentNo pRealName:(NSString *)pRealName pIpsAcctNo:(NSString *)pIpsAcctNo pDwDate:(NSString *)pDwDate pTrdAmt:(NSString *)pTrdAmt pMerFee:(NSString *)pMerFee pIpsFeeType:(NSString *)pIpsFeeType pS2SUrl:(NSString *)pS2SUrl pWhichAction:(NSString*)pWhichAction ViewController:(UIViewController *)selfViewController Delegate:(id<withdrawCashDelegate>)delegate pMemo1:(NSString *)pMemo1 pMemo2:(NSString *)pMemo2 pMemo3:(NSString *)pMemo3;

@end

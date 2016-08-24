//
//  RepaymentViewController.h
//  CapitalManagementPlatform
//
//  Created by push pull on 15-2-15.
//  Copyright (c) 2015年 zhangxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyConnection.h"
#import "AppDelegate.h"
#import "PassGuardCtrl.h"

@class RepaymentViewController;
@protocol repaymentDelegate <NSObject>

@optional
-(void) repaymentResult:(NSString *) pErrCode
                 ErrMsg:(NSString *) pErrMsg
                MerCode: (NSString *) pMerCode
              MerBillNo: (NSString *) pMerBillNo
                 BidNo : (NSString *) pBidNo
         RepaymentDate : (NSString *) pRepaymentDate
             IpsBillNo : (NSString *) pIpsBillNo
             OutAcctNo : (NSString *) pOutAcctNo
                OutAmt : (NSString *) pOutAmt
                OutFee : (NSString *) pOutFee
             OutIpsFee : (NSString *) pOutIpsFee
                  Memo1: (NSString *) pMemo1
                  Memo2: (NSString *) pMemo2
                  Memo3: (NSString *) pMemo3;


//- (void)repaymentResultWithData:(NSDictionary *)data;

@end

@interface RepaymentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,DoneDelegate>{
    MyConnection *jsonConnection;
    NSURLConnection *con;
    UITableView *retableViewInfo;
    PassGuardTextField *tranPassword;
}
@property (nonatomic, assign) UIViewController *controller;
@property (weak, nonatomic) id<repaymentDelegate> delegate;

//还款
+(void)repaymentWithPlatform:(NSString *)platform pMerCode:(NSString *)pMerCode pBidNo:(NSString *)pBidNo pRepaymentDate:(NSString *)pRepaymentDate pMerBillNo:(NSString *)pMerBillNo pRepayType:(NSString *)pRepayType pIpsAuthNo:(NSString *)pIpsAuthNo pOutAcctNo:(NSString *)pOutAcctNo pOutAmt:(NSString *)pOutAmt pOutFee:(NSString *)pOutFee pS2SUrl:(NSString *)pS2SUrl  pDetails:(NSArray*)pDeilsArr pWhichAction:(NSString*)pWhichAction ViewController:(UIViewController *)selfViewController Delegate:(id<repaymentDelegate>)delegate pMemo1:(NSString *)pMemo1 pMemo2:(NSString *)pMemo2 pMemo3:(NSString *)pMemo3;

@end

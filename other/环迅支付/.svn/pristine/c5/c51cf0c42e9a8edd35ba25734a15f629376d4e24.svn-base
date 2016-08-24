//
//  zqzrViewController.h
//  CapitalManagementPlatform
//
//  Created by push pull on 15-2-16.
//  Copyright (c) 2015年 zhangxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyConnection.h"
#import "AppDelegate.h"
#import "PassGuardCtrl.h"

@class zqzrViewController;
@protocol zqzrDelegate <NSObject>

@optional
-(void) transferBondResult:(NSString *) pErrCode
                    ErrMsg:(NSString *) pErrMsg
                   MerCode: (NSString *) pMerCode
                 MerBillNo: (NSString *) pMerBillNo
                    BidNo : (NSString *) pBidNo
          FromAccountType : (NSString *) pFromAccountType
                 FromName : (NSString *) pFromName
              FromAccount : (NSString *) pFromAccount
            FromIdentType : (NSString *) pFromIdentType
              FromIdentNo : (NSString *) pFromIdentNo
            ToAccountType : (NSString *) pToAccountType
            ToAccountName : (NSString *) pToAccountName
                ToAccount : (NSString *) pToAccount
              ToIdentType : (NSString *) pToIdentType
                ToIdentNo : (NSString *) pToIdentNo
             CreMerBillNo : (NSString *) pCreMerBillNo
                  CretAmt : (NSString *) pCretAmt
                   PayAmt : (NSString *) pPayAmt
                 CretType : (NSString *) pCretType
                  FromFee : (NSString *) pFromFee
                    ToFee : (NSString *) pToFee
                   Status : (NSString *) pStatus
                P2PBillNo : (NSString *) pP2PBillNo
                     Memo1:  (NSString *)pMemo1
                     Memo2:  (NSString *)pMemo2
                     Memo3:  (NSString *)pMemo3;

@end

@interface zqzrViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,DoneDelegate>{
    MyConnection *jsonConnection;
    NSURLConnection *con;
    UITableView *tensertableViewInfo;
    PassGuardTextField *tranPasswordternder;
}
@property (nonatomic, assign) UIViewController *controller;
@property (weak, nonatomic) id<zqzrDelegate> delegate;

//债权转让
+(void)transferBondWithPlatform:(NSString *)platform pMerCode:(NSString *)pMerCode pMerBillNo:(NSString *)pMerBillNo pMerDate:(NSString *)pMerDate pBidNo:(NSString *)pBidNo pContractNo:(NSString *)pContractNo pFromAccountType:(NSString *)pFromAccountType pFromName:(NSString *)pFromName pFromAccount:(NSString *)pFromAccount pFromIdentType:(NSString *)pFromIdentType pFromIdentNo:(NSString *)pFromIdentNo pToAccountType:(NSString *)pToAccountType pToAccountName:(NSString *)pToAccountName pToAccount:(NSString *)pToAccount pToIdentType:(NSString *)pToIdentType pToIdentNo:(NSString *)pToIdentNo pCreMerBillNo:(NSString *)pCreMerBillNo pCretAmt:(NSString *)pCretAmt pPayAmt:(NSString *)pPayAmt pFromFee:(NSString *)pFromFee pToFee:(NSString *)pToFee pCretType:(NSString *)pCretType pS2SUrl:(NSString *)pS2SUrl pWhichAction:(NSString*)pWhichAction ViewController:(UIViewController *)selfViewController Delegate:(id<zqzrDelegate>)delegate pMemo1:(NSString *)pMemo1 pMemo2:(NSString *)pMemo2 pMemo3:(NSString *)pMemo3;


@end

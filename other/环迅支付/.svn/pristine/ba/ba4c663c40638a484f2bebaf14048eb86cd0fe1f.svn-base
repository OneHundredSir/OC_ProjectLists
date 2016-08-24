//
//  tenderViewController.h
//  CapitalManagementPlatform
//
//  Created by push pull on 15-2-16.
//  Copyright (c) 2015年 zhangxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyConnection.h"
#import "AppDelegate.h"
#import "PassGuardCtrl.h"

@class tenderViewController;
@protocol tenderDelegate <NSObject>

@optional
-(void) biddingResult:(NSString *) pErrCode
               ErrMsg:(NSString *) pErrMsg
              MerCode: (NSString *) pMerCode
            MerBillNo: (NSString *) pMerBillNo
        AccountDealNo: (NSString *) pAccountDealNo
           BidDealNo : (NSString *) pBidDealNo
                BidNo: (NSString *) pBidNo
          ContractNo : (NSString *) pContractNo
            BusiType : (NSString *) pBusiType
             AuthAmt : (NSString *) pAuthAmt
              TrdAmt : (NSString *) pTrdAmt
                 Fee : (NSString *) pFee
         TransferAmt : (NSString *) pTransferAmt
             Account : (NSString *) pAccount
              Status : (NSString *) pStatus
           P2PBillNo : (NSString *) pP2PBillNo
             IpsTime : (NSString *) pIpsTime
                Memo1:  (NSString *)pMemo1
                Memo2:  (NSString *)pMemo2
                Memo3:  (NSString *)pMemo3;

//- (void)tenderResultWithData:(NSDictionary *)data;

@end

@interface tenderViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,DoneDelegate>{
    UITableView *tensertableViewInfo;
    PassGuardTextField *tranPasswordternder;
    MyConnection *jsonConnection;
    NSURLConnection *con;
}

@property (nonatomic, assign) UIViewController *controller;
@property (weak, nonatomic) id<tenderDelegate> delegate;

//投标
+(void)biddingWithPlatform:(NSString *)platform pMerCode:(NSString *)pMerCode pMerBillNo:(NSString *)pMerBillNo pMerDate:(NSString *)pMerDate pBidNo:(NSString *)pBidNo pContractNo:(NSString *)pContractNo pRegType:(NSString *)pRegType pAuthNo:(NSString *)pAuthNo pAuthAmt:(NSString *)pAuthAmt pTrdAmt:(NSString *)pTrdAmt pFee:(NSString *)pFee pAcctType:(NSString *)pAcctType pIdentNo:(NSString *)pIdentNo pRealName:(NSString *)pRealName pAccount:(NSString *)pAccount pUse:(NSString *)pUse pS2SUrl:(NSString *)pS2SUrl pWhichAction:(NSString*)pWhichAction ViewController:(UIViewController *)selfViewController  Delegate:(id<tenderDelegate>)delegate pMemo1:(NSString *)pMemo1 pMemo2:(NSString *)pMemo2 pMemo3:(NSString *)pMemo3;

@end

//
//  OpenAccountViewController.h
//  CapitalManagementPlatform
//
//  Created by push pull on 15-2-11.
//  Copyright (c) 2015年 zhangxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyConnection.h"
#import "AppDelegate.h"
#import "oPenAccountBankInfoViewController.h"

@interface OpenAccountViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate,UINavigationBarDelegate,UINavigationControllerDelegate>{
    NSString *platformName;
    NSString *accountName;
    NSString *userName;
    NSString *certificateType;
    NSString *certificateNo;
    NSString *telephoneNo;
    UITableView *tableViewInfo;
    UITextField *identifyCode;
    UIButton *agreeButton;
    UIView *viewbg1;
    UIView *viewbg2;
    UIScrollView *viewbg3;
    MyConnection *jsonConnection;
    NSURLConnection *con;
    
    UIButton * IdentifyCodebtn;
    UILabel * remainTime;
    
    UIView *lineview;
    UIButton *sureButton;
    
    int getCodeTimes;
}

@property (nonatomic, assign) UIViewController *controller;
@property (nonatomic, assign) id midDelegate;
@property (nonatomic) BOOL isOpenVerityOK;;

//4.2开户－验证
+(void)openAccountVerityWithPlatform:(NSString *)platform pMerCode:(NSString *)pMerCode pMerBillNo:(NSString *)pMerBillNo pIdentType:(NSString *)pIdentType pIdentNo:(NSString *)pIdentNo pRealName:(NSString *)pRealName pMobileNo:(NSString *)pMobileNo pEmail:(NSString *)pEmail pSmDate:(NSString *)pSmDate pS2SUrl:(NSString *)pS2SUrl pWhichAction:(NSString*)pWhichAction ViewController:(UIViewController *)selfViewController Delegate:(id<openAccountBankInfoDelegate>)delegate pMemo1:(NSString *)pMemo1 pMemo2:(NSString *)pMemo2 pMemo3:(NSString *)pMemo3;

@end

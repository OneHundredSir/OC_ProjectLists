//
//  oPenAccountBankInfoViewController.h
//  CapitalManagementPlatform
//
//  Created by push pull on 15-2-13.
//  Copyright (c) 2015年 zhangxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyConnection.h"

@class oPenAccountBankInfoViewController;
@protocol openAccountBankInfoDelegate <NSObject>

@optional
-(void)openAccountResult:(NSString *) pErrCode
                  ErrMsg:(NSString *) pErrMsg
                 MerCode: (NSString *) pMerCode
               MerBillNo: (NSString *) pMerBillNo
                 SmDate : (NSString *) pSmDate
                   Email: (NSString *) pEmail
                 IdentNo: (NSString *) pIdentNo
                RealName: (NSString *) pRealName
                MobileNo: (NSString *) pMobileNo
                  BkName: (NSString *) pBankName
               BkAccName: (NSString *) pBkAccName
                 BkAccNo: (NSString *) pBkAccNo
              CardStatus: (NSString *) pCardStatus
                PhStatus: (NSString *) pPhStatus
              IpsAcctNo : (NSString *) pIpsAcctNo  
             IpsAcctDate: (NSString *) pIpsAcctDate
                  Status: (NSString *) pStatus
                   Memo1:  (NSString *)pMemo1
                   Memo2:  (NSString *)pMemo2
                   Memo3:  (NSString *)pMemo3;
@end

@interface oPenAccountBankInfoViewController : UIViewController<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>{
    UITableView *mytableBankInfo;
    NSString *platfromname;
    UITextField *zhihangNametext;
    UITextField *accountNotext;
    UIPickerView  *MypickerView;
    NSString *resilut;
    UILabel *rightlabe1;
    MyConnection *jsonConnection;
    NSURLConnection *con;
    NSString *pwdlogin;
    NSString *pwdtran;
    NSMutableArray *arraysheng;
    NSMutableArray *arrayshengname;
    NSMutableDictionary *shidic;
    NSMutableArray *arrayshi;
    NSMutableDictionary *shengshidic;
    NSMutableDictionary *shengshidic2;/////不带等号后面的code
    NSString *selectshengname;
    NSString *seletshengno;
    NSMutableArray *arrayshiname;
    
    NSString * province;
    NSString * provinceNO;
    NSString * city;
    NSString * cityNO;
    UIView * toolBarBg;
    NSString * defaultAdd;//默认开户行地址
    
    NSString * pMemo1;
    NSString * pMemo2;
    NSString * pMemo3;
}
@property (nonatomic,retain)NSString *platfromname;
@property (nonatomic,retain)NSString *pwdlogin;
@property (nonatomic,retain)NSString *pwdtran;

@property(nonatomic,strong)UIToolbar *toolbar;

@property (weak, nonatomic) id<openAccountBankInfoDelegate> delegate;

@end

//
//  AJAccountHeaderView.h
//  SP2P_7
//
//  Created by Ajax on 16/1/14.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, clickBtnTo){
    clickBtnToMessage,       // 消息
    clickBtnToPortrait,    //头像
    clickBtnToRecharge,      // 充值
    clickBtnToWithdrawal, // 提现
     clickBtnToDetail // 明细
};
@protocol AJAccountHeaderViewDelegate <NSObject>

@optional
- (void)AJAccountHeaderViewWithClickBtnTo:(clickBtnTo)sender;
@end
@class AJAccountHeaderData;
@interface AJAccountHeaderView : UIView
@property (nonatomic, weak) id<AJAccountHeaderViewDelegate> delegate;
@property (nonatomic,strong) AJAccountHeaderData *aAJAccountHeaderData;//头像
- (instancetype)initWithDelegate:(id)delegate;
+ (instancetype)headerViewWithDelegate:(id)delegate;
@end

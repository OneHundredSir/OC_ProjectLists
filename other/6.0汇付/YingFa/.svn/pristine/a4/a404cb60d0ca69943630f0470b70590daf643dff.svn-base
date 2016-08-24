//
//  PushAlertView.h
//  SP2P_6.1
//
//  Created by kiu on 14/11/27.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PushAlertView : UIView

- (id)initWithTitle:(NSString *)title collectCapitalText:(NSString *)collectCapital hightestBidText:(NSString *)hightestBid offerPriceText:(NSString *)offerPrice leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rigthTitle;

- (void)show;

@property (nonatomic, copy) dispatch_block_t leftBlock;
@property (nonatomic, copy) dispatch_block_t rightBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock;

@property (nonatomic,strong)  UITextField *alertnewPriceTF;           // 新的竞价
@property (nonatomic,strong)  UITextField *dealpwdTextF;           // 新的竞价
@end

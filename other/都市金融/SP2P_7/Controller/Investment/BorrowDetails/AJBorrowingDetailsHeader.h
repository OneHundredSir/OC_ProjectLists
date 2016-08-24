//
//  AJBorrowingDetailsHeader.h
//  SP2P_7
//
//  Created by Ajax on 16/1/22.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#define kblackColor @"#646464"
#define kAmoutTextW 80.f
#define kLabelBeginX 15.f
#define kPadding 10.f
#define kLeftBgViewH 30.f
#define kidLabelH 30.f
#import <UIKit/UIKit.h>

@class AJBorrowingDetailsHeaderData;
@interface AJBorrowingDetailsHeader : UIView
@property (nonatomic,strong) AJBorrowingDetailsHeaderData *aAJBorrowingDetailsHeaderData;

- (instancetype)initWithHeight:(CGFloat)height;
- (UILabel *)labelViewWithFont:(CGFloat)size textColor:(UIColor*)color;
@end

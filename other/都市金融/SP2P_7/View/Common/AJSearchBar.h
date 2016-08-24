//
//  AJSearchBar.h
//  SP2P_7
//
//  Created by Ajax on 16/1/15.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AJSearchBar;
typedef void(^AJSearchBarSearchBlock)(AJSearchBar*);
@interface AJSearchBar : UITextField
@property (nonatomic, copy) AJSearchBarSearchBlock searchBlock;
- (instancetype)initWithFrame:(CGRect)frame searchBlock:(AJSearchBarSearchBlock)searchBlock;
@end

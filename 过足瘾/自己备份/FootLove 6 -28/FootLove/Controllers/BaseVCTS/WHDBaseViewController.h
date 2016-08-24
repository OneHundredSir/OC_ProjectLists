//
//  WHDBaseViewController.h
//  FootLove
//
//  Created by HUN on 16/6/27.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHDBaseViewController : UIViewController

@property(nonatomic,copy)void (^leftBtnBlock)();

@property(nonatomic,copy)void (^rightBtnBlock)();


/** 设置左边的按钮 */
-(void)setLeftBtn:(NSString *)iconStr andTitle:(NSString *)titleStr;

/** 设置右边的按钮 */
-(void)setRightBtn:(NSString *)iconStr andTitle:(NSString *)titleStr;

/** 设置顶部 */
-(void)setViewTitle:(NSString *)title;


/**
 *  可以重写左右键的方法
 */
-(void)_initIcon;

@end

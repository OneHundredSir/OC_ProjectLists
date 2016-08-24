//
//  BaseViewController.h
//  JoinTheFoot
//
//  Created by skd on 16/6/27.
//  Copyright © 2016年 lzm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic , copy) void (^leftAct) (UIButton *leftBtn);
@property (nonatomic , copy) void (^rightAct) (UIButton *rightBtn);
//左边按钮
- (void)setLeftItem:(NSString *)title OrImage:(NSString *)image;

//顶部按钮
- (void)setTopView:(NSString *)title;

//右边按钮
- (void)setRightItem:(NSString *)title OrImage:(NSString *)image;



@end

//
//  LoginViewController.h
//  Flower
//
//  Created by HUN on 16/7/7.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "BaseViewController.h"
@class RegisterViewController;
@class ForgetViewController;
@interface LoginViewController : BaseViewController

#pragma mark 返回去的block
@property(nonatomic,copy)void (^backVCBlock)(BOOL ret);

#pragma mark 隐藏的注册控制器
@property(nonatomic,weak)RegisterViewController *registerVC;

#pragma mark 隐藏的忘记密码控制器
@property(nonatomic,weak)ForgetViewController *forgetVC;




@end

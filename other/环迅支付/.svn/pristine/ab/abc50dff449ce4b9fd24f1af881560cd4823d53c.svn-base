//
//  ReLogin.m
//  SP2P_7
//
//  Created by Jerry on 15/6/23.
//  Copyright (c) 2015年 EIMS. All rights reserved.
//

#import "ReLogin.h"
#import "RestUIAlertView.h"
#import "LoginViewController.h"

@implementation ReLogin

+ (void)outTheTimeRelogin:(UIViewController *)viewController
{
    // 登录过期
    RestUIAlertView *restAlert  =  [[RestUIAlertView alloc] initWithTitle:@"登录提示" content:@"亲，未登录或登录过期，请重新登录！"];
    
    restAlert.leftBlock = ^() {
        
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [viewController presentViewController:navigationController animated:YES completion:nil];
        
    };
    
    restAlert.rightBlock = ^() {
        // 取消按钮
        
        DLOG(@"取消");
        
    };
    restAlert.dismissBlock = ^() {
        
    };
    [restAlert show];

}


+ (void)goLogin:(UIViewController *)viewController
{
    // 登录过期
    RestUIAlertView *restAlert  = [[RestUIAlertView alloc] initWithTitle:@"登录提示" content:@"请先登录！"];
    
    restAlert.leftBlock = ^() {
        
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [viewController presentViewController:navigationController animated:YES completion:nil];
        
    };
    
    restAlert.rightBlock = ^() {
        // 取消按钮
        
        DLOG(@"取消");
        
    };
    restAlert.dismissBlock = ^() {
        
    };
    [restAlert show];
    
}
@end

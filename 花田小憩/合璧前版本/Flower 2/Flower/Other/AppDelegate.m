//
//  AppDelegate.m
//  Flower
//
//  Created by HUN on 16/7/7.
//  Copyright © 2016年 hundred Company. All rights reserved.
//  /Users/huanghuiqun/Desktop/Flower/Flower/Other/PrefixHeader.pch

#import "AppDelegate.h"
#import "BeginViewController.h"

@interface AppDelegate ()



@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//#if 0
    //设置状态栏,必须先设置plist
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    //设置判断的参数
    //这个开始设置没有登陆
    self.isLogin = NO;
    //起始使用
    RootViewController *rootVC = [RootViewController new];
//    BaseNavigationViewController *navi = [[BaseNavigationViewController alloc]initWithRootViewController:rootVC];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MySetUser])
    {
        BeginViewController *vc = [[BeginViewController alloc]init];
        [vc _initWithImageWithFrame:(CGRect){0,0,k_width,k_height}];
        __weak BeginViewController *tmpVc=vc;
        self.window.rootViewController  = vc;
        vc.MyBtn=^{
            [UIView animateWithDuration:0.75 animations:^{
                tmpVc.view.alpha=0.3;
            } completion:^(BOOL finished) {
                self.window.rootViewController = rootVC;
                [[NSUserDefaults standardUserDefaults] setObject:@"asdsa" forKey:MySetUser];
            }];
        };
    }else
    {
        self.window.rootViewController = rootVC ;
    }
    [self.window makeKeyAndVisible];
//#endif
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

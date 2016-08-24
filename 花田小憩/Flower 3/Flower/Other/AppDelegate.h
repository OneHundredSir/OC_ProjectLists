//
//  AppDelegate.h
//  Flower
//
//  Created by HUN on 16/7/7.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//状态是否登陆
@property(nonatomic,assign)BOOL isLogin;

//是否第一次打开APP
@property(nonatomic,assign)BOOL isFirstTimeOpen;

@end


//
//  AppDelegate.h
//  xiaorizi
//
//  Created by HUN on 16/6/1.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,strong)WHDSeletedcities *seletedController;

@property(nonatomic,assign)BOOL isOn;

//判断有没有实现登陆，没有就在这里实现
+(void)showRegisterView:(UIViewController *)vc;
@end


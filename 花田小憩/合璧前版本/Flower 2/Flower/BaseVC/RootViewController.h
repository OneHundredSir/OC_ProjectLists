//
//  RootViewController.h
//  Flower
//
//  Created by HUN on 16/7/7.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "BaseViewController.h"

@interface RootViewController : UIViewController

//暴露出去根视图的tabbar
@property(nonatomic,strong)BaseTabBarViewController *tabarVc;

//记录登陆返回的状态
@property(nonatomic,assign)BOOL isBackFromLogin;

@end

//
//  NavigationController.m
//  博天下平台
//
//  Created by 周利强 on 15/8/10.
//  Copyright (c) 2015年 周利强. All rights reserved.
//

#import "NavigationController.h"

@interface UIBarButtonItem (ajax)
+ (UIBarButtonItem *)itemWithImage:(NSString *)image higlightedImage:(NSString *)higlightedImage target:(id)target action:(SEL)action;
@end
@implementation UIBarButtonItem (ajax)

+ (UIBarButtonItem *)itemWithImage:(NSString *)image higlightedImage:(NSString *)higlightedImage target:(id)target action:(SEL)action
{
    // 1.创建按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 2.设置按钮背景图片
    UIImage *normal = [UIImage imageNamed:image];
    [btn setImage:normal forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:higlightedImage] forState:UIControlStateHighlighted];
    
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    // 3.设置按钮的尺寸
    btn.bounds = CGRectMake(0, 0, normal.size.width, 2*normal.size.height);
    // 4.监听按钮点击
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    //    btn.backgroundColor = [UIColor greenColor];
    // 5.返回创建好的item
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
@end
@interface NavigationController ()

@end

@implementation NavigationController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
 
//    [self setToolbarHidden:NO animated:YES];
//    NSLog(@"%@",self.view.subviews);
//    NSLog(@"%@",self.navigationBar.subviews);
//     NSLog(@"%@",self.navigationItem);
}

/**
 *  系统在第一次使用这个类的时候调用(1个类只会调用一次)
 */
+ (void)initialize
{
    // 1.设置导航栏主题
    UINavigationBar *navBar = [UINavigationBar appearance];
    navBar.barStyle = UIBarStyleDefault;
    [navBar setBarTintColor:KColor];
    navBar.translucent = NO;
    
    [navBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
     navBar.shadowImage = [[UIImage alloc] init];
//    navBar.barTintColor = [UIColor colorWithRed:0.7 green:0.4 blue:0.4 alpha:0.1];
    // 设置背景图片
//    NSString *bgName = nil;
//    if (iOS7) { // 至少是iOS 7.0
//        bgName = @"NavBar64";
        navBar.tintColor = [UIColor whiteColor];
//    } else { // 非iOS7
//        bgName = @"NavBar";
//    }
//    [navBar setBackgroundImage:[UIImage imageNamed:bgName] forBarMetrics:UIBarMetricsDefault];
    
    // 设置标题文字颜色
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:16];
//    [navBar setTitleTextAttributes:attrs];
    
    // 2.设置BarButtonItem的主题
//    UIBarButtonItem *item = [UIBarButtonItem appearance];
    // 设置文字颜色
//    NSMutableDictionary *itemAttrs = [NSMutableDictionary dictionary];
//    itemAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    itemAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:14];
//    [item setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
    
//    if (!iOS7) {
//        // 设置按钮背景
//        [item setBackgroundImage:[UIImage imageNamed:@"NavButton"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//        [item setBackgroundImage:[UIImage imageNamed:@"NavButtonPressed"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
//        
//        // 设置返回按钮背景
//        [item setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//        [item setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
//    }
}

/**
 *  重写这个方法,能拦截所有的push操作
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count != 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        //设置导航栏返回为空
        UIBarButtonItem *backButtonItem = [UIBarButtonItem itemWithImage:@"nav_back" higlightedImage:@"nav_back" target:self action:@selector(back)];
        viewController.navigationItem.leftBarButtonItem = backButtonItem;
    }
   
    [super pushViewController:viewController animated:animated];
}
- (void)back
{
    [self popViewControllerAnimated:YES];
}

@end

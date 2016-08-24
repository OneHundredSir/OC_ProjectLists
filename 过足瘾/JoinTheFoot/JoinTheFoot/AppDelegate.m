//
//  AppDelegate.m
//  JoinTheFoot
//
//  Created by skd on 16/6/27.
//  Copyright © 2016年 lzm. All rights reserved.
//

#import "AppDelegate.h"

#import "PageViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
//   判断当前应用是否是第一次启动，来加载引导页
    if (![[NSUserDefaults standardUserDefaults] objectForKey:FIRST]) {
//        加载引导页
        [self loadPageVC];
    }

    
    
    
    
    return YES;
}

- (void)loadPageVC
{
    PageViewController *page = [[PageViewController alloc]init];
    
    __block PageViewController *tem = page;
//    先记录当前的rootviewController
    WDRootViewController *root = ( WDRootViewController *)self.window.rootViewController;
    
    page.hinddenPage = ^(void){
    
        [UIView animateWithDuration:0.35 animations:^{
            tem.view.alpha = 0.5;
        } completion:^(BOOL finished) {
            
            self.window.rootViewController = root;
            
            [[NSUserDefaults standardUserDefaults] setObject:@"记得你来过" forKey:FIRST];
        }];
        
    };
    [self.window setRootViewController:page];


}


- (void)applicationWillResignActive:(UIApplication *)application {

    
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

    
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

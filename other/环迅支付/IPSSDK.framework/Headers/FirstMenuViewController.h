//
//  FirstMenuViewController.h
//  CapitalManagementPlatform
//
//  Created by push pull on 15-2-11.
//  Copyright (c) 2015年 zhangxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyConnection.h"
#import "AppDelegate.h"

@interface FirstMenuViewController : UIViewController<UINavigationBarDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    MyConnection *jsonConnection;
    NSURLConnection *con;
    NSString * merbillo1;
    NSString * merbillo2;
    
    UIViewController * clientVC;
}

@property (nonatomic, assign) UIViewController *controller;
//+(void)getn:(NSString *)str ViewController:(UIViewController *)viewController1;

@end

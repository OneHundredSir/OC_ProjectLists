//
//  BeginViewController.h
//  FootLove
//
//  Created by HUN on 16/6/27.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeginViewController : UIViewController

@property(nonatomic,copy)void (^MyBtn)(void);

//设置轮播，给一个尺寸
-(void)_initWithImageWithFrame:(CGRect)rect;

@end

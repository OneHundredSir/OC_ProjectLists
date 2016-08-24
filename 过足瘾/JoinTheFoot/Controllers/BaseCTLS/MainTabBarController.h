//
//  MainTabBarController.h
//  JoinTheFoot
//
//  Created by skd on 16/6/27.
//  Copyright © 2016年 lzm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTabBarController : UITabBarController

@property (nonatomic , weak) UIPanGestureRecognizer *pan;


- (void)panAction:(UIPanGestureRecognizer *)pan;

@end

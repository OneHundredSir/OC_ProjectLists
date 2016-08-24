//
//  MenuView.h
//  Flower
//
//  Created by HUN on 16/7/9.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuView : UIView

@property(nonatomic,copy)void (^btnBlock)(UIButton *btn);


-(void)_setScrollViewWithTitleArray:(NSArray<NSString *> *)titleArr;
@end

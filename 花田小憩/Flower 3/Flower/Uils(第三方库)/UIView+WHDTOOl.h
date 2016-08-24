//
//  UIView+WHDTOOl.h
//  Flower
//
//  Created by HUN on 16/7/16.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import <UIKit/UIKit.h>


IB_DESIGNABLE
@interface UIView (WHDTOOl)

@property (nonatomic,strong) IBInspectable UIColor * layerColor;
@property (nonatomic,assign) IBInspectable CGFloat R;
@property (nonatomic,assign) IBInspectable CGFloat layerWidth;

@property(nonatomic,assign)CGFloat X;

@property(nonatomic,assign)CGFloat Y;

@property(nonatomic,assign)CGFloat H;

@property(nonatomic,assign)CGFloat W;


@end

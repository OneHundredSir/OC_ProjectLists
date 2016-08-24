//
//  UIView+WHDTOOl.m
//  Flower
//
//  Created by HUN on 16/7/16.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "UIView+WHDTOOl.h"

@implementation UIView (WHDTOOl)



- (void)setLayerColor:(UIColor *)layerColor
{
    self.layer.borderColor = layerColor.CGColor;
}

- (void)setR:(CGFloat)R
{
    self.layer.cornerRadius =  R;
}

- (void)setLayerWidth:(CGFloat)layerWidth
{
    self.layer.borderWidth = layerWidth;
}




-(void)setX:(CGFloat)X
{
    CGRect rect = self.frame;
    rect.origin.x = X;
    self.frame = rect;
}

-(void)setY:(CGFloat)Y
{
    CGRect rect = self.frame;
    rect.origin.y = Y;
    self.frame = rect;
}

-(void)setW:(CGFloat)W
{
    CGRect rect = self.frame;
    rect.size.width = W;
    self.frame = rect;
}

-(void)setH:(CGFloat)H
{
    CGRect rect = self.frame;
    rect.size.height = H;
    self.frame = rect;
}

@end

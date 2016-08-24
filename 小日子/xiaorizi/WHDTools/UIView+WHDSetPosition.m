//
//  UIView+WHDSetPosition.m
//  xiaorizi
//
//  Created by HUN on 16/6/4.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "UIView+WHDSetPosition.h"

@implementation UIView (WHDSetPosition)

- (void)setXmg_x:(CGFloat)xmg_x
{
    CGRect frame = self.frame;
    frame.origin.x = xmg_x;
    self.frame = frame;
}

- (void)setXmg_y:(CGFloat)xmg_y
{
    CGRect frame = self.frame;
    frame.origin.y = xmg_y;
    self.frame = frame;
}

- (void)setXmg_width:(CGFloat)xmg_width
{
    CGRect frame = self.frame;
    frame.size.width = xmg_width;
    self.frame = frame;
}

- (void)setXmg_height:(CGFloat)xmg_height
{
    CGRect frame = self.frame;
    frame.size.height = xmg_height;
    self.frame = frame;
}

- (CGFloat)xmg_x
{
    return self.frame.origin.x;
}

- (CGFloat)xmg_y
{
    return self.frame.origin.y;
}

- (CGFloat)xmg_width
{
    return self.frame.size.width;
}

- (CGFloat)xmg_height
{
    return self.frame.size.height;
}

- (void)setXmg_centerX:(CGFloat)xmg_centerX
{
    CGPoint center = self.center;
    center.x = xmg_centerX;
    self.center = center;
}

- (void)setXmg_centerY:(CGFloat)xmg_centerY
{
    CGPoint center = self.center;
    center.y = xmg_centerY;
    self.center = center;
}

- (CGFloat)xmg_centerX
{
    return self.center.x;
}

- (CGFloat)xmg_centerY
{
    return self.center.y;
}//}
@end

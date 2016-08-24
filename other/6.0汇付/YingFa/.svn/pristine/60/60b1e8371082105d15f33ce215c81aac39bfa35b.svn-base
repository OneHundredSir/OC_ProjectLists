//
//  SKSTableViewCellExpandedIndicatorView.m
//  SKSTableView
//
//  Created by Sakkaras on 04/01/14.
//  Copyright (c) 2014 Sakkaras. All rights reserved.
//

#import "SKSTableViewCellIndicator.h"

@implementation SKSTableViewCellIndicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

static UIColor *_indicatorColor;

+ (UIColor *)indicatorColor
{
    return _indicatorColor;
}

+ (void)setIndicatorColor:(UIColor *)indicatorColor
{
    _indicatorColor = indicatorColor;
}

//展开列表下的三角形颜色
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(context);
    CGContextMoveToPoint   (context, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGContextAddLineToPoint(context, CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGContextClosePath(context);
    
    CGContextSetFillColorWithColor(context, [[[self class] indicatorColor] CGColor]);
    CGContextFillPath(context);
}


@end

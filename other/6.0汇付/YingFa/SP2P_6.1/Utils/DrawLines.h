//
//  DrawLines.h
//  SP2P_6.1
//
//  Created by Jerry on 14-6-13.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface DrawLines : NSObject

//绘制表格边框
- (void)drawRoundedRectanglePath:(CGRect)rect color:(UIColor *)color Radius:(float)radius lineWidth:(float)linewidth;

//绘制线条
-(void)drawBezierPath:(CGPoint)startpoint lastpoint:(CGPoint)lastpoint color:(UIColor *)color  lineWidth:(float)linewidth;


@end

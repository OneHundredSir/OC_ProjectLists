//
//  UIImage+AJ.m
//  com.higgs.botrip
//
//  Created by 周利强 on 15/10/10.
//  Copyright © 2015年 周利强. All rights reserved.
//

#import "UIImage+AJ.h"

@implementation UIImage (AJ)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    
    // create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

//
//  FilterHTML.h
//  YouMei
//
//  Created by Cindy on 15/8/25.
//  Copyright (c) 2015年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterHTML : NSObject

//去掉 html字符串中所有标签
+ (NSString *)filterHTML:(NSString *)html;

@end

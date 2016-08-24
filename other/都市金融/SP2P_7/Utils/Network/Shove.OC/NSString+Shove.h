//
//  NSString+Shove.h
//  Shove
//
//  Created by 英迈思实验室移动开发部 on 14-8-28.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Shove)

/* 
 * 判断字符串是否为空白的
 */
- (BOOL)isBlank;

/* 
 * 判断字符串是否为空
 */
- (BOOL)isEmpty;

/* 
 * 给字符串md5加密
 */
- (NSString *)md5;

/**
 * 判断字符串是否是email格式
 */
- (BOOL)isEmail;

/**
 * 判断字符串是否是手机号码格式
 */
- (BOOL)isPhone;

@end

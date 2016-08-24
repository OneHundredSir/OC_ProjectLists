//
//  CacheUtil.m
//  SP2P_6.1
//
//  Created by 李小斌 on 14-10-18.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "CacheUtil.h"
#import "NSString+Shove.h"

@implementation CacheUtil


+(NSString *) creatCacheFileName:(NSDictionary *) parameters
{
    NSArray *parameterNames = [parameters allKeys];
    
    NSString *cacheName = @"";
    
    for (int i = 0; i < [parameters count]; i++) {
        NSString *_key = parameterNames[i];
        NSString * _value = parameters[_key];
        
        cacheName = [NSString stringWithFormat:@"%@%@=%@", cacheName, _key, _value];
        if (i < ([parameters count] - 1)) {
            cacheName = [cacheName stringByAppendingString:@"&"];
        }
    }
    
    return [cacheName md5];
}

@end

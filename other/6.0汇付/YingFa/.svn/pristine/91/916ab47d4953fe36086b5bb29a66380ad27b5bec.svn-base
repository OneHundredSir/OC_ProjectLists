//
//  NSString+Date.m
//  SP2P_6.1
//
//  Created by 李小斌 on 14-10-9.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "NSString+Date.h"

@implementation NSString (Date)


+(NSString *)converDate:(NSString *)value withFormat:(NSString *)format
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: [value doubleValue]/1000];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    return [dateFormat stringFromDate: date];
}

@end

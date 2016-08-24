//
//  AJDailyEarningRepayOut.m
//  SP2P_7
//
//  Created by Ajax on 16/1/22.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "AJDailyEarningRepayOut.h"

@implementation AJDailyEarningRepayOut
- (instancetype)initWithDict:(NSDictionary *)dic
{
    if ([super init]) {
//        NSLog(@"%@", [dic JSONString]);
        long Apply_amount = [dic[@"apply_amount"] longValue];
        self.Apply_amount =  [NSString stringWithFormat:@"%ld",Apply_amount ];
        self.Username = [NSString stringWithFormat:@"%@",dic[@"username"]];
        self.Id = [NSString stringWithFormat:@"%@",dic[@"id"]];
//
        NSDate *date = [NSDate dateWithTimeIntervalSince1970: [dic[@"apply_time"][@"time"] doubleValue]/1000];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
        self.Apply_time = [dateFormatter stringFromDate:date];
    }
    return self;
}

@end

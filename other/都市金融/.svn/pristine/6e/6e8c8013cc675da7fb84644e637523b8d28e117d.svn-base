//
//  AJAddCellData.m
//  SP2P_7
//
//  Created by Ajax on 16/1/21.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "AJAddCellData.h"
#import "JSONKit.h"
@implementation AJAddCellData
- (instancetype)initWithDict:(NSDictionary *)dic
{
    if ([super init]) {
//        NSLog(@"%@", [dic JSONString]);
        self.Transfer_amount =  [NSString stringWithFormat:@"%.2f", [dic[@"transfer_amount"] floatValue]];
        self.Type_id = [NSString stringWithFormat:@"%@",dic[@"type_id"]];
        self.Id = [NSString stringWithFormat:@"%@",dic[@"id"]];
        
         NSDate *date = [NSDate dateWithTimeIntervalSince1970: [dic[@"transfer_time"][@"time"] doubleValue]/1000];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
        self.transfer_time = [dateFormatter stringFromDate:date];
//        self.interest = [NSString stringWithFormat:@"%.2f", [dic[@"interest"] floatValue]];
//        self.total_interest = [NSString stringWithFormat:@"%.2f", [dic[@"total_interest"] floatValue]];
//        self.balance = [NSString stringWithFormat:@"%.2f", [dic[@"balance"] floatValue]];
//        self.year_apr = [NSString stringWithFormat:@"%.1f", [dic[@"year_apr"] floatValue]];
//        self.min_invest_amount = [NSString stringWithFormat:@"%.1f", [dic[@"min_invest_amount"] floatValue]];
//        self.isBorrower = [NSString stringWithFormat:@"%@",dic[@"isBorrower"]];
//        NSDictionary *dicInfo = dic[@"dayInterest"];
//        NSLog(@"%@", [dicInfo JSONString]);
//        self.description_ = dicInfo[@"description"];
//        self.transfer_rule = dicInfo[@"transfer_rule"];
//        self.invest_rule = dicInfo[@"invest_rule"];
    }
    return self;
}
@end

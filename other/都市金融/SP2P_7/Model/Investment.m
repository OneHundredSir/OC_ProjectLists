//
//  Investment.m
//  SP2P_7
//
//  Created by 李小斌 on 14-6-18.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "Investment.h"

@implementation Investment
- (instancetype)initWithDict:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.title = [dic objectForKey:@"title"];
        self.borrowId = [dic objectForKey:@"id"];
//        self.imgurl = [NSString stringWithFormat:@"%@",[dic objectForKey:@"bid_image_filename"]];
//        self.levelStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"small_image_filename"]];
        self.progress = [[dic objectForKey:@"loan_schedule"] floatValue];
        self.amount = [[dic objectForKey:@"amount"] floatValue];
        self.rate = [[dic objectForKey:@"apr"] floatValue];
        self.time = [dic objectForKey:@"period"];
//        self.isQuality = [[dic objectForKey:@"is_hot"] boolValue];
        self.unitstr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"period_unit"]];
        self.borrowId = [dic objectForKey:@"id"]; //借款标ID
        self.repayTypeStr = [dic objectForKey:@"repay_name"];
        self.status = dic[@"status"];
        if ([[dic allKeys] containsObject:@"product_id"]) {
            self.product_id = dic[@"product_id"];
        }
    }
    return self;
}
@end

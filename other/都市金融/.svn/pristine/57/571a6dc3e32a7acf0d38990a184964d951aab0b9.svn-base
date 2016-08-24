//
//  AJAccountHeaderData.m
//  SP2P_7
//
//  Created by Ajax on 16/1/21.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "AJAccountHeaderData.h"

@implementation AJAccountHeaderData
- (instancetype)initWithDict:(NSDictionary*)dic
{

    if (self = [super init]) {
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setPositiveFormat:@"###,##0.00;"];
        
        NSString *availableBalance = [NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"balance"] doubleValue]];
        self.availableBalance = [formatter stringFromNumber:@([availableBalance doubleValue])];
        
         NSString *accountAmount = [NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"amount"] doubleValue]];
        self.accountAmount = [formatter stringFromNumber:@([accountAmount doubleValue])];
       
        NSString *sum_income = [NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"sum_income"] doubleValue]];
        self.sum_income = [formatter stringFromNumber:@([sum_income doubleValue])];
        
    }
    return self;
}
@end

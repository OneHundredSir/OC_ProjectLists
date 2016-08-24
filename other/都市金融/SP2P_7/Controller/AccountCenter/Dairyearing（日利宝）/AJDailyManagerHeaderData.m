//
//  AJDailyManagerHeaderData.m
//  SP2P_7
//
//  Created by Ajax on 16/1/21.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "AJDailyManagerHeaderData.h"
//#import "JSONKit.h"

@implementation AJDailyManagerHeaderData
- (instancetype)initWithDict:(NSDictionary *)dic
{
    if ([super init]) {
//        NSLog(@"%@", [dic JSONString]);
        
        self.interest = [self formatString:dic[@"interest"]];
        self.total_interest =  [self formatString:dic[@"total_interest"]];
        self.balance = [self formatString:dic[@"balance"]];
        self.usablebalance = [self formatString:dic[@"usablebalance"]];
        self.year_apr = [NSString stringWithFormat:@"%.1f", [dic[@"dayInterest"][@"year_apr"] doubleValue]];
        self.min_invest_amount = [self formatString:dic[@"dayInterest"][@"min_invest_amount"]];
        self.isBorrower = [NSString stringWithFormat:@"%d",[dic[@"isBorrower"] boolValue]];
        NSDictionary *dicInfo = dic[@"dayInterest"];
//         NSLog(@"%@", [dicInfo JSONString]);
        self.description_ = [self filterHTML:dicInfo[@"description"]];
        self.transfer_rule = [self filterHTML:dicInfo[@"transfer_rule"]];
        self.invest_rule = [self filterHTML:dicInfo[@"invest_rule"]];
    }
    return self;
}

- (NSString *)formatString:(id)Value
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"###,##0.00;"];
    NSString *Text =  [NSString stringWithFormat:@"%.2f",[Value doubleValue]];
    
    return  [formatter stringFromNumber:@([Text doubleValue])];
}

// *******  去掉 html字符串中所有标签  **********
- (NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    
    NSString * text = nil;
    
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    
    html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    
    return html;
}

@end

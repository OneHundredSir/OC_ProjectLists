//
//  UserInfo.m
//  SP2P_7
//
//  Created by kiu on 14-9-24.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
- (instancetype)initWithDict:(NSDictionary*)obj
{
    if (self = [super init]) {
        if([[obj objectForKey:@"creditRating"] hasPrefix:@"http"])
        {
            self.userCreditRating = [obj objectForKey:@"creditRating"];
            
        }else{
            self.userCreditRating =  [NSString stringWithFormat:@"%@%@", Baseurl, [obj objectForKey:@"creditRating"]];
        }
        self.userName = [obj objectForKey:@"username"];
        if ([[obj objectForKey:@"headImg"] hasPrefix:@"http"]) {
            
            self.userImg = [NSString stringWithFormat:@"%@", [obj objectForKey:@"headImg"]];
        }else{
            
            self.userImg = [NSString stringWithFormat:@"%@%@", Baseurl, [obj objectForKey:@"headImg"]];
            
        }
        self.userLimit = [obj objectForKey:@"creditLimit"];
        self.isVipStatus = [obj objectForKey:@"vipStatus"];
        self.userId = [obj objectForKey:@"id"];
        self.isLogin = @"1";
        self.accountAmount = [NSString stringWithFormat:@"%.2f", [[obj objectForKey:@"accountAmount"] floatValue]];
        self.availableBalance = [NSString stringWithFormat:@"%.2f", [[obj objectForKey:@"availableBalance"] floatValue]];
        self.isEmailStatus = [[obj objectForKey:@"hasEmail"] boolValue];
        self.isMobileStatus = [[obj objectForKey:@"hasMobile"] boolValue];
        self.ipsAcctNo = obj[@"ipsAcctNo"];
        self.businessLicense = obj[@"businessLicense"];
    }
    return self;
}
- (void)setIpsAcctNo:(NSString *)ipsAcctNo
{
    if ([ipsAcctNo isKindOfClass:[NSString class]]) {
        
        _ipsAcctNo = [ipsAcctNo copy];
    }
}
- (void)setBusinessLicense:(NSString *)businessLicense
{
    if ([businessLicense isKindOfClass:[NSString class]]) {
        
        _businessLicense = [businessLicense copy];
    }
}
@end

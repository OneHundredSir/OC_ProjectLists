//
//  CreditorTransfer.m
//  SP2P_7
//
//  Created by 李小斌 on 14-6-18.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "CreditorTransfer.h"

@implementation CreditorTransfer
- (instancetype)initWithDict:(NSDictionary *)item
{
    if (self = [super init]) {
        self.title = [item objectForKey:@"title"];
        self.apr = [item objectForKey:@"apr"];
        
        if([item objectForKey:@"end_time"]  != nil && ![[item objectForKey:@"end_time"]  isEqual:[NSNull null]]){
            //剩余时间
            NSDate *date = [NSDate dateWithTimeIntervalSince1970: [[[item objectForKey:@"end_time"] objectForKey:@"time"] doubleValue]/1000];
            self.leftDate = date;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
            NSDate *senddate=[NSDate date];
            //结束时间
            NSDate *endDate = date;
            //当前时间
            NSDate *senderDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:senddate]];
            //得到相差秒数
            NSTimeInterval time=[endDate timeIntervalSinceDate:senderDate];
            int days = ((int)time)/(3600*24);
            int hours = ((int)time)%(3600*24)/3600;
            int minute = ((int)time)%(3600*24)%3600/60;
            //                int seconds = ((int)time)%(3600*24)%3600%60;
            //            DLOG(@"相差时间 天:%i 时:%i 分:%i",days,hours,minute);
            self.time = [NSString stringWithFormat:@"%d天%d时%d分",days,hours,minute];
            if (days > 0){
                //                    self.time = [[NSString alloc] initWithFormat:@"%i",days];
                //                    self.sortTime = (int)time;
                //                    self.units =@"天";
            }else  if (hours > 0){
                
                //                    self.time = [[NSString alloc] initWithFormat:@"%i",hours];
                //                    self.sortTime = (int)time;
                //                    self.units =@"时";
                
            }else if (minute > 0){
                //                    self.time = [[NSString alloc] initWithFormat:@"%i",minute];
                //                    self.sortTime = (int)time;
                //                    self.units =@"分";
            }
            else if (minute <= 0)
            {
                self.time = [[NSString alloc] initWithFormat:@"%i",0];
                self.sortTime = (int)time;
                self.units =@"秒";
                
            }
            
        }
        //还款时间
        if ([item objectForKey:@"repayment_time"]  != nil && ![[item objectForKey:@"repayment_time"]  isEqual:[NSNull null]]) {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970: [[[item objectForKey:@"repayment_time"] objectForKey:@"time"] doubleValue]/1000];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            dateFormat.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
            NSDate *senddate=[NSDate date];
            //结束时间
            NSDate *endDate =  [dateFormat dateFromString:[dateFormat stringFromDate:date]];
            //当前时间
            NSDate *senderDate = [dateFormat dateFromString:[dateFormat stringFromDate:senddate]];
            //得到相差秒数
            self.repaytime = (int)[endDate timeIntervalSinceDate:senderDate];
        }else{
            
            self.repaytime = 0;
        }
        self.creditorId = [[item objectForKey:@"id"] intValue];
        self.content = [item objectForKey:@"transfer_reason"];
        self.principal = [[item objectForKey:@"debt_amount"] floatValue];
        self.minPrincipal = [[item objectForKey:@"transfer_price"] floatValue];
        self.currentPrincipal = [[item objectForKey:@"max_price"] floatValue];
        self.isQuality = [[item objectForKey:@"is_quality_debt"] boolValue];
        self.joinNumStr = [NSString stringWithFormat:@"%@",[item objectForKey:@"join_times"]];
        self.status = [[item objectForKey:@"status"] integerValue];
        //             self.isQuality = YES;

    }
    return self;
}
@end

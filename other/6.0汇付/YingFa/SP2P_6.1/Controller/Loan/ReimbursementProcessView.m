//
//  ReimbursementProcessView.m
//  SP2P_6.1
//
//  Created by Jerry on 14-7-3.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//还款方式 
#import "ReimbursementProcessView.h"
#import "ColorTools.h"
@implementation ReimbursementProcessView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *dataArr1 = @[@"1.登陆我的账户", @"2.充值", @"3.查看借款账单",@"4.点击账单还款",@"5.系统扣款成功",@"6.成功还款"];
        
         NSArray *dataArr2 = @[@"1.安装APP", @"2.充值", @"3.查看借款账单",@"4.点击账单还款",@"5.系统扣款成功",@"6.成功还款"];

        self.frame = CGRectMake(0, 0, 1000, 150);
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel  *textlabel1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 260, 30)];
        textlabel1.textColor = [UIColor lightGrayColor];
        textlabel1.numberOfLines = 0;
        textlabel1.lineBreakMode = NSLineBreakByCharWrapping;
        textlabel1.font = [UIFont systemFontOfSize:12.0f];
        textlabel1.text = @"电脑上还款:";
        [self addSubview:textlabel1];
        
        UILabel  *textlabel2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 65, 260, 30)];
        textlabel2.textColor = [UIColor lightGrayColor];
        textlabel2.numberOfLines = 0;
        textlabel2.lineBreakMode = NSLineBreakByCharWrapping;
        textlabel2.font = [UIFont systemFontOfSize:12.0f];
        textlabel2.text = @"手机上还款:";
        [self addSubview:textlabel2];
        
        
        
        int j=0,k=3;
        for (int i = 0; i < [dataArr1 count]; i++) {
            
            UILabel *dataLabel11 = [[UILabel alloc] init];
            UILabel *dataLabel22 = [[UILabel alloc] init];
            if (i<3) {
                dataLabel11.frame = CGRectMake(5+i*90, 20, 100, 30);
                dataLabel22.frame = CGRectMake(0+i*90, 85, 100, 30);
                j++;
            }
            else
            {
                dataLabel11.frame = CGRectMake(210+(k-3)*110, 42, 105, 30);
                dataLabel22.frame = CGRectMake(210+(k-3)*110, 105, 105, 30);
                k--;
            }
            
            dataLabel11.font = [UIFont systemFontOfSize:12.0f];
            dataLabel11.text = [dataArr1 objectAtIndex:i];
            dataLabel11.textAlignment = NSTextAlignmentCenter;
            dataLabel22.font = [UIFont systemFontOfSize:12.0f];
            dataLabel22.text = [dataArr2 objectAtIndex:i];
            dataLabel22.textAlignment = NSTextAlignmentCenter;
            [self addSubview:dataLabel22];
            [self addSubview:dataLabel11];
        }
        
        
        for (int i = 0; i<2;i++) {
            
           
            UILabel *arrowlabel1 = [[UILabel alloc] init];
            UILabel *arrowlabel2 = [[UILabel alloc] init];
            UILabel *arrowlabel3 = [[UILabel alloc] init];
            UILabel *arrowlabel4 = [[UILabel alloc] init];
            UILabel *arrowlabel5 = [[UILabel alloc] init];
            UILabel *arrowlabel6 = [[UILabel alloc] init];
            
            
            if (i==0) {
                arrowlabel1.frame = CGRectMake(88, 30, 50, 10);
                arrowlabel2.frame = CGRectMake(152, 30, 50, 10);
                arrowlabel3.frame = CGRectMake(262, 32, 50, 10);
                arrowlabel4.frame = CGRectMake(266.8, 33, 50, 15);
                arrowlabel5.frame = CGRectMake(68, 52, 50, 10);
                arrowlabel6.frame = CGRectMake(182, 52, 50, 10);
            }
            else
            {
            
                arrowlabel1.frame = CGRectMake(78, 95, 50, 10);
                arrowlabel2.frame = CGRectMake(152, 95, 50, 10);
                arrowlabel3.frame = CGRectMake(262, 97, 50, 10);
                arrowlabel4.frame = CGRectMake(266.8, 98, 50, 15);
                arrowlabel5.frame = CGRectMake(68, 115, 50, 10);
                arrowlabel6.frame = CGRectMake(182, 115, 50, 10);
            
            
            }
            arrowlabel1.textAlignment = NSTextAlignmentCenter;
            arrowlabel1.text = @"→";
            arrowlabel1.font = [UIFont boldSystemFontOfSize:15.0f];
            arrowlabel1.textColor = GreenColor;
            [self addSubview:arrowlabel1];
            
            
            arrowlabel2.textAlignment = NSTextAlignmentCenter;
            arrowlabel2.text = @"→";
            arrowlabel2.font = [UIFont boldSystemFontOfSize:15.0f];
            arrowlabel2.textColor = GreenColor;
            [self addSubview:arrowlabel2];
            
           
            arrowlabel3.textAlignment = NSTextAlignmentCenter;
            arrowlabel3.text = @"￢";
            arrowlabel3.font = [UIFont boldSystemFontOfSize:15.0f];
            arrowlabel3.textColor = GreenColor;
            [self addSubview:arrowlabel3];
            
           
            arrowlabel4.textAlignment = NSTextAlignmentCenter;
            arrowlabel4.text = @"↓";
            arrowlabel4.font = [UIFont boldSystemFontOfSize:16.0f];
            arrowlabel4.textColor = GreenColor;
            [self addSubview:arrowlabel4];
            
            
            
            arrowlabel5.textAlignment = NSTextAlignmentCenter;
            arrowlabel5.text = @"←";
            arrowlabel5.font = [UIFont boldSystemFontOfSize:15.0f];
            arrowlabel5.textColor = GreenColor;
            [self addSubview:arrowlabel5];
            
            
            arrowlabel6.textAlignment = NSTextAlignmentCenter;
            arrowlabel6.text = @"←";
            arrowlabel6.font = [UIFont boldSystemFontOfSize:15.0f];
            arrowlabel6.textColor = GreenColor;
            [self addSubview:arrowlabel6];
        }
        
      
    }
    return self;
}

@end

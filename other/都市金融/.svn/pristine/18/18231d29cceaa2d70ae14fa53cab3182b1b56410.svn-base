//
//  FilterHTML.m
//  YouMei
//
//  Created by Cindy on 15/8/25.
//  Copyright (c) 2015年 EIMS. All rights reserved.
//

#import "FilterHTML.h"

@implementation FilterHTML


+ (NSString *)filterHTML:(NSString *)html
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

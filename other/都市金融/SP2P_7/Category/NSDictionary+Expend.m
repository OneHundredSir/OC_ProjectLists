//
//  NSDictionary+Format.m
//  SP2P
//
//  Created by lirifu_p2p on 15-5-25.
//  Copyright (c) 2015年  All rights reserved.
//

#import "NSDictionary+Expend.h"

@implementation NSDictionary (Expend)

- (NSString*)strForKey:(NSString *)key{
    NSString *text = [NSString stringWithFormat:@"%@", [self objectForKey:key]];
    if ([text isEqualToString:@"<null>"]) {
        return @"--";
    }
    return text;
}

- (Boolean*) isNullForKey:(NSString *)key{
    NSString *text = [NSString stringWithFormat:@"%@", [self objectForKey:key]];
    NSCharacterSet *characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    text = [text stringByTrimmingCharactersInSet:characterSet]; //去空格和换行
    if ([text isEqualToString:@"<null>"] || [text isEqualToString:@""]) {
        return true;
    }
    return false;
}

- (Boolean *) errorIsOk{
    return [self intForKey:@"error"] == -1;
}

- (NSInteger)intForKey:(NSString *)key{
    return  [[self objectForKey:key] intValue];
}

- (NSString *)strForKey:(NSString *)key formatEnd:(NSString *)format{
    return [NSString stringWithFormat:@"%@%@", [self objectForKey:key], format];
}

-(NSString *)strForKey:(NSString *)key formatStart:(NSString *)format{
    return [NSString stringWithFormat:@"%@%@",format, [self objectForKey:key]];
}

@end

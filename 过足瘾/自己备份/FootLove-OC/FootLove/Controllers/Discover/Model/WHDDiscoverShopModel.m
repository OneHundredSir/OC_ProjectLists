//
//  WHDDiscoverShopModel.m
//  FootLove
//
//  Created by HUN on 16/7/5.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDDiscoverShopModel.h"

@implementation WHDDiscoverShopModel
- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end

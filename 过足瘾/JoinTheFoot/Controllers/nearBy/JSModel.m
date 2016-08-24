//
//  JSModel.m
//  JoinTheFoot
//
//  Created by skd on 16/6/27.
//  Copyright © 2016年 lzm. All rights reserved.
//

#import "JSModel.h"

@implementation JSModel
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

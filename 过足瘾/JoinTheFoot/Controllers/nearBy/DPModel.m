//
//  DPModel.m
//  JoinTheFoot
//
//  Created by skd on 16/6/28.
//  Copyright © 2016年 lzm. All rights reserved.
//

#import "DPModel.h"

@implementation DPModel

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

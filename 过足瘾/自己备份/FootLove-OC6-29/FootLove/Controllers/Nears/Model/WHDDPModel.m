//
//  WHDDPModel.m
//  FootLove
//
//  Created by HUN on 16/6/28.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDDPModel.h"

@implementation WHDDPModel

//根据字典设置
+(instancetype)setModelValuesWithDictionary:(NSDictionary *)dic
{
    WHDDPModel *model = [WHDDPModel new];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}


-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //设置就好，不需要动
}

@end

//
//  ShopDetailSkillModel.m
//  FootLove
//
//  Created by HUN on 16/6/29.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "ShopDetailSkillModel.h"

@implementation ShopDetailSkillModel
+(instancetype)shopSetWithDictionary:(NSDictionary *)dic
{
    ShopDetailSkillModel *shop =[ShopDetailSkillModel new];
    [shop setValuesForKeysWithDictionary:dic];
    return shop;
}

-(void)shopSetWithDictionary:(NSDictionary *)dic
{
    [self setValuesForKeysWithDictionary:dic];
}

//只设置就好了
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end

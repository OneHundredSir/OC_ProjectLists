//
//  ShopDetailModel.m
//  FootLove
//
//  Created by HUN on 16/6/29.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "ShopDetailJSModel.h"

@implementation ShopDetailJSModel

+(instancetype)shopSetWithDictionary:(NSDictionary *)dic
{
    ShopDetailJSModel *shop =[ShopDetailJSModel new];
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

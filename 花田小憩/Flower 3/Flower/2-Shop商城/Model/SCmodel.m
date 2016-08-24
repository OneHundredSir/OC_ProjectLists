//
//  SCmodel.m
//  Flower
//
//  Created by maShaiLi on 16/7/12.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "SCmodel.h"

@implementation SCmodel


+ (NSDictionary *)objectClassInArray{
    return @{@"childrenList" : [Childrenlist class]};
}
@end
@implementation Childrenlist

@end


@implementation Pgoods

+ (NSDictionary *)objectClassInArray{
    return @{@"skuList" : [Skulist class], @"specList" : [Speclist class]};
}

@end


@implementation Skulist

@end


@implementation Speclist

@end


@implementation Sku

@end



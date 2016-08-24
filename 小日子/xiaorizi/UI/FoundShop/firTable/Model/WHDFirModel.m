//
//  WHDFirModel.m
//  xiaorizi
//
//  Created by HUN on 16/6/1.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDFirModel.h"

@implementation WHDFirModel

+ (NSDictionary *)objectClassInArray{
    return @{@"events" : [Events class], @"themes" : [Themes class]};
}

@end


@implementation Events

+ (NSDictionary *)objectClassInArray{
    return @{@"allshops" : [shops class], @"more" : [More class]};
}

@end


@implementation Cats

@end


@implementation Sponsor

@end


@implementation Price

@end


@implementation shops

@end


@implementation More

@end


@implementation Price1

@end


@implementation Themes

@end



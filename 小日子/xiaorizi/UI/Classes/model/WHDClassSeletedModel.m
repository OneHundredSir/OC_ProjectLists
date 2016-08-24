//
//  WHDClassSeletedModel.m
//  xiaorizi
//
//  Created by HUN on 16/6/6.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDClassSeletedModel.h"

@implementation WHDClassSeletedModel
+(instancetype)makeUpModel:(NSDictionary *)dic
{
    WHDClassSeletedModel *model=[WHDClassSeletedModel new];
    
    model.title=dic[@"title"];
    model.detail=dic[@"address"];
    model.imgStr=[dic[@"imgs"] firstObject];
    model.urlStr=dic[@"shareURL"];
    
    return model;
}

@end



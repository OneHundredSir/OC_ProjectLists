//
//  JXmodel.h
//  Flower
//
//  Created by maShaiLi on 16/7/12.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXmodel : NSObject


@property (nonatomic,strong) id fnId;//每个AtabCell的id

@property (nonatomic,strong) id fnAttachment;

@property (nonatomic,strong) id fnName;//title

@property (nonatomic,strong) id fnEnName;//英文title

@property (nonatomic,strong) id fnMarketPrice;//价格

@property (nonatomic,strong) id fnJian;//1表示推荐 2表示最热

- (instancetype)initWithDict:(NSDictionary *)dict;


@end

//
//  WHDDiscoverShopModel.h
//  FootLove
//
//  Created by HUN on 16/7/5.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WHDDiscoverShopModel : NSObject

@property (nonatomic , strong) id count;
@property (nonatomic , strong) id gift_id;
@property (nonatomic , strong) id gift_kind_id;
@property (nonatomic , strong) id gift_name;
@property (nonatomic , strong) id gift_price;
@property (nonatomic , strong) id image_path;
@property (nonatomic , strong) id is_enabled;
@property (nonatomic , strong) id v_money;
@property (nonatomic , strong) id v_real_get;

//详情增加字段
@property (nonatomic , strong) id boss_guid;
@property (nonatomic , strong) id create_time;
@property (nonatomic , strong) id gift_lable;
@property (nonatomic , strong) id url;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end

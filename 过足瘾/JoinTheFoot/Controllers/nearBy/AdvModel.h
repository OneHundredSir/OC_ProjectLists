//
//  AdvModel.h
//  JoinTheFoot
//
//  Created by skd on 16/6/28.
//  Copyright © 2016年 lzm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdvModel : NSObject

@property (nonatomic,strong) id  ad_id;
@property (nonatomic,strong) id  create_time;
@property (nonatomic,strong) id  image_path;
@property (nonatomic,strong) id  latitude;
@property (nonatomic,strong) id  longitude;
@property (nonatomic,strong) id  shop_id;
@property (nonatomic,strong) id  shop_name;

- (instancetype)initWith:(NSDictionary *)dic;
@end

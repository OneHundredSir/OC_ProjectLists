//
//  DPModel.h
//  JoinTheFoot
//
//  Created by skd on 16/6/28.
//  Copyright © 2016年 lzm. All rights reserved.
//

#import <Foundation/Foundation.h>

#define  setProperty(obj) @property (nonatomic , strong) id obj
@interface DPModel : NSObject

setProperty(addr);
setProperty(area_id);
setProperty(cooperate);
setProperty(create_time);
setProperty(distance);
setProperty(door_to_door);
setProperty(geohash);
setProperty(image_path);
setProperty(industry_id);
setProperty(is_checked);

setProperty(is_show);
setProperty(latitude);
setProperty(login_pass);
setProperty(login_user);
setProperty(longitude);
setProperty(per_capita);

setProperty(project_tag);
setProperty(reserve_money);
setProperty(reserve_num);
setProperty(shop_id);
setProperty(shop_name);

setProperty(shop_type);
setProperty(summary);
setProperty(tag);
setProperty(tech_num);
setProperty(tel);
setProperty(update_time);
setProperty(userid);

setProperty(wifi_pass);
setProperty(wifi_ssid);


- (instancetype)initWithDic:(NSDictionary *)dic;
@end

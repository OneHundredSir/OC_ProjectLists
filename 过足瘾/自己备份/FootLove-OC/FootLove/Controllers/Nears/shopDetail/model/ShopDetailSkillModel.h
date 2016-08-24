//
//  ShopDetailSkillModel.h
//  FootLove
//
//  Created by HUN on 16/6/29.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopDetailSkillModel : NSObject
//-----获取技能值--------//
//名称
WHDOringinal(project_name)
//服务时长
WHDOringinal(item_time_len)
//价格
WHDOringinal(sale_price)


+(instancetype)shopSetWithDictionary:(NSDictionary *)dic;
@end

//
//  WHDDPModel.h
//  FootLove
//
//  Created by HUN on 16/6/28.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WHDOringinal(a) \
@property(nonatomic,strong)id a;

@interface WHDDPModel : NSObject
//图片
WHDOringinal(image_path)
//店名
WHDOringinal(shop_name)
//成交数目
WHDOringinal(tech_num)
//电话
WHDOringinal(tel)
//距离
WHDOringinal(distance)

//店铺的id给下一个页面用的
WHDOringinal(shop_id)

+(instancetype)setModelValuesWithDictionary:(NSDictionary *)dic;

@end

//
//  WHDJSModel.h
//  FootLove
//
//  Created by HUN on 16/6/28.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#define WHDOringinal(a) \
@property(nonatomic,strong)id a;

@interface WHDJSModel : NSObject
WHDOringinal(current_state);
//距离
WHDOringinal(distance);
//点赞数目
WHDOringinal(fans_num);
//总V数目
WHDOringinal(v_totle);
//图片地址
WHDOringinal(image_path);
//店铺名称
WHDOringinal(shop_name);
//图片人名称
WHDOringinal(member_name);
//属性
WHDOringinal(skill);

+(instancetype)setModelValuesWithDictionary:(NSDictionary *)dic;

@end

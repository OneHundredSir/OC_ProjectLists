//
//  ShopDetailModel.h
//  FootLove
//
//  Created by HUN on 16/6/29.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopDetailJSModel : NSObject
////-----第一项获取的--------//
//WHDOringinal(shop_name)
//
////描述
//WHDOringinal(summary)
//
//
//
////-----第二项获取的 图片集--------//
////一个图片的数组
//WHDOringinal(detailImgUrls)


//-----第三项获取的 个人的信息集--------//
//店铺名称
WHDOringinal(shop_name)
//技师号
WHDOringinal(work_id)
//图片
WHDOringinal(image_path)
//粉丝数
WHDOringinal(fans_num)
//认证数
WHDOringinal(v_totle)
//个人名称
WHDOringinal(member_name)
//个人特点
WHDOringinal(signature)
//距离
WHDOringinal(distance)


+(instancetype)shopSetWithDictionary:(NSDictionary *)dic;

-(void)shopSetWithDictionary:(NSDictionary *)dic;
@end

//
//  ShoveGeneralRestGateway.h
//  Shove
//
//  Created by 英迈思实验室移动开发部 on 14-8-28.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
// 通用的 REST 类型的网关

#import <Foundation/Foundation.h>

@interface ShoveGeneralRestGateway : NSObject

/**
 * 构建通用网关的请求 url，参数为键值对形式，不分顺序。不需要包含时间戳、签名等参数 ，系统会自动增加。
 *
 * @param urlBase
 *                  地址
 * @param key
 *                  加密的key
 * @param parameters
 *                  参数
 * @return  生成后的网关
 */
+ (NSString *) buildUrl:(NSString *)baseUrl key:(NSString *)key parameters:(NSDictionary *)parameters;

@end

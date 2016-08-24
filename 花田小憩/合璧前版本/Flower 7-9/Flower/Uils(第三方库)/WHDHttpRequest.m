//
//  WHDHttpRequest.m
//  FootLove
//
//  Created by HUN on 16/6/28.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDHttpRequest.h"

@implementation WHDHttpRequest

+(void)ReuqestActionWith:(NSString *)wUrl
                        and:(NSDictionary *)WBodyDic
              andCompletion:(void(^)(NSData * wdata, NSURLResponse * wresponse, NSError * werror))completion
{
    //如果不传值进来，就默认使用这个.
    if (WBodyDic == nil) {
        //        1:准备一个作为接口调用参数的 字典
        NSMutableDictionary *pragram1 = [NSMutableDictionary dictionary];
        //    设置相关参数
        [pragram1 setObject:@1 forKey:@"appid"];
        [pragram1 setObject:@22.535868 forKey:@"latitude"];
        [pragram1 setObject:@113.950943 forKey:@"longitude"];
        [pragram1 setObject:@"BCCFFAAB6A7D79D1E6D1478F2B432B83CD451E2660F067BF" forKey:@"memberdes"];
        WBodyDic = pragram1;
    }
    //设置请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:wUrl]];
    
    //设置访问方式
    request.HTTPMethod = @"POST";
    
    NSString *dicStr = [WHDHttpRequest stringFromDic:WBodyDic];
    //设置请求体
    request.HTTPBody = [dicStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                dispatch_sync(dispatch_get_main_queue(), ^{
                                                    completion(data,response,error);
                                                });
                                                
    }];
    [task resume];
}

+(NSString *)stringFromDic:(NSDictionary *)dic
{
    
    //获取KEY
    NSArray *keys = [dic allKeys];
    NSMutableString *myString = [NSMutableString string];
    //拼接value
    for (NSString *key in keys) {
        [myString appendFormat:@"%@=%@&",key,dic[key]];
    }
    
    return [myString isEqualToString:@""]?nil:[myString substringWithRange:(NSRange){0,myString.length-1}];
}

@end

//
//  WHDHttpRequest.m
//  FootLove
//
//  Created by HUN on 16/6/28.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDHttpRequest.h"

@implementation WHDHttpRequest

+(void)whdReuqestActionWith:(NSString *)wUrl
                        and:(NSDictionary *)WBodyDic
              andCompletion:(void(^)(NSData * wdata, NSURLResponse * wresponse, NSError * werror))completion
{
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

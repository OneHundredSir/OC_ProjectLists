//
//  WDHttpRequest.m
//  JoinTheFoot
//
//  Created by skd on 16/6/27.
//  Copyright © 2016年 lzm. All rights reserved.
//

#import "WDHttpRequest.h"

@implementation WDHttpRequest

+ (void) postWithURL:(NSString *)urlstr
             pragram:(NSDictionary *)pragram
          completion:(void (^) (NSData *  data, NSURLResponse *  response, NSError *  error))completion
{
    
    if (pragram == nil) {
//        1:准备一个作为接口调用参数的 字典
        NSMutableDictionary *pragram1 = [NSMutableDictionary dictionary];
        //    设置相关参数
        [pragram1 setObject:@1 forKey:@"appid"];
        [pragram1 setObject:@22.535868 forKey:@"latitude"];
        [pragram1 setObject:@113.950943 forKey:@"longitude"];
        [pragram1 setObject:@"BCCFFAAB6A7D79D1E6D1478F2B432B83CD451E2660F067BF" forKey:@"memberdes"];
        pragram = pragram1;
    }
    
//    1:解析参数
    NSString *pragmStr = [self dealWithPragram:pragram];
    
    NSData *bodyData = [pragmStr dataUsingEncoding:NSUTF8StringEncoding];
//    2:创建URL 和 request
    NSURL *url = [NSURL URLWithString:urlstr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
//    3:设置相关请求
    
    request.HTTPMethod = @"POST";
    
    request.HTTPBody = bodyData;
    
    [request setValue:[NSString stringWithFormat:@"%ld",bodyData.length] forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
//    4:发起请求
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
//这个方法是 在子线程回调，需要回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            completion (data,  response,  error);
        });
    }];
    
    [dataTask resume];
    
}


+ (NSString *)dealWithPragram:(NSDictionary *)pragram
{

    NSArray *allkeys = [pragram allKeys];
    NSMutableString *result = [NSMutableString string];
    for (NSString *key in allkeys) {
        
        [result appendString:[NSString stringWithFormat:@"%@=%@&",key , pragram[key]]];
    }

  return [result substringWithRange:(NSRange){0,result.length - 1}];
}

@end

//
//  WHDHttpRequest.m
//  FootLove
//
//  Created by HUN on 16/6/28.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDHttpRequest.h"

@implementation WHDHttpRequest

+(void)ReuqestActionWithUrlString:(NSString *)wUrl
                              and:(NSDictionary *)WBodyDic
                    andCompletion:(void(^)(NSData * wdata, NSURLResponse * wresponse, NSError * werror))completion
{
    //设置请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:wUrl]];
    
    //设置访问方式默认使用get
    request.HTTPMethod = @"POST";
    
    NSString *dicStr = [WHDHttpRequest stringFromDic:WBodyDic];
    //    NSLog(@"%@?%@",wUrl,dicStr);
    //设置请求体
    request.HTTPBody = [dicStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    completion(data,response,error);
                                                });
                                                
                                            }];
    [task resume];
    
}


/**
 *  设置类方法有
 *
 *  @param wUrl       网页字符串
 *  @param WBodyDic   请求的字典，会自动转换
 *  @param completion 完成后回到主线程的回调
 */
+(void)ReuqestGetActionWithUrlString:(NSString *)wUrl
                                 and:(NSDictionary *)WBodyDic
                       andCompletion:(void(^)(NSData * wdata, NSURLResponse * wresponse, NSError * werror))completion
{
    
    
    
    NSString *dicStr = [WHDHttpRequest stringFromDic:WBodyDic];
    wUrl = [NSString stringWithFormat:@"%@?%@",wUrl,dicStr];
    //    NSLog(@"%@",wUrl);
    //设置请求
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:wUrl]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    completion(data,response,error);
                                                });
                                                
                                            }];
    [task resume];
}

#pragma mark 获取文章首页
/**
 获取首页的文章列表
 
 - parameter paramters: 参数字典
 - 必传:currentPageIndex,pageSize(当currentPageIndex=0时,该参数无效, 但是必须传)
 - 根据情景传:
 - isVideo	true (是否是获取视频列表)
 - cateId	a56aa5d0-aa6b-42b7-967d-59b77771e6eb(专题的类型, 不传的话是默认)
 - parameter finished:  回传的闭包
 */

+(void)getHomeListWithparamters:(NSDictionary *)paramters andandCompletion:(void(^)(NSData * data, NSURLResponse * response, NSError * error))completion
{
    NSString *wUrl = @"http://m.htxq.net/servlet/SysArticleServlet?action=mainList";
    
    [WHDHttpRequest ReuqestActionWithUrlString:wUrl and:paramters andCompletion:^(NSData *wdata, NSURLResponse *wresponse, NSError *werror) {
        if (completion) {
            completion(wdata,wresponse,werror);
        }
    }];
}

#pragma mark 每周TOP10的获取
// MARK: - 每周TOP10的获取
/**
 获取每周TOP10
 
 - parameter action:   具体获取"专栏"还是"作者"topContents  topArticleAuthor
 - parameter finished: 返回的block
 */
+(void)getTop10Withparamters:(NSDictionary *)paramters andandCompletion:(void(^)(NSData * data, NSURLResponse * response, NSError * error))completion
{
    NSString *wUrl = @"http://ec.htxq.net/servlet/SysArticleServlet?currentPageIndex=0&pageSize=10";
    
    [WHDHttpRequest ReuqestActionWithUrlString:wUrl and:paramters andCompletion:^(NSData *wdata, NSURLResponse *wresponse, NSError *werror) {
        if (completion) {
            completion(wdata,wresponse,werror);
        }
    }];
}

#pragma mark 文章详情
// MARK: - 文章详情
/**
 获取文章详情
 
 - parameter paramters: 参数
 - parameter finished:  返回的闭包
 articleId	76e47313-8e52-459a-aad1-0544bb57b0a9
 userId	c2e81886-b3d0-4dcb-86ee-1a7ece6e28ee
 */

+(void)getArticleDetailWithparamters:(NSDictionary *)paramters andandCompletion:(void(^)(NSData * data, NSURLResponse * response, NSError * error))completion
{
    NSString *wUrl = @"http://m.htxq.net/servlet/SysArticleServlet?action=getArticleDetail";
    
    [WHDHttpRequest ReuqestActionWithUrlString:wUrl and:paramters andCompletion:^(NSData *wdata, NSURLResponse *wresponse, NSError *werror) {
        if (completion) {
            completion(wdata,wresponse,werror);
        }
    }];
}

#pragma mark - 获取用户详情
/**
 获取用户详情
 
 - parameter userID:   用户id
 - parameter finished: 完成之后的回调
 */
+(void)getUserDetailWithuserId:(NSString *)userId andandCompletion:(void(^)(NSData * data, NSURLResponse * response, NSError * error))completion
{
    NSString *wUrl = @"http://m.htxq.net/servlet/UserCustomerServlet";
    NSDictionary *parameters = @{@"action":@"getUserDetail",@"userId":userId};
    [WHDHttpRequest ReuqestGetActionWithUrlString:wUrl and:parameters andCompletion:^(NSData *wdata, NSURLResponse *wresponse, NSError *werror)
     {
         if (completion) {
             completion(wdata,wresponse,werror);
         }
     }];
}

#pragma mark   A 获取用户专栏详情
/**
 A 获取用户专栏详情
 
 - parameter userID:   用户id
 - parameter finished: 完成之后的回调
 */

//http://m.htxq.net/servlet/UserCenterServlet?action=getMyContents&currentPageIndex=0&pageSize=15&userId=4a3dab7f-1168-4a61-930c-f6bc0f989f32&(null)=
+(void)getUserColumnWithparamters:(NSDictionary *)paramters andandCompletion:(void(^)(NSData * data, NSURLResponse * response, NSError * error))completion
{
    NSString *wUrl = @"http://m.htxq.net/servlet/UserCenterServlet?action=getMyContents";
    
    [WHDHttpRequest ReuqestActionWithUrlString:wUrl and:paramters andCompletion:^(NSData *wdata, NSURLResponse *wresponse, NSError *werror) {
        if (completion) {
            completion(wdata,wresponse,werror);
        }
    }];
}


#pragma mark B 获取用户介绍详情
+(void)getUserIntroduceWithuserId:(NSString *)userId andandCompletion:(void(^)(NSData * data, NSURLResponse * response, NSError * error))completion
{
    NSString *wUrl = @"http://m.htxq.net/servlet/UserCustomerServlet";
    
    NSDictionary *parameters = @{@"action":@"getUserDetail",@"userId":userId};
    [WHDHttpRequest ReuqestGetActionWithUrlString:wUrl and:parameters andCompletion:^(NSData *wdata, NSURLResponse *wresponse, NSError *werror)
     {
         if (completion) {
             completion(wdata,wresponse,werror);
         }
     }];
}

#pragma mark 获取用户订阅详情//这是post
/**
 *  获取用户订阅详情
 *
 *  @param paramters
 //action=getMySubscibeAuthor
 //currentPageIndex=0
 //pageSize=15
 //userId=4a3dab7f-1168-4a61-930c-f6bc0f989f32
 *  @param completion 回调成功的值
 */
+(void)getUserBookWithparamters:(NSDictionary *)paramters andandCompletion:(void(^)(NSData * data, NSURLResponse * response, NSError * error))completion
{
    NSString *wUrl = @"http://m.htxq.net/servlet/UserCenterServlet?action=getMySubscibeAuthor";
    
    [WHDHttpRequest ReuqestActionWithUrlString:wUrl and:paramters andCompletion:^(NSData *wdata, NSURLResponse *wresponse, NSError *werror) {
        if (completion) {
            completion(wdata,wresponse,werror);
        }
    }];
}


#pragma mark 字典转成拼接符号
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

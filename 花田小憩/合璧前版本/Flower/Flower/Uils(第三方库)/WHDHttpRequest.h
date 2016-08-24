//
//  WHDHttpRequest.h
//  FootLove
//
//  Created by HUN on 16/6/28.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WHDHttpRequest : NSObject
//默认使用post
+(void)ReuqestActionWithUrlString:(NSString *)wUrl
                              and:(NSDictionary *)WBodyDic
                    andCompletion:(void(^)(NSData * wdata, NSURLResponse * wresponse, NSError * werror))completion;

/**
 *  设置类方法有
 *
 *  @param wUrl       网页字符串
 *  @param WBodyDic   请求的字典，会自动转换
 *  @param completion 完成后回到主线程的回调
 */
+(void)ReuqestGetActionWithUrlString:(NSString *)wUrl
                                 and:(NSDictionary *)WBodyDic
                       andCompletion:(void(^)(NSData * wdata, NSURLResponse * wresponse, NSError * werror))completion;

#pragma mark - 本次项目主要用的
/**
 获取首页的文章列表
 
 - parameter paramters: 参数字典
 - 必传:currentPageIndex,pageSize(当currentPageIndex=0时,该参数无效, 但是必须传)
 - 根据情景传:
 - isVideo	true (是否是获取视频列表)
 - cateId	a56aa5d0-aa6b-42b7-967d-59b77771e6eb(专题的类型, 不传的话是默认)
 - parameter finished:  回传的闭包
 */

+(void)getHomeListWithparamters:(NSDictionary *)paramters andandCompletion:(void(^)(NSData * data, NSURLResponse * response, NSError * error))completion;


#pragma mark 每周TOP10的获取
// MARK: - 每周TOP10的获取
/**
 获取每周TOP10
 
 - parameter action:   具体获取"专栏"还是"作者"
 - parameter finished: 返回的block
 */
+(void)getTop10Withparamters:(NSDictionary *)paramters andandCompletion:(void(^)(NSData * data, NSURLResponse * response, NSError * error))completion;

#pragma mark 文章详情
// MARK: - 文章详情
/**
 获取文章详情
 
 - parameter paramters: 参数
 - parameter finished:  返回的闭包
 */

+(void)getArticleDetailWithparamters:(NSDictionary *)paramters andandCompletion:(void(^)(NSData * data, NSURLResponse * response, NSError * error))completion;

#pragma mark 获取用户详情
/**
 获取用户详情
 
 - parameter userID:   用户id
 - parameter finished: 完成之后的回调
 */
+(void)getUserDetailWithuserId:(NSString *)userId andandCompletion:(void(^)(NSData * data, NSURLResponse * response, NSError * error))completion;

/**
 A 获取用户专栏详情
 
 - parameter userID:   用户id
 - parameter finished: 完成之后的回调
 //http://m.htxq.net/servlet/UserCenterServlet?action=getMyContents&currentPageIndex=0&pageSize=15&userId=4a3dab7f-1168-4a61-930c-f6bc0f989f32&(null)=
 
 */
+(void)getUserColumnWithparamters:(NSDictionary *)paramters andandCompletion:(void(^)(NSData * data, NSURLResponse * response, NSError * error))completion;

/**
 B 获取用户介绍详情
 
 - parameter userID:   用户id
 - parameter finished: 完成之后的回调
 */
+(void)getUserIntroduceWithuserId:(NSString *)userId andandCompletion:(void(^)(NSData * data, NSURLResponse * response, NSError * error))completion;

/**
 C 获取用户订阅详情
 
 - parameter userID:   用户id
 - parameter finished: 完成之后的回调
 */
+(void)getUserBookWithparamters:(NSDictionary *)paramters andandCompletion:(void(^)(NSData * data, NSURLResponse * response, NSError * error))completion;
@end

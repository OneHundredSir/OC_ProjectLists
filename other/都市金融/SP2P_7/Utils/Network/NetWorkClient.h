//
//  NetWorkClient.h
//  Shove
//
//  Created by 李小斌 on 14-9-22.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@protocol HTTPClientDelegate;

@interface NetWorkClient : AFHTTPSessionManager

@property (nonatomic, weak) id<HTTPClientDelegate>delegate;

@property (nonatomic,assign)NSInteger level;
@property (nonatomic, assign) UIViewController *controller;
// 投资专区opt=10——全部标列表  loanType=-1；稳赢宝列表loanType=5；商理宝列表loanType=null；新手专享区列表 loanType=7======20160120
@property (nonatomic, copy) NSString *loanType;
- (instancetype)init;

- (NSURLSessionDataTask *) requestGet:(NSString *)URLString withParameters:(NSDictionary *)parameters;

/**
 *    发送支付操作请求
 *
 *  @param controller ViewController
 *  @param parameters   请求参数
 *  @param type       操作类型
 //1.开户 2.充值 3.投标 4.提现 5.绑定银行卡 6.债权转让竞拍确认（竟价）7.债权转让竞拍确认受让（定向）8.还款
 *  @param level      controller级数 可默认0
 *
 *  @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)requestGet:(UIViewController *)controller withParameters:(NSDictionary *)parameters payType:(NSInteger) type navLevel:(NSInteger)level;
- (NSURLSessionDataTask *)requestParameters:(NSDictionary *)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;
/**
    取消任务
 */
-(void) cancel;

@end

@protocol HTTPClientDelegate <NSObject>

@optional

-(void) startRequest;

-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj;

-(void) httpResponseSuccessWithParam:(NSDictionary *)param dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj;

-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error;

-(void) httpResponseFailureWithParam:(NSDictionary *)param dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error;

-(void) networkError;

@end

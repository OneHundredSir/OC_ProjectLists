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

- (instancetype)init;

- (NSURLSessionDataTask *) requestGet:(NSString *)URLString withParameters:(NSDictionary *)parameters;

/**
    取消任务
 */
-(void) cancel;

@end

@protocol HTTPClientDelegate <NSObject>

@optional

-(void) startRequest;

-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj;

-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error;

-(void) networkError;

@end

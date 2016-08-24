//
//  WDHttpRequest.h
//  JoinTheFoot
//
//  Created by skd on 16/6/27.
//  Copyright © 2016年 lzm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDHttpRequest : NSObject

+ (void) postWithURL:(NSString *)urlstr
             pragram:(NSDictionary *)pragram
          completion:(void (^) (NSData *  data, NSURLResponse *  response, NSError *  error))completion;
@end

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
+(void)whdReuqestActionWith:(NSString *)wUrl
                        and:(NSDictionary *)WBodyDic
                   andCompletion:(void(^)(NSData * wdata, NSURLResponse * wresponse, NSError * werror))completion;
@end

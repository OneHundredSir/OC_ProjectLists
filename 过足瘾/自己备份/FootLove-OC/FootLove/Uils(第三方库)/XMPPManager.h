//
//  XMPPManager.h
//  FootLove
//
//  Created by HUN on 16/7/1.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MessageModel ;
@interface XMPPManager : NSObject

+(instancetype)manager;


-(void)loginWithAccount:(NSString *)jid
               password:(NSString *)password
             completion:(void(^)(BOOL ret))completion;

-(void)registerWithAccount:(NSString *)jid
               password:(NSString *)password
             completion:(void(^)(BOOL ret))completion;


/**
 *  监听好友的方法,在代理接收消息的时候调用block给外部使用
 */
-(void)listeningMessage:(void(^)(MessageModel *messageModel))getMessage;

/**
 *  监听添加好友的方法
 */
-(void)addFriendsMyjid:(NSString *)myjid Tojid:(NSString *)friendjid;


@end

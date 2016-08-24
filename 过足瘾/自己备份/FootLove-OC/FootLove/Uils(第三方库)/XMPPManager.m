//
//  XMPPManager.m
//  FootLove
//
//  Created by HUN on 16/7/1.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "XMPPManager.h"
#import "XMPP.h"
#import "MessageModel.h"

#import "XMPPRoster.h"//存放所有的注册用户，需要数据库
#import "XMPPRosterCoreDataStorage.h"//存放的数据库

@interface XMPPManager ()<XMPPStreamDelegate,XMPPRosterDelegate>

/**
 *  负责和服务器通信的类
 */
@property(nonatomic,strong)XMPPStream *xmppStream;

/**
 *  保存当前密码的一个引用
 */
@property(nonatomic,weak)NSString *currentPassword;

@property(nonatomic,assign)BOOL isLogin;

@property(nonatomic,copy)void (^statusBlock)(BOOL ret);


@property(nonatomic,copy)void(^getMessageBlock)(MessageModel *messageModel);

#pragma mark 加好友部分
@property(nonatomic,strong)XMPPRoster *XMProster;

@end


@implementation XMPPManager

static XMPPManager *xmpp =nil ;

+(instancetype)manager
{
    @synchronized(self) {
    if (xmpp == nil) {
        xmpp = [[XMPPManager alloc]init];
    }
    }
    return xmpp;
}

-(instancetype)init
{
    @synchronized(self) {
        if (xmpp == nil) {
            xmpp = [super init];
        }
    }
    
    return xmpp;
}



#pragma mark - 配置方法
/**
 *  懒加载，设置主机，端口，代理
 */
-(XMPPStream *)xmppStream
{
    if (!_xmppStream) {
        //初始化xmppStream
        _xmppStream = [XMPPStream new];
        //绑定服务器
        [_xmppStream setHostName:@"127.0.0.1"];
        //设置端口
        [_xmppStream setHostPort:5222];
        //设置主机端口代理
        [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
     
        
        //注册花名册，就是内存
        XMPPRosterCoreDataStorage *storage = [XMPPRosterCoreDataStorage new];
        //初始化花名册
        _XMProster = [[XMPPRoster alloc]initWithRosterStorage:storage];
        //设置花名册的代理
        [_XMProster addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        //绑定XMPP
        [_XMProster activate:_xmppStream];
    }
    return _xmppStream;
}

/**
 *  通过Jid账号链接服务器
 */

-(void)connectHostWithJid:(NSString *)jid
{
    //将字符串拼接成自己的
    XMPPJID *myjid =[XMPPJID jidWithString:[NSString stringWithFormat:@"%@%@",jid,XMPPLocation]];
//    讲当前的jid绑定到xmppstream上
    [self.xmppStream setMyJID:myjid];
    
    //判断一下服务器是否连接上
    if ([self.xmppStream isConnected]) {
        //断开连接
        [self.xmppStream disconnect];
    }
    //尝试连接服务器
    [self.xmppStream connectWithTimeout:20 error:nil];
}


/**
 *  上线
 */


-(void)Online
{
    //创建上线节点
    XMPPPresence *presence = [[XMPPPresence alloc]init];//默认就是上线，可以选择unavailable
    
//    发送给服务器上线
    [self.xmppStream sendElement:presence];
    
    NSLog(@"账号上线了");
}
#pragma mark - 功能方法

/**
 *  登陆
 */
-(void)loginWithAccount:(NSString *)jid
               password:(NSString *)password
             completion:(void(^)(BOOL ret))completion
{
    
    _isLogin = YES;
    _statusBlock = completion;
    _currentPassword = password;
    [self connectHostWithJid:jid];
}

/**
 *  注册
 */
-(void)registerWithAccount:(NSString *)jid
                  password:(NSString *)password
                completion:(void(^)(BOOL ret))completion
{
    _isLogin = YES;
    _statusBlock = completion;
    _currentPassword = password;
    [self connectHostWithJid:jid];
}
/**
 *  监听方法，这样可以拿到人家发过来的东西
 */
-(void)listeningMessage:(void(^)(MessageModel *messageModel))getMessage
{
    _getMessageBlock = getMessage;
}
/**
 *  添加好友
 */
-(void)addFriendsMyjid:(NSString *)myjid Tojid:(NSString *)friendjid
{
    [self.XMProster subscribePresenceToUser:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@%@",friendjid,XMPPLocation]]];
}

#pragma mark - 代理方法
-(void)xmppStreamDidConnect:(XMPPStream *)sender
{
    if (_isLogin) {
//        登陆状态就授权密码
        [self.xmppStream authenticateWithPassword:_currentPassword error:nil];
    }else
    {
//        注册状态，注册密码
        [self.xmppStream registerWithPassword:_currentPassword error:nil];
    }
}

//登陆成功(密码授权成功)
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
//    告诉用户登陆成功
    _statusBlock(YES);
    [self Online];
}
//登陆失败(密码授权失败)
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    //    告诉用户登陆失败
    _statusBlock(NO);
}
//注册成功(密码授权成功)
-(void)xmppStreamDidRegister:(XMPPStream *)sender
{
    //    告诉用户注册成功
    _statusBlock(YES);
}
//注册失败(密码授权失败)
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    //    告诉用户注册失败
    _statusBlock(NO);
}

//接受消息（成功收到消息）
-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    NSString *body = [message body];
    
    if (body) {
        NSString *fromJid = [[message from] bare];
        MessageModel *messageModel = [MessageModel new];
        messageModel.fromJid = fromJid;
        messageModel.toJid = [[message to] bare];
        messageModel.content = body;
        messageModel.type = 0;
        //成功收到getmessage之后给监听的方法
        if (_getMessageBlock) {
            _getMessageBlock(messageModel);
        }
    }
    NSLog(@"收到信息了:%@",body);
}


#pragma mark 花名册代理部分
//获取好友请求
-(void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    NSString *fromUser = [[presence from] user];//请求者的jid
    //通过验证
    [self.XMProster acceptPresenceSubscriptionRequestFrom:[XMPPJID jidWithString:fromUser] andAddToRoster:YES];
    
    NSLog(@"%@",fromUser);
    
}

// 添加好友同意后，会进入到此代理
- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterPush:(XMPPIQ *)iq
{
    DDXMLElement *query = [iq elementsForName:@"query"][0];
    DDXMLElement *item = [query elementsForName:@"item"][0];
    
    NSString *subscription = [[item attributeForName:@"subscription"] stringValue];
    NSLog(@"＝同意");
}
//接收到花名册返回的好友信息
-(void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(DDXMLElement *)item
{
    NSLog(@"成功加为好友");
}

@end

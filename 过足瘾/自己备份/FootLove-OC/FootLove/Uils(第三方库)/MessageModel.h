//
//  MessageModel.h
//  FootLove
//
//  Created by HUN on 16/7/1.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger , MessageType) {
    Type_Text = 0,
    Type_Video,
    Type_Image,
    Type__Audio
    
};

@interface MessageModel : NSObject

@property(nonatomic,assign)MessageType type;

WHDOringinal(fromJid);

WHDOringinal(toJid);
//内容
WHDOringinal(content);

//图片信息
WHDOringinal(imageUrl)
//名字信息
WHDOringinal(nameStr)
//最后一条信息
WHDOringinal(lastMessage)
//多少条未读留言
WHDOringinal(totalUnReadCount)

@end

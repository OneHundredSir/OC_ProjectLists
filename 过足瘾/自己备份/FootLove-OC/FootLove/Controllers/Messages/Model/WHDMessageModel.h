//
//  WHDMessageModel.h
//  FootLove
//
//  Created by HUN on 16/7/2.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WHDMessageModel : NSObject
//图片信息
WHDOringinal(imageUrl)
//名字信息
WHDOringinal(nameStr)
//最后一条信息
WHDOringinal(lastMessage)
//多少条未读留言
WHDOringinal(totalUnReadCount)
@end

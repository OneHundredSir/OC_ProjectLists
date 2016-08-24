//
//  WHDDBManager.h
//  FootLove
//
//  Created by HUN on 16/7/4.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"//XCODE7.0以前可以导入sql3.0，以后导入3
#import "MessageModel.h"
@interface WHDDBManager : NSObject

//新建一个单例存储
+(instancetype)manager;

//保存数据
-(void)saveDataWithModel:(MessageModel *)currentModel;

//更新数据
- (void)updateMessageWithModle:(MessageModel *)currentModel;


//获取所有的数据记录
- (NSMutableArray *)getAllMessageRecoder;

//异步获取
- (void) synGetAllMessage:(void(^)(NSMutableArray *messages))getAllMessage;
@end

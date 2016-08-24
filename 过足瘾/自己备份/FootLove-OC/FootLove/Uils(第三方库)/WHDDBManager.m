//
//  WHDDBManager.m
//  FootLove
//
//  Created by HUN on 16/7/4.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDDBManager.h"
#import <FMDB.h>
@interface WHDDBManager ()
@property(nonatomic,strong)FMDatabase *db;

@end
@implementation WHDDBManager

static WHDDBManager *manager =nil;
//设置单例
+(instancetype)manager
{
    @synchronized(self) {
        if (manager == nil) {
            manager = [[WHDDBManager alloc]init];
        }
    }
    return manager;
}

-(instancetype)init
{
    @synchronized(self) {
        if (manager == nil) {
            manager = [ super init];
            
            //        1、拿大炮沙河路径
            NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) firstObject];
            //        2、拼接成数据库路径
            NSString *dbPath = [document stringByAppendingString:@"/message.db"];
            NSLog(@"%@",dbPath);
            //        3、创建一个数据课
            _db = [FMDatabase databaseWithPath:dbPath];
            
            //        4、打开数据库，并且创建表
            if ([_db open]) {
                //            建表
                /*
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
                 */
                BOOL ret = [_db executeQuery:@"create table if not exists MessageRecorder (ID integer primary key autoincrement ,fromJid varchar(128),toJid varchar(128),type varchar(128),body varchar(128 ),image_path varchar(128),name varchar(128),unRead varchar(128))"];
                if (!ret) {
                    NSLog(@"创建表失败");
                }
                [_db close];
            }
            
        }
    }
    return manager;
}
/**
 *  存储数据
 */
-(void)saveDataWithModel:(MessageModel *)currentModel
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([_db open]) {
            
            BOOL ret =[_db executeUpdate:@"insert into MessageRecorder (fromJid,toJid,type,body,image_path,name,unRead) values (?,?,?,?,?,?,?)",currentModel.fromJid,currentModel.toJid,[NSString stringWithFormat:@"%ld",currentModel.type],currentModel.content,currentModel.imageUrl,currentModel.nameStr,[NSString stringWithFormat:@"%@",currentModel.totalUnReadCount]];
            if (!ret) {
                NSLog(@"存储数据失败");
            }
            
            [_db close];
        }
    });
}

/**
 *  更新数据
 */
- (void)updateMessageWithModle:(MessageModel *)currentModel
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([_db open]) {
            
            //        更新数据
            BOOL ret =  [_db executeUpdate:@"update MessageRecorder set (fromJid =?, toJid =?,type =?,body =?,image_path=?,name =?,unRead =?) where fromJid = ?",currentModel.fromJid,currentModel.toJid,[NSString stringWithFormat:@"%ld",currentModel.type],currentModel.content,currentModel.imageUrl,currentModel.nameStr,[NSString stringWithFormat:@"%@",currentModel.totalUnReadCount],currentModel.fromJid];
            if (!ret) {
                NSLog(@"数据更新失败");
            }
            [_db close];
        }
        
    });
}

/**
 *  获取所有的消息记录
 */
- (NSMutableArray *)getAllMessageRecoder
{
    NSMutableArray *result = [@[] mutableCopy];
    if ([_db open]) {
        FMResultSet *set = [_db executeQuery:@"selected * from MessageRecorder"];
        while ([set next]) {
            MessageModel *model = [[MessageModel alloc]init];
            
            //根据字段名称，获取该字段的值
            model.fromJid = [set objectForColumnName:@"fromJid"];
            model.toJid = [set objectForColumnName:@"toJid"];
            model.type = [[set objectForColumnName:@"type"] integerValue];
            model.content = [set objectForColumnName:@"body"];
            model.imageUrl = [set objectForColumnName:@"image_path"];
            model.nameStr = [set objectForColumnName:@"name"];
            model.totalUnReadCount = [set objectForColumnName:@"unRead"];
            [result addObject:model];
        }
        [_db close];
    }
    return result;
}
- (void) synGetAllMessage:(void(^)(NSMutableArray *messages))getAllMessage
{
    
    NSMutableArray *result = [@[] mutableCopy];
    if ([_db open]) {
        FMResultSet *set = [_db executeQuery:@"selected * from MessageRecorder"];
        while ([set next]) {
            MessageModel *model = [[MessageModel alloc]init];
            
            //根据字段名称，获取该字段的值
            model.fromJid = [set objectForColumnName:@"fromJid"];
            model.toJid = [set objectForColumnName:@"toJid"];
            model.type = [[set objectForColumnName:@"type"] integerValue];
            model.content = [set objectForColumnName:@"body"];
            model.imageUrl = [set objectForColumnName:@"image_path"];
            model.nameStr = [set objectForColumnName:@"name"];
            model.totalUnReadCount = [set objectForColumnName:@"unRead"];
            [result addObject:model];
        }
        [_db close];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        getAllMessage(result);//用block传出去，主要给主线程用
    });
}

@end

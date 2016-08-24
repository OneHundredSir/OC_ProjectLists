//
//  WHDShowMyInfo.m
//  xiaorizi
//
//  Created by HUN on 16/6/3.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDShowMyInfo.h"
@interface WHDShowMyInfo()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UILabel *showCathe;
@property(nonatomic,copy)NSString *path;
@end

@implementation WHDShowMyInfo
//公开出去让外面知道怎么搞
+(instancetype)WHDShowTableView
{
   
    WHDShowMyInfo *show=[[UIStoryboard storyboardWithName:@"Main"
                                                  bundle:[NSBundle mainBundle]]
                 instantiateViewControllerWithIdentifier:@"WHDShowMyInfo"];
    return show;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    NSString *path=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    self.path=path;
    self.showCathe.text=[NSString stringWithFormat:@"%.2fM",[WHDShowMyInfo folderSizeAtPath:path]];
    
}

#pragma mark tableView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0://点赞
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.baidu.com/"]];
            break;
        case 1://推荐
            NSLog(@"2----->1");
            break;
        case 2://我们
            NSLog(@"3----->1");
            break;
        case 3://去香蕉论坛
            NSLog(@"4----->1");
            break;
        case 4://关注我的微博
            NSLog(@"5----->1");
            break;
        case 5://清理缓存
            NSLog(@"6----->1");
            [WHDShowMyInfo clearCache:self.path];
            NSLog(@"%@M",[NSString stringWithFormat:@"%.2fM",[WHDShowMyInfo folderSizeAtPath:_path]]);
            self.showCathe.text=[NSString stringWithFormat:@"%.2fM",[WHDShowMyInfo folderSizeAtPath:_path]];
            break;
        default:
            break;
    }
}

#pragma mark 缓存处理
/**
 *  计算单个文件大小
 */
+(float)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}

/**
 *  计算目录大小
 */
+(float)folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize +=[WHDShowMyInfo fileSizeAtPath:absolutePath];
        }
        //SDWebImage框架自身计算缓存的实现
        folderSize+=[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        return folderSize;
    }
    return 0;
}
/**
 *  清楚缓存
 */
+(void)clearCache:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
}

@end

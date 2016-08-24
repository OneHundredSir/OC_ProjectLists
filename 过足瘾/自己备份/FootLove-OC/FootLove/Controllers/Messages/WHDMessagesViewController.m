//
//  WHDMessagesViewController.m
//  FootLove
//
//  Created by HUN on 16/6/27.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDMessagesViewController.h"
#import "WHDMessagesTableViewCell.h"
#import "MessageModel.h"
#import "XMPPManager.h"
#import "WHDDBManager.h"

@interface WHDMessagesViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property(nonatomic,strong)NSMutableArray *modelArr;

@end

@implementation WHDMessagesViewController
-(NSMutableArray *)modelArr
{
    if (_modelArr == nil) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setViewTitle:@"消息"];
    [self _initView];
}

-(void)_initView
{
    [_myTableView registerNib:[UINib nibWithNibName:@"WHDMessagesTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    
    
    
    //设置一个例子
    [[XMPPManager manager] listeningMessage:^(MessageModel *messageModel) {
        static BOOL isContent = NO;

        //判断内容是否存在，存在就不再添加，不然就添加
        for (MessageModel *model in self.modelArr) {
            if ([model.fromJid isEqualToString: messageModel.fromJid]) {
                isContent = YES;
                NSInteger totalNum = [model.totalUnReadCount integerValue];
                totalNum++;
                model.totalUnReadCount = [NSString stringWithFormat:@"%ld",totalNum];
                model.lastMessage = messageModel.content;
                [self.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%ld",totalNum]];
                [_myTableView reloadData];
                return ;
            }
        }
        if (isContent == NO) {
            
//            调用获取 技师信息的接口  需要传入技师的 userGUId（JID）
            NSMutableDictionary *pragram1 = [NSMutableDictionary dictionary];
            //    设置相关参数
            [pragram1 setObject:@1 forKey:@"appid"];
            [pragram1 setObject:@"BCCFFAAB6A7D79D1E6D1478F2B432B83CD451E2660F067BF" forKey:@"memberdes"];
            NSString *fromJid = [NSString stringWithFormat:@"%@",messageModel.fromJid];
            //            去掉jid中的 服务器余名
            [pragram1 setObject: [fromJid substringWithRange:(NSRange){0,fromJid.length - XMPPLocation.length}] forKey:@"userguid"];
            NSLog(@"%@",fromJid);
            //            发起网络请求 得到技师的信息
            [WHDHttpRequest whdReuqestActionWith:@"http://gzy.api.kd52.com/member.aspx?action=getmemberbyguid" and:pragram1 andCompletion:^(NSData *wdata, NSURLResponse *wresponse, NSError *werror) {
//                if (!werror) {
                //                转字典
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:wdata options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"字典%@",dic);//测试
                
                MessageModel *model = [MessageModel new];
                //                取出头像
                model.imageUrl = dic[@"memberinfo"][@"image_path"];
                //                取出名字
                model.nameStr  = dic[@"memberinfo"][@"member_name"];
                //                让未读消息 为1
               model.totalUnReadCount = @"1";
                //                加入数据源
                [self.modelArr addObject:model];
#if 0
            model.fromJid =messageModel.fromJid;
            model.toJid = messageModel.toJid;
            model.imageUrl = @"http://gzy.kd52.com/upload/images/shop/thumbnail/635810252659135323.png";
            model.nameStr  = @"我是哈哈";
            [self.modelArr addObject:model];
            NSLog(@"%ld",self.modelArr.count);
#endif
            [_myTableView reloadData];
            //由于这里只做一次的工作，方便本地话存储
            [[WHDDBManager manager] saveDataWithModel:model];
                    
//                }
            }];
        }
    }];

}


#pragma mark - tableviewDelegate


#pragma mark datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WHDMessagesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (_modelArr[indexPath.row]) {
        MessageModel *model = _modelArr[indexPath.row];
        cell.model = model;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
@end

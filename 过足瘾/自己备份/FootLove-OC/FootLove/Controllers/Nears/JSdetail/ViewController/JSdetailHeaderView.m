//
//  JSdetailHeaderView.m
//  FootLove
//
//  Created by HUN on 16/6/28.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "JSdetailHeaderView.h"
#import "JSTableView.h"
@interface JSdetailHeaderView ()
//装数据数目
@property (weak, nonatomic) IBOutlet UIView *showView;
//关注数目
@property (weak, nonatomic) IBOutlet UILabel *focus_LB;
//喜欢数目
@property (weak, nonatomic) IBOutlet UILabel *like_LB;
//礼物数目
@property (weak, nonatomic) IBOutlet UILabel *gift_LB;
//技师的编号
@property (weak, nonatomic) IBOutlet UILabel *JSId_lb;
//时间
@property (weak, nonatomic) IBOutlet UILabel *time_LB;

@property (weak, nonatomic) IBOutlet UIView *tableBackView;

@end


@implementation JSdetailHeaderView

-(void)viewDidLoad
{
    self.tabBarController.tabBar.hidden = YES;
    [self configView];
//    JSTableView
}

-(void)configView
{
    JSTableView *tableView = WHD_StoryWithName(@"JSTableView");
    [self addChildViewController:tableView];
    CGFloat table_H = CGRectGetHeight(_tableBackView.frame);
    tableView.view.frame = (CGRect){0,0,W_width,table_H};
    [_tableBackView addSubview:tableView.view];
}


- (IBAction)sender:(UIButton *)sender
{
    if (sender.tag == 10)//聊一聊
    {
        
    }else if (sender.tag == 11)//预约优惠
    {
        BookViewController *vc = [BookViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 12)//呼叫部长
    {
        UIAlertController *telController = [UIAlertController alertControllerWithTitle:nil message:@"是否要呼叫部长?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *tel_call = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //这里要启动打电话
            [[UIApplication sharedApplication] openURL:nil];
        }];
        
        UIAlertAction *tel_cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [telController addAction:tel_call];
        [telController addAction:tel_cancel];
        [self presentViewController:telController animated:YES completion:nil];
    }
}



@end

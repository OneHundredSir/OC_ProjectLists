//
//  PersonalViewController.m
//  JoinTheFoot
//
//  Created by skd on 16/6/27.
//  Copyright © 2016年 lzm. All rights reserved.
//

#import "PersonalViewController.h"

@interface PersonalViewController ()

//紫色背景视图
@property (weak, nonatomic) IBOutlet UIView *fullBgView;
//头像背景视图
@property (weak, nonatomic) IBOutlet UIView *headerBgView;
//头像视图
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
//名字视图
@property (weak, nonatomic) IBOutlet UILabel *name;
//积分视图
@property (weak, nonatomic) IBOutlet UILabel *code;
//粉丝按钮
@property (weak, nonatomic) IBOutlet UIButton *fensiBtn;
//关注按钮
@property (weak, nonatomic) IBOutlet UIButton *guanzhuBtn;
//礼物 按钮
@property (weak, nonatomic) IBOutlet UIButton *liwuBtn;

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headerBgView.layer.borderWidth = 2;
    self.headerBgView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headerBgView.layer.cornerRadius = 40;
    self.headerView.layer.cornerRadius = 30;
    self.headerView.layer.masksToBounds = YES;
    
    [self setBtnContent];

}
- (void)setBtnContent
{

    NSArray *titles = @[@"粉丝",@"关注",@"礼物"];
    NSArray *counts = @[@"10",@"1",@"20"];
    NSArray *btns = @[self.fensiBtn,self.guanzhuBtn,self.liwuBtn];
    for (int i = 0; i < titles.count; i ++)
    {
        
        UIButton *btn = btns[i];
        
        NSString *text = [NSString stringWithFormat:@"%@\n%@",counts[i],titles[i]];
        
        
        NSMutableAttributedString *mstr =  [[NSMutableAttributedString alloc]initWithString:text];
        
        [mstr addAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]} range:(NSRange){text.length - 2,2}];
        
        UILabel *contentLa = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreen_W / 4, 80)];
        contentLa.numberOfLines = 0;
        contentLa.textAlignment = NSTextAlignmentCenter;
        contentLa.textColor = [UIColor yellowColor];
        contentLa.font = font(17);
        [btn addSubview:contentLa];
        
        [contentLa setAttributedText:mstr];

        
    }


}

- (void)setIsOpen:(BOOL)isOpen
{
    if (isOpen) {
        
        [UIView animateWithDuration:0.35 animations:^{
            
            self.fullBgView.transform = CGAffineTransformMakeTranslation(-kScreen_W / 8, 0);
            
        }];
        
    }else
    {
        [UIView animateWithDuration:0.35 animations:^{
            
            self.fullBgView.transform = CGAffineTransformIdentity;
            
        }];
    
    }

}
- (IBAction)personSettingAction:(id)sender {
}
- (IBAction)artCheckAction:(id)sender {
}
- (IBAction)sysSettingAction:(id)sender {
}

@end

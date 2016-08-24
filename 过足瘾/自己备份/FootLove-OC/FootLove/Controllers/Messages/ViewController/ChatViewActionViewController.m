//
//  ChatViewActionViewController.m
//  FootLove
//
//  Created by HUN on 16/7/4.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "ChatViewActionViewController.h"

@interface ChatViewActionViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint1;

@property (weak, nonatomic) IBOutlet UIButton *recorderBtn;
@property (weak, nonatomic) IBOutlet UITextField *messageFld;


@end

@implementation ChatViewActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark 底部
- (IBAction)inputChangeAction:(UIButton *)sender
{
    
    
}

- (IBAction)smileFace:(UIButton *)sender {
}

- (IBAction)add:(UIButton *)sender {
}


#pragma mark 顶部
- (IBAction)animationAction:(UIButton *)sender {
    NSInteger myNum = sender.tag;
    if (myNum == 10)//花
    {
        
    }else if (myNum == 11)//笑脸
    {
        
    }else if (myNum == 12)//钱包
    {
    
    }else if (myNum == 13)//爱心
    {
        
    }else if (myNum == 14)//礼物
    {
        
    }
}


@end

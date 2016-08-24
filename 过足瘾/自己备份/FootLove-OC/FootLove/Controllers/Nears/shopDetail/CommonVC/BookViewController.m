//
//  BookViewController.m
//  FootLove
//
//  Created by HUN on 16/6/30.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "BookViewController.h"

@interface BookViewController ()
//技师的编号
@property (weak, nonatomic) IBOutlet UILabel *JSNum_LB;
//按钮的view
@property (weak, nonatomic) IBOutlet UIView *btnView;
//到店时间
@property (weak, nonatomic) IBOutlet UIScrollView *btnScrollView;
//名字文本框
@property (weak, nonatomic) IBOutlet UITextField *name_txf;
//手机号文本框
@property (weak, nonatomic) IBOutlet UITextField *telNum_txf;
//按钮
@property (weak, nonatomic) IBOutlet UIButton *subBtn;

@end

@implementation BookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)btn:(UIButton *)sender
{
}


@end

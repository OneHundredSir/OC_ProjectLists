//
//  WHDSelfViewController.m
//  xiaorizi
//
//  Created by HUN on 16/6/7.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDSelfViewController.h"

@interface WHDSelfViewController ()

@property (weak, nonatomic) IBOutlet UIView *outCircle;
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;

@property (weak, nonatomic) IBOutlet UIButton *quit;

@end

@implementation WHDSelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setLayout];
}

-(void)setLayout
{
    //外面的环
    _outCircle.layer.borderColor=[UIColor whiteColor].CGColor;
    _outCircle.layer.borderWidth=2;
    _outCircle.layer.cornerRadius=_outCircle.frame.size.width/2.0;
    //button的头像
    _titleBtn.layer.cornerRadius=_titleBtn.frame.size.width/2.0;
    
    //按钮的边沿
    _quit.layer.borderColor=[UIColor blackColor].CGColor;
    _quit.layer.borderWidth=2;
    _quit.layer.cornerRadius=_quit.frame.size.height/2.0;
}
- (IBAction)seletedBtn:(UIButton *)sender
{
    AppDelegate *delegate=[UIApplication sharedApplication].delegate;
    delegate.isOn=NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

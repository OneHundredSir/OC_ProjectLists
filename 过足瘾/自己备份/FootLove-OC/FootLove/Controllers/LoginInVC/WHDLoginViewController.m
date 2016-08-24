//
//  WHDLoginViewController.m
//  FootLove
//
//  Created by HUN on 16/7/1.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDLoginViewController.h"
#import "XMPPManager.h"
@interface WHDLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountLB;

@property (weak, nonatomic) IBOutlet UITextField *passwordLB;

@end

@implementation WHDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setLeftBtn:nil andTitle:nil];
}
#pragma mark 头部
-(void)setLeftBtn:(NSString *)iconStr andTitle:(NSString *)titleStr
{
    UIButton *btn =[[UIButton alloc]initWithFrame:(CGRect){0,0,40,44}];
    
    [btn addTarget:self action:@selector(loginBackAciton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *leftImage = [UIImage imageNamed:@"返回1"];
    
    btn.frame = CGRectMake(0, 0, leftImage.size.width + 10, 44);
    
    [btn setImageEdgeInsets:(UIEdgeInsets){0,10,0,0}];
    
    [btn setImage:leftImage forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}

-(void)loginBackAciton:(UIButton *)btn
{
#if  0
    
    NSLog(@"--->");
    [UIView animateWithDuration:0.35 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(W_width, 0);
    }];
    
#endif
    
}


- (IBAction)login:(UIButton *)sender
{
    XMPPManager *xmManager = [XMPPManager manager];
    [xmManager loginWithAccount:_accountLB.text password:_passwordLB.text completion:^(BOOL ret) {
        if (ret) {
            [self dismissViewControllerAnimated:YES completion:nil];
            NSLog(@"成功登陆");
            //登陆成功之后传递，由于这个页面要销毁.
            if (self.finishBlock) {
                self.finishBlock();
            }
            
        }
    }];
}

- (IBAction)shareLeft:(UIButton *)sender
{
    [[XMPPManager manager] registerWithAccount:_accountLB.text password:_passwordLB.text completion:^(BOOL ret) {
        if (ret) {
            NSLog(@"成功登陆");
        }
    }];
    
    
}

- (IBAction)shareRight:(id)sender
{
}


#pragma mark 页面控件


@end

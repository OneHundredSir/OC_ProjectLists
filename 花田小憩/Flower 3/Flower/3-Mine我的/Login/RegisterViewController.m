//
//  RegisterViewController.m
//  Flower
//
//  Created by HUN on 16/7/8.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
#pragma mark 国家按钮
@property (weak, nonatomic) IBOutlet UILabel *cityLb;
#pragma mark 电话号码/账号
@property (weak, nonatomic) IBOutlet UITextField *TelNumFd;

#pragma mark 验证码textfield
@property (weak, nonatomic) IBOutlet UITextField *safepwdFld;
#pragma mark 密码textfield
@property (weak, nonatomic) IBOutlet UITextField *pwdFld;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark 按钮事件
//把全部登陆等都消失
- (IBAction)dismissAction:(UIButton *)sender
{
    //由于这里消失之后还会显示，所以我们要做的就是让tabbar选中第二个先
    RootViewController *vc = [self getRootViewController];
    vc.isBackFromLogin = YES;
    if (self.loginVC)
    {
        [self.loginVC dismissViewControllerAnimated:YES completion:nil];
    };
    
}


//返回上一层
- (IBAction)backToOrigin:(UIButton *)sender {
    [UIView animateWithDuration:0.35 animations:^{
        self.view.alpha = 0;
    }];
}

#pragma mark 城市选择
- (IBAction)seletedCityBtn:(UIButton *)sender
{
    CityCommonVC *vc = [self showCityView];
    vc.Seletedblock = ^(NSString *seletedName){
        self.cityLb.text = seletedName;
    };
}


#pragma mark 获取验证码
- (IBAction)getSafeBtn:(UIButton *)sender
{
    
    [self alertMetionWitDetail:@"你的验证码是8888"];
}

#pragma mark 完成按钮
- (IBAction)finish:(UIButton *)sender
{
    //判断正确与否
    BOOL isCorrection = [self valiMobile:self.TelNumFd.text];
    NSInteger mobileLength = self.TelNumFd.text.length;
    NSInteger PWDLength = self.pwdFld.text.length;
    NSInteger safeLength = self.safepwdFld.text.length;
    if (mobileLength<=0 || PWDLength<=0) {
        [self alertMetionWitDetail:@"账号/密码不能为空"];
    }else if(safeLength<=0)
    {
        [self alertMetionWitDetail:@"请填写验证码"];
    }else
    {
        if (isCorrection) {
            if ([self.TelNumFd.text isEqualToString:@"15507596877"]&&[self.pwdFld.text isEqualToString:@"111111"]&&[self.safepwdFld.text isEqualToString:@"8888"]) {
                [self alertMetionWitDetail:@"注册密码成功" andFinishBlock:^{
                    [self backToOrigin:nil];
                }];
            }else
            {
                [self alertMetionWitDetail:@"👽好好检查，你错了"];
            }
            
#if 0 //这是网络请求部分
            [self webRequestLoginWithUserName:self.TelNumFd.text AndPassword:self.pwdFld.text andFinishBlock:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (!error) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    NSDictionary *statusDic = dic[@"status"];
                    NSString *msgStr = statusDic[@"msg"];
                    NSLog(@"%@,%@",dic,msgStr);
                    //这里返回的是回馈的数据，可以
                    if ([msgStr isEqualToString:@"用户名或者密码错误"])
                    {
                        [self alertMetionWitDetail:@"用户名或者密码错误"];
                    }else
                    {
#pragma mark 这里输入登陆跳转的内容
                        NSLog(@"成功登陆了");
                    }
                }else
                {
                    NSLog(@"请求失败了,%@",error);
                    [self alertMetionWitDetail:@"请求网络错误"];
                }
            }];
#endif
        }else
        {
            [self alertMetionWitDetail:@"请输入正确的手机号码"];
        }
    }
}

#pragma mark 详情页面
- (IBAction)info:(id)sender {
    [self showWebViewWithUrlString:InfoUrl];
}

@end

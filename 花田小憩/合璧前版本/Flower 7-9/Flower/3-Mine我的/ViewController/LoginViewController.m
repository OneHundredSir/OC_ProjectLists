//
//  LoginViewController.m
//  Flower
//
//  Created by HUN on 16/7/7.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetViewController.h"
@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UILabel *cityLb;
#pragma mark 电话号码/账号
@property (weak, nonatomic) IBOutlet UITextField *TelNumFd;
#pragma mark 密码textfield
@property (weak, nonatomic) IBOutlet UITextField *pwdFld;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self _initView];
}

#pragma mark 页面布局



-(void)_initView
{
    //加入注册
    RegisterViewController *registerVC = [RegisterViewController new];
    [self addChildViewController:registerVC];
    registerVC.view.frame = self.view.frame;
    registerVC.loginVC = self;
    self.registerVC = registerVC;
    [self.view addSubview:registerVC.view];
    self.registerVC.view.alpha = 0;
//    NSLog(@"忘记.%@,%@",self.registerVC,NSStringFromCGRect(registerVC.view.frame));
    
    //加入忘记
    ForgetViewController *forgetVC = [ForgetViewController new];
    forgetVC.view.frame = self.view.frame;
    forgetVC.loginVC = self;
    self.forgetVC = forgetVC;
    [self addChildViewController:forgetVC];
    [self.view addSubview:forgetVC.view];
    self.forgetVC.view.alpha = 0;
//    NSLog(@"忘记.%@",self.forgetVC);
}




#pragma mark - 按钮事件
//把全部登陆等都消失
- (IBAction)dismissAction:(UIButton *)sender
{
    //由于这里消失之后还会显示，所以我们要做的就是让tabbar选中第二个先
    RootViewController *vc = [self getRootViewController];
    vc.isBackFromLogin = YES;
    
    [self dismissViewControllerAnimated:YES completion:^{
            }];
}

//返回上一层
- (IBAction)backToOrigin:(UIButton *)sender {
    RootViewController *vc = [self getRootViewController];
    vc.isBackFromLogin = YES;
    //千万不能放里面，因为我做了没有登陆的处理，如果跳转后执行又进入了willapear
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark 城市选择
- (IBAction)seletedCityBtn:(UIButton *)sender
{
     CityCommonVC *vc = [self showCityView];
    vc.Seletedblock = ^(NSString *seletedName){
        self.cityLb.text = seletedName;
    };
}

#pragma mark 注册账号跳转

- (IBAction)registerBtn:(UIButton *)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        self.registerVC.view.alpha = 1;
    }];
}

#pragma mark 忘记密码跳转
- (IBAction)forget:(UIButton *)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        self.forgetVC.view.alpha = 1;
    }];
    
}

#pragma mark 登陆

- (IBAction)login:(UIButton *)sender
{
    BOOL isCorrection = [self valiMobile:self.TelNumFd.text];
    NSInteger mobileLength = self.TelNumFd.text.length;
    NSInteger PWDLength = self.pwdFld.text.length;
    if (mobileLength<=0 || PWDLength<=0) {
        [self alertMetionWitDetail:@"账号/密码不能为空"];
    }else
    {
        if (isCorrection) {
            //验证账号密码正确与否
            if ([self.TelNumFd.text isEqualToString:@"15507596877"]&&[self.pwdFld.text isEqualToString:@"111111"]) {
                [self alertMetionWitDetail:@"登陆成功" andFinishBlock:^{
                    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
                    delegate.isLogin = YES;
                    //返回去的按钮
                    [self dismissAction:nil];
                }];
            }else
            {
                [self alertMetionWitDetail:@"用户名或者密码错误"];
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



#pragma mark 第三方接入
- (IBAction)shareLogin:(UIButton *)sender
{
    NSInteger index = sender.tag;
    if(index == 10)//微信接入
    {
        NSLog(@"微信接入");
    }else if (index ==11)//微博接入
    {
        NSLog(@"微博接入");
    }else if (index ==12)//QQ接入
    {
        NSLog(@"QQ接入");
    }
    
}

#pragma mark 服务条款
- (IBAction)info:(UIButton *)sender
{
    [self showWebViewWithUrlString:InfoUrl];
}




@end

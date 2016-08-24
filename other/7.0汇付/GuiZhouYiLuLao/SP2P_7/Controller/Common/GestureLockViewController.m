//
//  GestureLockViewController.m
//  SP2P_7
//
//  Created by 李小斌 on 14-6-23.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "GestureLockViewController.h"

#import "GestureLockView.h"

#import "TabViewController.h"
#import "LeftMenuViewController.h"
#import "ColorTools.h"
#import <QuartzCore/QuartzCore.h>
#import "VerifyPasswordViewController.h"
#import "OtherLoginViewController.h"


#import "UIImageView+WebCache.h"

#import "AppDelegate.h"
@interface GestureLockViewController ()<GestureLockViewDelegate, HTTPClientDelegate,UIAlertViewDelegate>
{
    NSInteger _count;// 手势计数器
}

@property (nonatomic, strong)  GestureLockView *lockView;
@property (nonatomic,strong) UIImageView *headView;
@property (nonatomic,strong) UILabel *nameLabel;

@property(nonatomic ,strong) NetWorkClient *requestClient;

@end

@implementation GestureLockViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    
    [self initData];
    
    [self initView];
}

-(void) initData{
    _count = 0;
}

- (void)initView
{
    self.view.backgroundColor = KColor;
    
    _headView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.5-37.5,65, 75, 75)];
    _headView.layer.cornerRadius = 37.5;
    _headView.userInteractionEnabled = NO;
    _headView.layer.masksToBounds = YES;
    [self.view addSubview:_headView];
    
    // 加载上次登陆的头像或者默认的头像
    NSString *imageUrl = [[AppDefaultUtil sharedInstance] getDefaultHeaderImageUrl];
    DLOG(@"imageUrl====%@=", imageUrl);
    
    [_headView  sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                  placeholderImage:[UIImage imageNamed:@"default_head"]];
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, MSWIDTH-20, 30)];
    NSString *userName = [[AppDefaultUtil sharedInstance] getDefaultUserName];
    _nameLabel.text = [NSString stringWithFormat:@"欢迎回来, %@",userName];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.tag = 110;
    _nameLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:15.0];
    _nameLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_nameLabel];
    
    UIButton *forgetpwd = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetpwd.frame = CGRectMake(15, self.view.frame.size.height-40, 100, 15);
    forgetpwd.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [forgetpwd setTitle:@"忘记手势密码" forState:UIControlStateNormal];
    [forgetpwd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [forgetpwd addTarget:self action:@selector(forgetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetpwd];
    
    UIButton *otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    otherBtn.frame = CGRectMake(self.view.frame.size.width-120, self.view.frame.size.height-40, 100, 15);
    otherBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [otherBtn setTitle:@"登录其他账户" forState:UIControlStateNormal];
    [otherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [otherBtn addTarget:self action:@selector(otherBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:otherBtn];
    

    self.lockView = [[GestureLockView alloc] initWithFrame:CGRectMake(0, -70, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.lockView.normalGestureNodeImage = [UIImage imageNamed:@"gesture_node_normal.png"];
    self.lockView.selectedGestureNodeImage = [UIImage imageNamed:@"gesture_node_selected.png"];
    self.lockView.lineColor = [[ColorTools colorWithHexString:@"#00ff76"] colorWithAlphaComponent:0.3];
    self.lockView.lineWidth = 8;
    self.lockView.delegate = self;
    if(self.view.frame.size.height == 480) {
        self.lockView.contentInsets = UIEdgeInsetsMake(self.view.frame.size.height*0.5+25, self.view.frame.size.width*0.15 + 5, 10, self.view.frame.size.width*0.15 + 5);
    }else {
        self.lockView.contentInsets = UIEdgeInsetsMake(self.view.frame.size.height*0.5+30, self.view.frame.size.width*0.15, 30, self.view.frame.size.width*0.15);
    }
    [self.view addSubview:self.lockView];
}

#pragma mark -
#pragma mark GesturelockView
- (void)gestureLockView:(GestureLockView *)gestureLockView didBeginWithPasscode:(NSString *)passcode{
   
}

- (void)gestureLockView:(GestureLockView *)gestureLockView didEndWithPasscode:(NSString *)passcode
{
    DLOG(@"%@",passcode);
    

    NSString *desPassword = [[AppDefaultUtil sharedInstance] getGesturesPasswordWithAccount:[[AppDefaultUtil sharedInstance] getDefaultUserName]];

    NSString *gesturesPassword = [NSString decrypt3DES:desPassword key:DESkey];
    
    DLOG(@"手势密码为:%@",gesturesPassword);
    if (![passcode isEqualToString:gesturesPassword]) {
        _count++;
        if (_count < 5) {
            
            UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.5-90,170, 180, 30)];
            countLabel.text = [NSString stringWithFormat:@"密码错误还可以尝试%ld次", 5 - _count];
            countLabel.tag = 5 - _count;
            countLabel.textAlignment = NSTextAlignmentCenter;
            countLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:15.0];
            countLabel.textColor = [UIColor whiteColor];;
            for (UILabel *label in [self.view subviews]) {
                if ([label isKindOfClass:[UILabel class]]&&label.tag<5) {
                    [label removeFromSuperview];
                }
            }
            
            [self.view addSubview:countLabel];
            [self shakeAnimationForView:countLabel];
            
        }else {
            for (UILabel *label in [self.view subviews]) {
                if ([label isKindOfClass:[UILabel class]]&&label.tag != 110) {
                   
                        [label removeFromSuperview];
                
                }
            }
            self.lockView.userInteractionEnabled = 0;
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已经超过限定次数，请通过忘记手势密码重新设置！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert1.tag = 1;
            
            [alert1 show];
    
        }
    }else {
        
        [_nameLabel removeFromSuperview];
        [_lockView  removeFromSuperview];
        for (UILabel *textlabel in [self.view subviews]) {
            
            if ([textlabel isKindOfClass:[UILabel class]]) {
               
                     [textlabel removeFromSuperview];

            }
        }
        
        [UIView animateWithDuration:1.0 animations:^{
            
            //头像下移居中
            _headView.center = CGPointMake(self.view.frame.size.width*0.5, self.view.frame.size.height*0.5);
        
        } completion:^(BOOL finished) {
            
            [self login];
            
        }];
    }
}

- (void)gestureLockView:(GestureLockView *)gestureLockView didCanceledWithPasscode:(NSString *)passcode
{
    DLOG(@"%@",passcode);
}


#pragma  mark 使用其他账号登陆
- (void)otherBtnClick
{
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
    DLOG(@"登录其他帐号");
    AppDelegateInstance.userInfo = nil;
    
    // 通知全局广播 LeftMenuController 修改UI操作
    [[NSNotificationCenter defaultCenter]  postNotificationName:@"update" object:nil];
    
    OtherLoginViewController *OtherLoginVC= [[OtherLoginViewController alloc] init];
    OtherLoginVC.forgetTag = 2;
    UINavigationController *OtherLoginNav = [[UINavigationController alloc] initWithRootViewController:OtherLoginVC];
    [self presentViewController:OtherLoginNav animated:YES completion:nil];
}

#pragma  mark 忘记手势密码
- (void)forgetBtnClick
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否清空当前用户信息？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alertView.tag = 2;
    
    [alertView show];
}


#pragma mark UIalertViewdelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 1:
        {
            if (buttonIndex==0) {
                OtherLoginViewController *verify1= [[OtherLoginViewController alloc] init];
                verify1.forgetTag = 2;
                UINavigationController *verifyVC = [[UINavigationController alloc] initWithRootViewController:verify1];
                [self presentViewController:verifyVC animated:YES completion:nil];
            }
        }
            
            break;
        case 2:
        {
            
            if (buttonIndex==0) {
               
                //    DLOG(@"跳过登录");
                [[AppDefaultUtil sharedInstance] removeGesturesPasswordWithAccount:[[AppDefaultUtil sharedInstance] getDefaultUserName]];// 移除该账号的手势密码
            
                [[AppDefaultUtil sharedInstance] setDefaultUserName:@""];// 清除用户昵称
                [[AppDefaultUtil sharedInstance] setDefaultAccount:@""];// 清除用户账号
                [[AppDefaultUtil sharedInstance] setDefaultUserPassword:@""];// 清除用户密码
                [[AppDefaultUtil sharedInstance] setDefaultHeaderImageUrl:@""];// 清除用户头像
                AppDelegateInstance.userInfo = nil;
            
                OtherLoginViewController *verify= [[OtherLoginViewController alloc] init];
                verify.forgetTag = 2;
                UINavigationController *verifyVC = [[UINavigationController alloc] initWithRootViewController:verify];
                [self presentViewController:verifyVC animated:YES completion:nil];
                
                // 通知全局广播 LeftMenuController 修改UI操作
                [[NSNotificationCenter defaultCenter]  postNotificationName:@"update" object:nil];

            }
        }
            
            break;
            
        default:
            break;
    }
}


#pragma  mark -
#pragma  mark Animationdelegate
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{

}

#pragma mark 抖动动画
- (void)shakeAnimationForView:(UIView *) view
{
    // 获取到当前的View
    CALayer *viewLayer = view.layer;
    
    // 获取当前View的位置
    CGPoint position = viewLayer.position;
    
    // 移动的两个终点位置
    CGPoint x = CGPointMake(position.x + 10, position.y);
    CGPoint y = CGPointMake(position.x - 10, position.y);
    
    // 设置动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    // 设置运动形式
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    
    // 设置开始位置
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    
    // 设置结束位置
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    
    // 设置自动反转
    [animation setAutoreverses:YES];
    
    // 设置时间
    [animation setDuration:.06];
    
    // 设置次数
    [animation setRepeatCount:3];
    
    // 添加上动画
    [viewLayer addAnimation:animation forKey:nil];
}

- (void) login
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *name = [[AppDefaultUtil sharedInstance] getDefaultAccount];
    NSString *password = [[AppDefaultUtil sharedInstance] getDefaultUserPassword];
    NSString *deviceType = [[AppDefaultUtil sharedInstance] getdeviceType];
    [parameters setObject:@"1" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:name forKey:@"name"];
    [parameters setObject:password forKey:@"pwd"];
    if(AppDelegateInstance.userId !=nil && AppDelegateInstance.channelId != nil)
    {
      [parameters setObject:AppDelegateInstance.userId forKey:@"userId"];
      [parameters setObject:AppDelegateInstance.channelId forKey:@"channelId"];
      
    }else{
    
    
        [parameters setObject:@"" forKey:@"userId"];
        [parameters setObject:@"" forKey:@"channelId"];
    
    }
    [parameters setObject:deviceType forKey:@"deviceType"];
    if (_requestClient == nil) {
        _requestClient = [[NetWorkClient alloc] init];
        _requestClient.delegate = self;
        
    }
    
    [_requestClient requestGet:@"app/services" withParameters:parameters];

}


#pragma HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    
    NSDictionary *dics = obj;
    
    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
        
        DLOG(@"返回成功  username -> %@",[obj objectForKey:@"username"]);
        DLOG(@"返回成功  id -> %@",[obj objectForKey:@"id"]);
        DLOG(@"返回成功  vipStatus -> %@",[obj objectForKey:@"vipStatus"]);
        
        UserInfo *usermodel = [[UserInfo alloc] init];
        if([[obj objectForKey:@"creditRating"] hasPrefix:@"http"])
        {
             usermodel.userCreditRating = [obj objectForKey:@"creditRating"];
            
        }else{
            usermodel.userCreditRating =  [NSString stringWithFormat:@"%@%@", Baseurl, [obj objectForKey:@"creditRating"]];
        }
        usermodel.userName = [obj objectForKey:@"username"];
        if ([[obj objectForKey:@"headImg"] hasPrefix:@"http"]) {
            
             usermodel.userImg = [NSString stringWithFormat:@"%@", [obj objectForKey:@"headImg"]];
        }else{
            
         usermodel.userImg = [NSString stringWithFormat:@"%@%@", Baseurl, [obj objectForKey:@"headImg"]];
        
        }
        usermodel.userLimit = [obj objectForKey:@"creditLimit"];
        usermodel.isVipStatus = [obj objectForKey:@"vipStatus"];
        usermodel.userId = [obj objectForKey:@"id"];
        usermodel.isLogin = @"1";
        usermodel.accountAmount = [NSString stringWithFormat:@"%.2f", [[obj objectForKey:@"accountAmount"] floatValue]];
        usermodel.availableBalance = [NSString stringWithFormat:@"%.2f", [[obj objectForKey:@"availableBalance"] floatValue]];
        usermodel.isEmailStatus = [[obj objectForKey:@"hasEmail"] boolValue];
        usermodel.isMobileStatus = [[obj objectForKey:@"hasMobile"] boolValue];
        
        AppDelegateInstance.userInfo = usermodel;
        
        // 通知全局广播 LeftMenuController 修改UI操作
        [[NSNotificationCenter defaultCenter] postNotificationName:@"update" object:[obj objectForKey:@"username"]];
        [self loginSuccess];// 登录成功
        
    }else if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-2"]) {
        
        [ReLogin outTheTimeRelogin:self];
    
    }else {
        DLOG(@"返回失败  msg -> %@",[obj objectForKey:@"msg"]);
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", [obj objectForKey:@"msg"]]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * 600000000ull)), dispatch_get_main_queue(), ^{
           [self otherBtnClick];
        
        });
    }
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    
    [self otherBtnClick];
    
//    [SVProgressHUD showErrorWithStatus:@"网络异常"];
 
}

// 无可用的网络
-(void) networkError
{
   [SVProgressHUD showErrorWithStatus:@"无可用网络"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * 600000000ull)), dispatch_get_main_queue(), ^{
       [self otherBtnClick];
    });
    
}

-(void) loginSuccess
{
    //主界面
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [UIApplication sharedApplication].statusBarHidden = NO;
//    TabViewController *tabViewController = [[TabViewController alloc] init];
    TabViewController *tabViewController = [TabViewController shareTableView];
    LeftMenuViewController *leftMenu = [[LeftMenuViewController alloc] init];
    
    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:tabViewController menuViewController:leftMenu];
    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    frostedViewController.liveBlur = YES;
    //            frostedViewController.delegate = self;
    
    AppDelegateInstance.window.rootViewController = frostedViewController;
    
    // 通知全局广播 LeftMenuController 修改UI操作
//    [self presentViewController:navigationController animated:NO completion:nil];
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_requestClient != nil) {
        [_requestClient cancel];
    }
}

@end

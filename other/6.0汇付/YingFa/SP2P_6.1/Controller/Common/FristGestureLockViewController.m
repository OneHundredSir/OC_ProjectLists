//
//  FristGestureLockViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-7-22.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "FristGestureLockViewController.h"
#import "GestureLockView.h"
#import "MainViewController.h"
#import "ColorTools.h"


@interface FristGestureLockViewController ()<GestureLockViewDelegate>
{

    NSMutableArray *passwordArr;

}
@property (nonatomic, strong)  GestureLockView *lockView;
@property (nonatomic, strong)  UILabel *againLabel;

@end

@implementation FristGestureLockViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.navigationController.navigationBarHidden = YES;
    
    [self initNavigationBar];
    
    [self initView];
    
    [self initData];
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"设置手势密码";
    self.view.backgroundColor = SETCOLOR(25, 89, 156, 1.0);
    
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    // 导航条 左边 返回按钮
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:nil];
    
    [self.navigationItem setLeftBarButtonItem:backButton];


//    // 导航条 右边 设置按钮
//    UIBarButtonItem *settingItem=[[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStyleDone target:self action:@selector(butClick:)];
//    settingItem.tag = 2;
//    settingItem.tintColor = [UIColor whiteColor];
//    [self.navigationItem setRightBarButtonItem:settingItem];
}


- (void)initView
{
    self.view.backgroundColor = SETCOLOR(25, 89, 156, 1.0);
    
    UILabel *footLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-70, self.view.frame.size.width, 30)];
    footLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:15.0];
    footLabel.text = @"手势密码将在您开启程序时启动";
    footLabel.textAlignment = NSTextAlignmentCenter;
    footLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:footLabel];
    
    _againLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 140, self.view.frame.size.width, 30)];
    _againLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:15.0];
    _againLabel.tag = 100;
    _againLabel.textAlignment = NSTextAlignmentCenter;
    _againLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_againLabel];
    
    self.lockView = [[GestureLockView alloc] initWithFrame:CGRectMake(0, -90, self.view.bounds.size.width, self.view.bounds.size.height)];
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

- (void)initData
{
    
    passwordArr = [[NSMutableArray alloc] init];
    
}


- (void)gestureLockView:(GestureLockView *)gestureLockView didBeginWithPasscode:(NSString *)passcode
{

}


- (void)gestureLockView:(GestureLockView *)gestureLockView didEndWithPasscode:(NSString *)passcode
{
    
    DLOG(@"手势密码为:%@",passcode);  
    UILabel *label1 = (UILabel *)[self.view viewWithTag:103];
    [label1 removeFromSuperview];
    
    if (passcode.length < 7) {
        _againLabel.text = @"至少连接4个点，请重新输入!";
        
        [self shakeAnimationForView:_againLabel];
    }else {
        [passwordArr insertObject:passcode atIndex:0];
    
        if ([passwordArr count]==1) {
      
            _againLabel.text = @"请再输入一次密码确认！";

        }else if ([passwordArr count]==2) {
        
            if ([[passwordArr objectAtIndex:0] isEqualToString:[passwordArr objectAtIndex:1]]) {
            
                //存储手势密码
                
                NSString *despwd = [NSString encrypt3DES:[passwordArr objectAtIndex:0] key:DESkey];
                
                [[AppDefaultUtil sharedInstance] setGesturesPasswordWithAccount:AppDelegateInstance.userInfo.userName gesturesPassword:despwd];
            
                // 设置成功
                [self setSuccess];

            }else {
                DLOG(@"密码不一致！！！！！");
                _againLabel.text = @"请重新设置手势密码！";
                [self shakeAnimationForView:_againLabel];
                
                [passwordArr removeAllObjects];
            }
        }
    }
}

-(void) setSuccess
{
    UIViewController *navroot = [self.navigationController.viewControllers objectAtIndex:0];
    [navroot dismissViewControllerAnimated:YES completion:nil];
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

@end

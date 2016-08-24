//
//  FristGestureLockViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-7-22.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "FristGestureLockViewController.h"
#import "GestureLockView.h"
#import "ColorTools.h"
#import "TabViewController.h"

@interface FristGestureLockViewController ()<GestureLockViewDelegate>
{
    
    NSMutableArray *passwordArr;
    
}
@property (nonatomic, strong)  GestureLockView *lockView;
@property (nonatomic, strong)  UILabel *againLabel;
@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation FristGestureLockViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    self.navigationController.navigationBarHidden = NO;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    
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
//    self.view.backgroundColor = KColor;
//    // 导航条 左边 返回按钮
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@""
//                                                                   style:UIBarButtonItemStyleBordered
//                                                                  target:self
//                                                                  action:nil];
//    
//    [self.navigationItem setLeftBarButtonItem:backButton];
    
    
    //    // 导航条 右边 设置按钮
    //    UIBarButtonItem *settingItem=[[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStyleDone target:self action:@selector(butClick:)];
    //    settingItem.tag = 2;
    //    settingItem.tintColor = [UIColor whiteColor];
    //    [self.navigationItem setRightBarButtonItem:settingItem];
}


- (void)initView
{
    self.view.backgroundColor = KColor;
    
    CGFloat space = MSHIGHT <= 568?0:15;
    
    CGFloat lockViewTop = MSHIGHT <= 480?(self.view.frame.size.height*0.5+35):(self.view.frame.size.height*0.5+60+space);
    
    CGFloat top = 64.f;
    if (self.navigationController.navigationBarHidden == YES) {
        top = 0;
    }
    
    CGFloat _headViewY = 60+space - top;
    _headView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.5-37.5, _headViewY, 75, 75)];
    _headView.layer.cornerRadius = 37.5;
    _headView.userInteractionEnabled = NO;
    _headView.layer.masksToBounds = YES;
    [self.view addSubview:_headView];
    
    
    // 加载上次登陆的头像或者默认的头像
    NSString *imageUrl = [[AppDefaultUtil sharedInstance] getDefaultHeaderImageUrl];
    DLOG(@"imageUrl====%@=", imageUrl);
    
    [_headView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                 placeholderImage:[UIImage imageNamed:@"default_head"]];
    
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_headView.frame)+5, MSWIDTH-20, 30)];
    NSString *userName = [[AppDefaultUtil sharedInstance] getDefaultUserName];
    _nameLabel.text = [NSString stringWithFormat:@"欢迎回来, %@",userName];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.tag = 110;
    _nameLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:15.0];
    _nameLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_nameLabel];
    
    
    
    _againLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MSHIGHT-lockViewTop-40, self.view.frame.size.width, 30)];
    _againLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:15.0];
    _againLabel.tag = 100;
    _againLabel.textAlignment = NSTextAlignmentCenter;
    _againLabel.textColor = [UIColor whiteColor];
    _againLabel.text = @"设置手势密码";
    [self.view addSubview:_againLabel];
    
    
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
    
    UILabel *footLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-70, self.view.frame.size.width, 30)];
    footLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:15.0];
    footLabel.text = @"手势密码在您每次打开程序时启用";
    footLabel.textAlignment = NSTextAlignmentCenter;
    footLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:footLabel];
    
}

- (void)initData
{
    
    passwordArr = [[NSMutableArray alloc] init];
    
}


- (void)gestureLockView:(GestureLockView *)gestureLockView didBeginWithPasscode:(NSString *)passcode
{}


- (void)gestureLockView:(GestureLockView *)gestureLockView didEndWithPasscode:(NSString *)passcode
{
    DLOG(@"手势密码为:%@",passcode);  DLOG(@"手势密码为:%@",passcode);
    
    if (passcode.length < 7) {
        _againLabel.text = @"至少连接4个点，请重新输入!";
        
        [self shakeAnimationForView:_againLabel];
    }else {
        [passwordArr insertObject:passcode atIndex:0];
        
        if ([passwordArr count]==1) {
            
            _againLabel.text = @"请再绘制一遍确认手势密码";
            
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
    if ([self.navigationController.viewControllers.firstObject isKindOfClass:[HomeViewController class]]) {
         [self.navigationController popToRootViewControllerAnimated:NO];
    }else{
        
        UIViewController *navroot = self.navigationController.viewControllers.firstObject;
        [navroot dismissViewControllerAnimated:YES completion:nil];
    }
    
    //直接跳转首页
//    TabViewController *tabViewController = [TabViewController shareTableView];
//    [self.frostedViewController presentMenuViewController];
//    self.frostedViewController.contentViewController = tabViewController;
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

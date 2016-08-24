//
//  ChangeGesturesPasswordViewController.m
//  SP2P_7
//
//  Created by Jerry on 14-8-13.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//修改手势密码
#import "ChangeGesturesPasswordViewController.h"
#import "GestureLockView.h"

#import "ColorTools.h"


@interface ChangeGesturesPasswordViewController ()<GestureLockViewDelegate,UIAlertViewDelegate>
{
    
    NSMutableArray *passwordArr;
    
}
@property (nonatomic, strong)  GestureLockView *lockView;
@property (nonatomic, strong)  UILabel *againLabel;

@end

@implementation ChangeGesturesPasswordViewController

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
    
    [self initView];
    
    [self initNavigationBar];
    
    [self initData];
    
}


- (void)initView
{
    self.view.backgroundColor = KColor;
    
    self.lockView = [[GestureLockView alloc] initWithFrame:CGRectMake(0, -90, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    _againLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 140, self.view.frame.size.width, 30)];
    _againLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:15.0];
    _againLabel.tag = 100;
    _againLabel.textAlignment = NSTextAlignmentCenter;
    _againLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_againLabel];
    
    self.lockView.normalGestureNodeImage = [UIImage imageNamed:@"gesture_node_normal.png"];
    self.lockView.selectedGestureNodeImage = [UIImage imageNamed:@"gesture_node_selected.png"];
    self.lockView.lineColor = [[ColorTools colorWithHexString:@"#00ff76"] colorWithAlphaComponent:0.3];
    self.lockView.lineWidth = 8;
    self.lockView.delegate = self;
    self.lockView.contentInsets = UIEdgeInsetsMake(self.view.frame.size.height*0.5+10, self.view.frame.size.width*0.15, 60, self.view.frame.size.width*0.15);
    
    
    [self.view addSubview:self.lockView];
}

- (void)initData
{
    
    passwordArr = [[NSMutableArray alloc] init];
    
}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"修改手势密码";
   // [self.view setBackgroundColor:KblackgroundColor];
    
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    // 导航条 左边 返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tag = 1;
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
}


- (void)gestureLockView:(GestureLockView *)gestureLockView didBeginWithPasscode:(NSString *)passcode{

    
}

- (void)gestureLockView:(GestureLockView *)gestureLockView didEndWithPasscode:(NSString *)passcode{
    DLOG(@"%@",passcode);
    
    DLOG(@"手势密码为:%@",passcode);  DLOG(@"手势密码为:%@",passcode);
    UILabel *label1 = (UILabel *)[self.view viewWithTag:103];
    [label1 removeFromSuperview];
    
    if (passcode.length < 7) {
        _againLabel.text = @"至少连接4个点，请重新输入!";
        [self shakeAnimationForView:_againLabel];
    }else {
        [passwordArr insertObject:passcode atIndex:0];
    
        if ([passwordArr count] == 1) {
  
            _againLabel.text = @"请再绘制一遍确认手势密码";

        }else if ([passwordArr count]==2) {
            
            if ([[passwordArr objectAtIndex:0] isEqualToString:[passwordArr objectAtIndex:1]]) {
            
                NSString *despwd = [NSString encrypt3DES:[passwordArr objectAtIndex:0] key:DESkey];
                [[AppDefaultUtil sharedInstance] setGesturesPasswordWithAccount:[[AppDefaultUtil sharedInstance] getDefaultUserName] gesturesPassword:despwd];
            
                UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手势密码修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertview show];
            
            }else {
                DLOG(@"密码不一致！！！！！");
                _againLabel.text = @"请重新设置手势密码！";
                
                [self shakeAnimationForView:_againLabel];
                [passwordArr removeAllObjects];
            
            }
        }
    }
}


#pragma mark UIalertViewdelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}


- (void)gestureLockView:(GestureLockView *)gestureLockView didCanceledWithPasscode:(NSString *)passcode
{
    DLOG(@"取消%@",passcode);
}

#pragma mark -
#pragma mark 返回
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
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

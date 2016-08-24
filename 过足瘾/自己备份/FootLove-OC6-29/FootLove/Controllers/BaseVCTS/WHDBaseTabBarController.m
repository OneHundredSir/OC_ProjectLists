//
//  WHDBaseTabBarController.m
//  FootLove
//
//  Created by HUN on 16/6/27.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDBaseTabBarController.h"

@interface WHDBaseTabBarController ()

@end

@implementation WHDBaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _initTbar];
    [self addGestureWay];
}
#pragma mark 设置手势
-(void)addGestureWay
{
    UIPanGestureRecognizer *myPan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panWay:)];
    self.pan=myPan;
    [self.view addGestureRecognizer:myPan];
}

/** 手势实现方法 */
static BOOL IsClick = YES;
-(void)panWay:(UIPanGestureRecognizer *)pan
{
    if (pan!=nil || pan.state == UIGestureRecognizerStateBegan)//判断手势刚刚开始滑动
    {
        CGPoint point = [pan translationInView:self.view];
        if (point.x > 0 )
        {
            [UIView animateWithDuration:0.35 animations:^{
                self.view.center = (CGPoint){W_width  * (2-W_scale),W_height/2};
                self.view.transform=CGAffineTransformMakeScale(W_scale, W_scale);
                self.view.layer.shadowColor = [UIColor blackColor].CGColor;
                self.view.layer.shadowOffset = (CGSize){-2,-2};
                self.view.layer.shadowOpacity = 1;
            }];
            myIsOn(YES)
        }else
        {
            [UIView animateWithDuration:0.35 animations:^{
                self.view.center = (CGPoint){W_width /2,W_height/2};
                self.view.transform=CGAffineTransformIdentity;//回到原点
                myIsOn(NO)
                
                self.view.layer.shadowColor = W_BackColor.CGColor;
                self.view.layer.shadowOffset = (CGSize){0,0};
                self.view.layer.shadowOpacity = 0.8;
            }];
        }
    }else//如果直接调用这个方法
    {
        if (IsClick)
        {
            [UIView animateWithDuration:0.35 animations:^{
                self.view.center = (CGPoint){W_width  * (2-W_scale),W_height/2};
                self.view.transform=CGAffineTransformMakeScale(W_scale, W_scale);
                self.view.layer.shadowColor = [UIColor blackColor].CGColor;
                self.view.layer.shadowOffset = (CGSize){-2,-2};
                self.view.layer.shadowOpacity = 1;
            }];
            myIsOn(YES)
        }else
        {
            [UIView animateWithDuration:0.35 animations:^{
                self.view.center = (CGPoint){W_width /2,W_height/2};
                self.view.transform=CGAffineTransformIdentity;//回到原点
                myIsOn(NO)
                
                self.view.layer.shadowColor = W_BackColor.CGColor;
                self.view.layer.shadowOffset = (CGSize){0,0};
                self.view.layer.shadowOpacity = 0.8;
            }];
        }
        IsClick = !IsClick;
    }
}

/**
 *  给根视图的personview ison赋值改变形变
 */
-(void)mySetIsOb:(BOOL)isBool
{
    AppDelegate *del = [UIApplication sharedApplication].delegate;
    RootViewController *vc = (RootViewController *)del.window.rootViewController;
    vc.personVC.IsOn=isBool;
}

#pragma mark 设置tabbarController
-(void)_initTbar
{
    [self.tabBar setBarTintColor:[UIColor whiteColor]];
//    [self.tabBar setTranslucent:NO];//不透明，不用设置
    NSArray *SelIcons = @[@"附近2",@"消息2",@"发现2",@"钱包2"];
    NSArray *UnSelIcons = @[@"附近1",@"消息1",@"发现1",@"钱包1"];
    NSArray *Titles = @[@"附近",@"消息",@"发现",@"钱包"];
    NSArray *Wcontrollers = @[@"WHDNearsViewController",@"WHDMessagesViewController",@"WHDDiscoverViewController",@"WHDWalletViewController"];
    
    //设置一个数组转控制器
    NSMutableArray *VC_models=[NSMutableArray array];
    for (int i=0; i<SelIcons.count; i++) {
        WHDBaseViewController *VC = [NSClassFromString(Wcontrollers[i]) new];
        //设置navigationcontroller
        WHDBaseNavigationController *navi=[[WHDBaseNavigationController alloc]initWithRootViewController:VC];
        //这里要注意一个问题就是图片格式，如果图片不显示的话，文字也显示不出来
        //设置不选中的图片
        [VC.tabBarItem setImage:[[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",UnSelIcons[i]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        //设置选中的图片
        [VC.tabBarItem setSelectedImage:[[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",SelIcons[i]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        //设置文字
        [VC.tabBarItem setTitle:Titles[i]];
        //设置文字属性
        [VC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:W_BackColor} forState:UIControlStateSelected];
        VC.isMainView = YES;
        VC.leftBtnBlock = ^{
            [self panWay:nil];
        };
        
        [VC_models addObject:navi];
    }
    self.viewControllers = VC_models;
}


@end

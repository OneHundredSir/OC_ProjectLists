//
//  BillManageViewController.m
//  SP2P_7
//
//  Created by Jerry on 15/6/17.
//  Copyright (c) 2015年 EIMS. All rights reserved.
//

#import "BillManageViewController.h"
#import "ColorTools.h"

#import "FinancialBillsViewController.h"
#import "BorrowingBillViewController.h"
#import "TabViewController.h"

@interface BillManageViewController ()

@property (nonatomic ,strong) FinancialBillsViewController *finacialBillView;
@property (nonatomic ,strong) BorrowingBillViewController *borrowBillView;

@property (nonatomic ,strong) UIViewController *currentVC;

@end

@implementation BillManageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 初始化数据
    [self initData];
    
    // 初始化视图
    [self initView];
}

/**
 * 初始化数据
 */
- (void)initData
{
    
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //待改判断企业个人
    UIButton *transferBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (AppDelegateInstance.userInfo != nil) {
        if (AppDelegateInstance.userInfo.registerType == 1) {
            transferBtn.frame = CGRectMake(0, 64, MSWIDTH/2, 40);
            [transferBtn setBackgroundImage:[UIImage imageNamed:@"btn_green_bg"] forState:UIControlStateSelected];
            
        }else if(AppDelegateInstance.userInfo.registerType == 0)
        {
            transferBtn.frame = CGRectMake(0, 64, MSWIDTH, 40);

        }
    }
//    transferBtn.frame = CGRectMake(0, 64, MSWIDTH, 40);
    [transferBtn setTitle:@"理 财" forState:UIControlStateNormal];
    transferBtn.titleLabel.font =  [UIFont fontWithName:@"Arial-BoldMT" size:16.0],
    [transferBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [transferBtn setTitleColor:KColor forState:UIControlStateSelected];
    transferBtn.selected = YES;
    [transferBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    [transferBtn setBackgroundImage:[UIImage imageNamed:@"btn_green_bg"] forState:UIControlStateSelected];
    transferBtn.tag = 1;
    [transferBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:transferBtn];
    
    UIButton *assigneeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    assigneeBtn.frame = CGRectMake( MSWIDTH*0.5, 64, MSWIDTH*0.5, 40);
    [assigneeBtn setTitle:@"借 款" forState:UIControlStateNormal];
    assigneeBtn.titleLabel.font =  [UIFont fontWithName:@"Arial-BoldMT" size:16.0],
    [assigneeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [assigneeBtn setTitleColor:KColor forState:UIControlStateSelected];
    [assigneeBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [assigneeBtn setBackgroundImage:[UIImage imageNamed:@"btn_green_bg"] forState:UIControlStateSelected];
    assigneeBtn.tag = 2;
    [assigneeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
  
    if (AppDelegateInstance.userInfo != nil) {
        if (AppDelegateInstance.userInfo.registerType == 1) {
            
            [self.view addSubview:assigneeBtn];
        }
    }
    
    
    _finacialBillView = [[FinancialBillsViewController alloc] init];
    _finacialBillView.view.frame = CGRectMake(0, 104, self.view.frame.size.width, self.view.frame.size.height);
    [self addChildViewController:_finacialBillView];
    
    
    _borrowBillView = [[BorrowingBillViewController alloc] init];
    _borrowBillView.view.frame = CGRectMake(0, 104, self.view.frame.size.width, self.view.frame.size.height);
    [self addChildViewController:_borrowBillView];
    [self.view addSubview:_borrowBillView.view];
    
      [self.view addSubview:_finacialBillView.view];
    
    self.currentVC =_finacialBillView;
    
}

/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"账单";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    
    
    // 导航条返回按钮
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    leftItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:leftItem];
}


//切换视图控制器
- (void)btnClick:(UIButton *)btn
{
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:1];
    UIButton *btn2 = (UIButton *)[self.view viewWithTag:2];
    
    
    if ((self.currentVC == _finacialBillView && [btn tag] == 1) || (self.currentVC == _borrowBillView && [btn tag] == 2)) {
        return;
    }
    switch ([btn tag]) {
        case 1:
        {
            [self replaceController:self.currentVC newController:self.finacialBillView];
        }
            break;
        case 2:
        {
            [self replaceController:self.currentVC newController:self.borrowBillView];
        }
            break;
    }
    
    if (btn1.selected) {
        btn1.selected = !btn1.selected;
        btn2.selected = YES;
    }
    else
    {
        btn1.selected = !btn1.selected;
        btn2.selected = NO;
    }
    
}


- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController
{
    
    [self addChildViewController:newController];
    
    [self transitionFromViewController:oldController toViewController:newController duration:0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished)
     {
         if (finished) {
             
             [newController didMoveToParentViewController:self];
             
             if(oldController !=nil){
                 [oldController willMoveToParentViewController:nil];
                 [oldController removeFromParentViewController];
             }
             
             self.currentVC = newController;
             
         }else{
             
             self.currentVC = oldController;
             
         }
     }];
    
}

#pragma 返回按钮触发方法
- (void)backClick
{
    //    [self dismissViewControllerAnimated:YES completion:^(){}];
//    TabViewController *tabViewController = [[TabViewController alloc] init];
    TabViewController *tabViewController = [TabViewController shareTableView];
    [self.frostedViewController presentMenuViewController];
    self.frostedViewController.contentViewController = tabViewController;
    
}

@end

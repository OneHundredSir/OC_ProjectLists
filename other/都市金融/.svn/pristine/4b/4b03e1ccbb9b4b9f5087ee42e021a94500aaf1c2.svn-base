//
//  TabViewController.m
//  SP2P_7
//
//  Created by 李小斌 on 14-6-6.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "TabViewController.h"

#import "HomeViewController.h"
#import "InvestmentViewController.h"
#import "LoanViewController.h"
#import "TransferViewController.h"
#import "InformationViewController.h"
#import "AJAccountController.h"

#import "InfromationTabViewController.h"

#import "BarButtonItem.h"
#import "ColorTools.h"

#import "NavigationController.h"
#import "LoginViewController.h"
@interface TabViewController ()<UITabBarControllerDelegate>
@property (nonatomic,strong)UIImageView *tabBarView;
@end

@implementation TabViewController

+(TabViewController*)shareTableView
{
    static TabViewController *_shareTableView = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _shareTableView = [[TabViewController alloc] init];
        
    });
    return _shareTableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBar.hidden = NO;
    self.delegate = self;
    HomeViewController *homeVc = [[HomeViewController alloc] init];
    homeVc.view.backgroundColor = [UIColor whiteColor];
    
    InvestmentViewController *investmentVc = [[InvestmentViewController alloc] init];
    investmentVc.view.backgroundColor = KblackgroundColor;
    
//    LoanViewController *loanVc = [[LoanViewController alloc] init];
//    loanVc.view.backgroundColor = [UIColor whiteColor];
    
    TransferViewController *transferVc = [[TransferViewController alloc] init];
    transferVc.view.backgroundColor = KblackgroundColor;
    
    AJAccountController *account = [[AJAccountController alloc] initWithStyle:UITableViewStylePlain];
    transferVc.view.backgroundColor = KblackgroundColor;
//    InfromationTabViewController *tabVc = [[InfromationTabViewController alloc] init];
//    InformationViewController *informationVc = [[InformationViewController alloc] init];
//    homeVc.adScrollView.InformationVC =(InformationViewController *)informationVc;
//    [informationVc setViewControllers:@[[[UINavigationController alloc] initWithRootViewController:tabVc]]];
//    informationVc.view.backgroundColor = [UIColor clearColor];
    
    NavigationController *homeNV= [[NavigationController alloc] initWithRootViewController:homeVc];
    NavigationController *investmentNV = [[NavigationController alloc] initWithRootViewController:investmentVc];
    NavigationController *transferVN = [[NavigationController alloc] initWithRootViewController:transferVc];
    NavigationController *accountNav = [[NavigationController alloc] initWithRootViewController:account];
    
    NSMutableArray *controllers = [[NSMutableArray alloc]init];
    [controllers addObject:homeNV];
    [controllers addObject:investmentNV];
    [controllers addObject:transferVN];
    [controllers addObject:accountNav];
//    [controllers addObject:informationVN];
    
    self.tabBar.tintColor = GreenColor;
    self.viewControllers = controllers;
    self.selectedIndex = 0;
    
    UITabBarItem *tabBarItem0 = [self.tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem1 = [self.tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem2 = [self.tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem3 = [self.tabBar.items objectAtIndex:3];

    
    tabBarItem0.title = NSLocalizedString(@"Tab_Home", nil);
    tabBarItem1.title = NSLocalizedString(@"Tab_Investment", nil);
    tabBarItem2.title = NSLocalizedString(@"Tab_Transfer", nil);
    tabBarItem3.title = NSLocalizedString(@"Tab_Account", nil);
    
    [tabBarItem0 setImage:[UIImage imageNamed:@"tabbar_home_unselected"]];
    [tabBarItem0 setSelectedImage:[UIImage imageNamed:@"tabbar_home_selected"]];
    [tabBarItem1 setImage:[UIImage imageNamed:@"tabbar_invest_unselected"]];
    [tabBarItem1 setSelectedImage:[UIImage imageNamed:@"tabbar_invest_selected"]];
    [tabBarItem2 setImage:[UIImage imageNamed:@"tabbar_debt_unselected"]];
    [tabBarItem2 setSelectedImage:[UIImage imageNamed:@"tabbar_debt_selected"]];
    [tabBarItem3 setImage:[UIImage imageNamed:@"tabbar_account_unselected"]];
    [tabBarItem3 setSelectedImage:[UIImage imageNamed:@"tabbar_account_selected"]];

}
- (void)leftClick:(id)sender{
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ( self.viewControllers[3] == viewController) {
        // 未登录不让跳转到账户中心,弹出登录界面
        if (AppDelegateInstance.userInfo == nil)
        {
            [ReLogin outTheTimeRelogin:self];
            return NO;
        }
       
    }
    return YES;
}
@end

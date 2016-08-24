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

#import "InfromationTabViewController.h"

#import "BarButtonItem.h"
#import "ColorTools.h"

@interface TabViewController ()
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
    
    HomeViewController *homeVc = [[HomeViewController alloc] init];
    homeVc.view.backgroundColor = [UIColor whiteColor];
    
    InvestmentViewController *investmentVc = [[InvestmentViewController alloc] init];
    investmentVc.view.backgroundColor = KblackgroundColor;
    
//    LoanViewController *loanVc = [[LoanViewController alloc] init];
//    loanVc.view.backgroundColor = [UIColor whiteColor];
    
    TransferViewController *transferVc = [[TransferViewController alloc] init];
    transferVc.view.backgroundColor = KblackgroundColor;
    
//    InfromationTabViewController *tabVc = [[InfromationTabViewController alloc] init];
//    InformationViewController *informationVc = [[InformationViewController alloc] init];
//    homeVc.adScrollView.InformationVC =(InformationViewController *)informationVc;
//    [informationVc setViewControllers:@[[[UINavigationController alloc] initWithRootViewController:tabVc]]];
//    informationVc.view.backgroundColor = [UIColor clearColor];
    
    UINavigationController *homeNV= [[UINavigationController alloc] initWithRootViewController:homeVc];
    UINavigationController *investmentNV = [[UINavigationController alloc] initWithRootViewController:investmentVc];
//    UINavigationController *loanVN= [[UINavigationController alloc] initWithRootViewController:loanVc];
    UINavigationController *transferVN = [[UINavigationController alloc] initWithRootViewController:transferVc];
//    UINavigationController *informationVN= [[UINavigationController alloc] initWithRootViewController:informationVc];
    
    [self initNavigationBar:homeNV];
    [self initNavigationBar:investmentNV];
//    [self initNavigationBar:loanVN];
    [self initNavigationBar:transferVN];
//    [self initNavigationBar:informationVN];
    
    
    NSMutableArray *controllers = [[NSMutableArray alloc]init];
    [controllers addObject:homeNV];
    [controllers addObject:investmentNV];
//    [controllers addObject:loanVN];
    [controllers addObject:transferVN];
//    [controllers addObject:informationVN];
    
    
    self.tabBar.tintColor = GreenColor;
    self.viewControllers = controllers;
    self.selectedIndex = 0;
    
    
    UITabBarItem *tabBarItem0 = [self.tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem1 = [self.tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem2 = [self.tabBar.items objectAtIndex:2];
//    UITabBarItem *tabBarItem3 = [self.tabBar.items objectAtIndex:3];
//    UITabBarItem *tabBarItem4 = [self.tabBar.items objectAtIndex:4];

    
    tabBarItem0.title = NSLocalizedString(@"Tab_Home", nil);
    tabBarItem1.title = NSLocalizedString(@"Tab_Investment", nil);
    tabBarItem2.title = NSLocalizedString(@"Tab_Transfer", nil);
//    tabBarItem3.title = NSLocalizedString(@"Tab_Transfer", nil);
//    tabBarItem4.title = NSLocalizedString(@"Tab_Infromation", nil);
//    
    
    
    [tabBarItem0 setImage:[UIImage imageNamed:@"tab_home"]];
    [tabBarItem1 setImage:[UIImage imageNamed:@"tab_investment"]];
    [tabBarItem2 setImage:[UIImage imageNamed:@"tab_transfer"]];
//    [tabBarItem3 setImage:[UIImage imageNamed:@"tab_transfer"]];
//    [tabBarItem4 setImage:[UIImage imageNamed:@"tab_information"]];

}

- (void)initNavigationBar:(UINavigationController *)navigationController
{
    [navigationController.navigationBar setBarTintColor:KColor];
}

- (void)leftClick:(id)sender{
    
}

@end

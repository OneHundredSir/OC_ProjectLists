//
//  InvestmentViewController.m
//  SP2P_6.0
//
//  Created by 李小斌 on 14-6-4.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  我要投资
//
#import "InvestmentViewController.h"

//#import "BarButtonItem.h"
#import "ColorTools.h"

//#import "SortItem.h"
//#import "SortItemGrop.h"
//#import "InvestmentTableViewCell.h"

//#import "Investment.h"
//#import "BorrowingDetailsViewController.h"
//#import "InterestcalculatorViewController.h"
//#import "ScreenViewOneController.h"
//#import "AppDelegate.h"
//#import "CacheUtil.h"
//#import "LoginViewController.h"
//#import "TenderOnceViewController.h"
#import "AJSearchBar.h"
#import "AJInvestRecommendCell.h"
#import "AJInvestCell.h"
#import "JSONKit.h"
#import "AJInvestChildController.h"
#import "SCNavTabBarController.h"

#define kSortHeight 40.0
#define kMenuH 73.f/2
#define kNomalPageTitleColor @"#c8c8c8"
#define kIS_IOS7                (kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_6_1)

extern NSString *headertitle;

@interface InvestmentViewController ()</*UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate,HTTPClientDelegate,UITextFieldDelegate,*/UITextFieldDelegate ,SCNavTabBarControllerDelegate>
@property(nonatomic, strong) NSArray *items;
@property (nonatomic, strong)NSArray *loanTypes;
@property (nonatomic, weak) AJSearchBar *searchBar;
@end

@implementation InvestmentViewController

- (NSArray *)loanTypes
{
    // 投资专区opt=10——全部标列表  loanType=-1；稳赢宝列表loanType=5；商理宝列表loanType=null；新手专享区列表 loanType=7
    if (_loanTypes==nil) {
        _loanTypes = @[@"-1", @"null", @"9", @"7"];
    }
    return _loanTypes;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addChildController];
    // 初始化视图
    [self initView];
}

/**
 * 输入框文字改变时发送搜索请求
 */
- (void)searchWithNewKeyWords:(NSNotification *)noti
{
    DLOG(@"%@", noti);
    [self searchBarSearchButtonClicked:[noti valueForKeyPath:@"object.text"]];
}

- (void)addChildController
{
    NSArray *items = @[@"全部",@"稳赢宝",@"商理宝",@"新手专享区"];
    // 四个列表
    NSMutableArray *arrTemp = [NSMutableArray array];
    for (int i = 0; i < items.count; i++) {
        AJInvestChildController *controller = [[AJInvestChildController alloc] initWithStyle:UITableViewStyleGrouped];
        controller.title = items[i];
        [controller setValue:self.loanTypes[i] forKey:@"loanType"];
        [arrTemp addObject:controller];
    }
    SCNavTabBarController *navTabBarController = [[SCNavTabBarController alloc] init];
    navTabBarController.delegate = self;
    navTabBarController.subViewControllers = arrTemp;
    //    navTabBarController.showArrowButton = YES;
    navTabBarController.scrollAnimation = YES;
    navTabBarController.mainViewBounces = YES;
    navTabBarController.navTabBarColor = [UIColor whiteColor];
    [navTabBarController addParentController:self];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/**
 初始化数据
 */
- (void)initView
{
    //搜索
    UIView *titleV = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, {440/2, 58/2}}];
    titleV.backgroundColor = [UIColor clearColor];
    __weak typeof(self) weakSelf = self;
    AJSearchBar *bar = [[AJSearchBar alloc] initWithFrame:titleV.bounds searchBlock:^(AJSearchBar *bar) {
        if (bar.text.length) {
            [weakSelf searchBarSearchButtonClicked:bar.text];  //关键字	借款标题或编号
        }else{
             [weakSelf searchBarSearchButtonClicked:@""];   //关键字	借款标题或编号
        }

    }];
    bar.delegate = self;
    NSDictionary *attr = @{NSForegroundColorAttributeName: SETCOLOR(235, 235, 235, 1),
                           NSFontAttributeName:[UIFont systemFontOfSize:17] };
    bar.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入标题" attributes:attr];
    [titleV addSubview:bar];
    self.searchBar = bar;
    self.navigationItem.titleView = titleV;
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(searchWithNewKeyWords:) name:UITextFieldTextDidChangeNotification object:self.searchBar];

    
    // 提取搜索框，空值也可以点击软键盘搜索键
}

#pragma  mark - SCNavTabBarControllerDelegate
- (void)SCNavTabBarController:(SCNavTabBarController *)navTabBarController didSelectedSubController:(UIViewController *)subController
{
    NSArray *dataArr = [subController valueForKey:@"DataArray"];
    for (UITableViewController *controller in navTabBarController.subViewControllers) {
        controller.tableView.scrollsToTop = NO;
    }
    UITableView *tableView = [subController valueForKey:@"tableView"];
    tableView.scrollsToTop = YES;
    if (dataArr.count == 0) {
        [tableView headerBeginRefreshing];
    }
}

#pragma  mark - UITextFieldDelegate 开始搜索
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchBarSearchButtonClicked:textField.text];
    return YES;
}
#pragma 搜索点击触发方法
- (void)searchBarSearchButtonClicked:(NSString *)keywords;
{
    // 让子控制器去所搜显示
    SCNavTabBarController *navTabBarController = (SCNavTabBarController*)self.childViewControllers.firstObject;
    AJInvestChildController *child = navTabBarController.subViewControllers[navTabBarController.navTabBar.currentItemIndex];
    [child searchBidsWithKeywords:keywords];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end

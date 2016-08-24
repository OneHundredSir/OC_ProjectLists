//
//  ExtensionBaseViewController.m
//  SP2P_7
//
//  Created by Cindy on 15/10/22.
//  Copyright (c) 2015年 EIMS. All rights reserved.
//

#import "ExtensionBaseViewController.h"
#import "ExtensionMemberViewController.h"

@interface ExtensionBaseViewController ()<ViewPagerDataSource, ViewPagerDelegate>
{
    NSMutableArray *tipLists;
}
@property (nonatomic) NSUInteger numberOfTabs;
@property (nonatomic, strong)ExtensionMemberViewController *extensionVC1;
@property (nonatomic, strong)ExtensionMemberViewController *extensionVC2;
@property (nonatomic, strong)ExtensionMemberViewController *extensionVC3;

@end

@implementation ExtensionBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavigationBar];
    [self initView];
}

- (void)initView
{
    tipLists = [NSMutableArray array];
    
    self.dataSource = self;
    self.delegate = self;
    
    [self loadContent];
    [self selectTabWithNumberFive];
}

#pragma mark - Setters
- (void)setNumberOfTabs:(NSUInteger)numberOfTabs {
    
    // Set numberOfTabs
    _numberOfTabs = numberOfTabs;
    
    // Reload data
    [self reloadData];
    
}

#pragma mark - Helpers
- (void)selectTabWithNumberFive {
    [self selectTabAtIndex:0];
}

- (void)loadContent {
    self.numberOfTabs = 3;
}

#pragma mark - Interface Orientation Changes
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    // Update changes after screen rotates
    [self performSelector:@selector(setNeedsReloadOptions) withObject:nil afterDelay:duration];
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return self.numberOfTabs;
}

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    switch (index) {
        case 0:
            label.text = @"一级推广会员";
            break;
        case 1:
            label.text = @"二级推广会员";
            break;
        case 2:
            label.text = @"三级推广会员";
            break;
        default:
            break;
    }
    [label sizeToFit];
    
    [tipLists addObject:label];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    
    if (index == 0) {
        
        if(!_extensionVC1)
        {
            _extensionVC1 = [[ExtensionMemberViewController alloc]init];
            _extensionVC1.type = 1;
        }
        return _extensionVC1;
    }
    else if (index == 1)
    {
        if(!_extensionVC2)
        {
            _extensionVC2 = [[ExtensionMemberViewController alloc]init];
            _extensionVC2.type = 2;
        }
        return _extensionVC2;
    }
    else
    {
        if(!_extensionVC3)
        {
            _extensionVC3 = [[ExtensionMemberViewController alloc]init];
            _extensionVC3.type = 3;
        }
        return _extensionVC3;
    }
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 1.0;
        case ViewPagerOptionCenterCurrentTab://如果要选中的中间视图，设置为1.0，其他两个设置为0
            return 0.0;
        case ViewPagerOptionTabLocation:
            return 1.0;
        case ViewPagerOptionTabHeight://滚动条高度
            return 42;
        case ViewPagerOptionTabOffset://滚动条x起始坐标
            return 0.0;
        case ViewPagerOptionTabWidth://选项宽度
            return UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? self.view.frame.size.width/3 : self.view.frame.size.width/3;
        default:
            return value;
    }
}
- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return [KColor colorWithAlphaComponent:0.8];//选中条颜色及alpha
        case ViewPagerTabsView:
            return [[UIColor whiteColor] colorWithAlphaComponent:1.0];//滑动条背景颜色及alpha
        case ViewPagerContent:
            return [[UIColor whiteColor] colorWithAlphaComponent:1.0];//视图背景颜色及alpha
        default:
            return color;
    }
}

- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index
{
    DLOG(@"%ld",(unsigned long)index);
    
    for(NSInteger i = 0;i < tipLists.count;i++)
    {
        UILabel *selectLB = [tipLists objectAtIndex:i];
        if(i == index)
        {
            
            selectLB.textColor = KColor;
        }
        else
        {
            selectLB.textColor = [UIColor blackColor];
        }
    }
}


#pragma mark - NavigationBar
- (void)initNavigationBar
{
    self.title = @"成功推广的会员";
    [self.view setBackgroundColor:KblackgroundColor];
    
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:19.0], NSFontAttributeName, nil]];
    
    // 导航条 左边 返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
}

#pragma 返回按钮触发方法
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end

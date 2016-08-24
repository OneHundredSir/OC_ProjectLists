//
//  MainViewController.m
//  Flower
//
//  Created by HUN on 16/7/7.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "MainViewController.h"
#import "MenuView.h"
@interface MainViewController ()
@property(nonatomic,strong)MenuView *menuView;
@end

@implementation MainViewController

#pragma mark lazyload
-(MenuView *)menuView
{
    if (_menuView == nil) {
        _menuView = [[[NSBundle mainBundle] loadNibNamed:@"MenuView" owner:nil options:nil] lastObject];
    }
    return _menuView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self _initView];
   
}

/**
 *  初始化页面
 */
-(void)_initView
{
    //设置左边
    [self setLeftBtnIcon:@"menu" andLeftBtnSeletdIcon:nil];
    //设置菜单栏
    NSArray *arr = @[@"家具庭院",@"缤纷小物",@"奇葩之物",@"花田秘籍",@"跨界鉴赏",@"城市微光"];
    MenuView *menuView = self.menuView;
    CGFloat menuY = k_navigationbarH+k_statusH;
    CGFloat menuH = k_height - k_tabbarH - k_navigationbarH - k_statusH -60;
    CGFloat menuW = k_width;
    menuView.frame = (CGRect){0,-menuH,menuW,menuH};
    NSLog(@"%@",NSStringFromCGRect(menuView.frame));
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    [menuView _setScrollViewWithTitleArray:arr];
    menuView.btnBlock = ^(UIButton *btn)
    {
        NSInteger index =  btn.tag-10;
        if (index == 0)//@"家具庭院"
        {
            NSLog(@"家具庭院");
        }else if (index == 1)//@"缤纷小物"
        {
            NSLog(@"缤纷小物");
        }else if (index == 2)//@"奇葩之物"
        {
            NSLog(@"奇葩之物");
        }else if (index == 3)//@"花田秘籍"
        {
            NSLog(@"花田秘籍");
        }else if (index == 4)//@"跨界鉴赏"
        {
            NSLog(@"跨界鉴赏");
        }else if (index == 4)//@"城市微光"
        {
            NSLog(@"城市微光");
        }
        
    };
//    menuView.center = (CGPoint){self.view.center.x,-self.view.center.y};
    [self.view addSubview:menuView];
    
    //联合设置菜单栏按钮事件
    self.leftBtnBlock = ^(UIButton *btn){
        btn.selected = !btn.selected;

        //设置位移事件，唯一问题就是设置按钮的宽度高度要一致
        [UIView animateWithDuration:0.3 animations:^{
            menuView.transform = btn.selected?CGAffineTransformMakeTranslation(0, menuY+menuH):CGAffineTransformIdentity;
            btn.transform = btn.selected?CGAffineTransformMakeRotation(M_PI/2.0):CGAffineTransformIdentity;
        }];
        
        
        
            
        
        
    };
    
    //设置右边
     [self setRightBtn:nil andTitle:@"Top"];
    self.rightBtnBlock = ^(UIButton *btn){
        
    };
}




@end

//
//  BeginViewController.m
//  FootLove
//
//  Created by HUN on 16/6/27.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "BeginViewController.h"

@interface BeginViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *MyScrollView;

@property(nonatomic,strong)UIPageControl *page;
@end

@implementation BeginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark 设置轮播
-(void)_initWithImageWithFrame:(CGRect)rect
{
    self.view.frame = rect;
    _MyScrollView.pagingEnabled = YES;
    _MyScrollView.delegate=self;
    _MyScrollView.showsHorizontalScrollIndicator = NO;
    _MyScrollView.showsVerticalScrollIndicator = NO;
    NSInteger num = 3;
    _MyScrollView.contentSize = (CGSize){k_width *num,k_height};
    for (int i=0; i<num; i++)
    {

        UIImageView *imgView = [[UIImageView alloc]initWithFrame:(CGRect){k_width*i,0,k_width,k_height}];
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"gp_bg_%d",i]];
        if (i == 2)//最后一页家按钮
        {
            CGFloat BtnW = 150;
            CGFloat BtnH = 40;
            CGFloat maginY =10;
            UIButton *btn=[[UIButton alloc]initWithFrame:(CGRect){k_width/2.0 - BtnW/2.0,k_height - BtnH -maginY,BtnW,BtnH}];
//            btn.backgroundColor=[UIColor redColor];//测试方位用的
            [btn addTarget:self action:@selector(btnWay:) forControlEvents:UIControlEventTouchUpInside];
            //需要设置用户交互，图片默认不交互的
            [imgView setUserInteractionEnabled:YES];
            [imgView addSubview:btn];
        }
        [_MyScrollView addSubview:imgView];
    }
    
    //设置pageviewcontroller
 
    CGFloat pagemaginY = 10;
    UIPageControl *page = [[UIPageControl alloc]init];
    CGSize pageSize = [page sizeForNumberOfPages:num];
//    NSLog(@"rect:%@ ,center%@",NSStringFromCGRect(self.view.frame),NSStringFromCGPoint(self.view.center));
//    NSLog(@"%@",NSStringFromCGSize(pageSize));
//    NSLog(@"%lf",self.view.center.x - pageSize.width/2.0);
    page.frame = (CGRect){self.view.center.x - pageSize.width/2.0,pagemaginY,pageSize.width,pageSize.height};
    page.numberOfPages=num;
    _page = page;
    page.currentPage = 0;//设置初始页
    
    page.pageIndicatorTintColor = [UIColor whiteColor];
    page.currentPageIndicatorTintColor = [UIColor redColor];
    [self.view addSubview:page];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _page.currentPage = scrollView.contentOffset.x/k_width;
}

#pragma mark 按钮实现的方法
-(void)btnWay:(UIButton *)btn
{
    //用block传过去;
    if (_MyBtn) {
        _MyBtn();
    }
}

@end

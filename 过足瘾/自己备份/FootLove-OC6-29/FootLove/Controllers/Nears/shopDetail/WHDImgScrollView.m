//
//  WHDImgScrollView.m
//  FootLove
//
//  Created by HUN on 16/6/29.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDImgScrollView.h"
#import <UIButton+WebCache.h>
@interface  WHDImgScrollView ()
#pragma mark scrollView
@property(nonatomic,weak)UIScrollView *myscrollView;

#pragma mark pageView
@property(nonatomic,weak)UIPageControl *myPageView;

#pragma mark 设置定时器
@property(nonatomic,weak)NSTimer *timer;

#pragma mark 当前选中页
@property(nonatomic,assign)NSInteger seletedPageNum;

@property(nonatomic,assign)NSInteger totolNum;


#pragma mark label显示用的
@property(nonatomic,weak)UILabel *myLabel;

@end

@implementation WHDImgScrollView


#pragma mark 对外借口


-(void)initwhdSetAdViewWithImgUrlArr:(NSArray *)ImgUrlArr
{
    [self configSrcollView];
    self.myscrollView.contentSize = (CGSize){W_width*ImgUrlArr.count,CGRectGetHeight(self.frame)};
    self.myscrollView.showsHorizontalScrollIndicator = NO;
    self.myscrollView.showsVerticalScrollIndicator = NO;
    self.totolNum = ImgUrlArr.count;
    for (int i=0; i<ImgUrlArr.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(W_width*i, 0, W_width, CGRectGetHeight(self.frame))];
        [btn setImageWithURL:[NSURL URLWithString:ImgUrlArr[i]] forState:UIControlStateNormal];
        btn.userInteractionEnabled = NO;
        btn.tag = i+10;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.myscrollView addSubview:btn];
    }
//    //设置pageview的数目
//    [self configPageView];
//    self.myPageView.numberOfPages = ImgUrlArr.count;
    
    //设置页面就可以了不用pageview
    [self configLabel];
    
    //开启定时器
    [self _initWHDTimer];
}

/**
 *  各个页面的按钮，按照按钮的顺序+10的标志
 */
-(void)btnAction:(UIButton *)btn
{
    NSLog(@"-->");
}

#pragma mark - 设置定时器
-(void)_initWHDTimer
{
    NSTimer *myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    self.timer = myTimer;
}

-(void)timerAction:(NSTimer *)timer
{
    _seletedPageNum ++ ;
    if (_seletedPageNum == self.totolNum) {
        _seletedPageNum = 0;
    }
    [self pageViewAction:nil];
}

#pragma mark - lazyload
-(UIScrollView *)myscrollView
{
    if (_myscrollView == nil) {
        [self configSrcollView];
    }
    return _myscrollView;
}

-(UIPageControl *)myPageView
{
    if (_myPageView == nil)
    {
        [self configPageView];
    }
    return _myPageView;
}

#pragma mark - 页面呈现的时候
-(void)awakeFromNib
{
    
}
#pragma mark - 配置Scrollview
/**
 *  初始化SrcollView
 */
-(void)configSrcollView
{
    //高度和宽度和view一样就可以了
    UIScrollView *scrollView =[ [UIScrollView alloc]initWithFrame:(CGRect){0,0,W_width,CGRectGetHeight(self.frame)}];
    scrollView.pagingEnabled = YES;
    _myscrollView = scrollView;
    //这里为什么不能设置代理
    _myscrollView.delegate = self;
    [self addSubview:scrollView];
    
}

#pragma mark delegate
//由于设置了定时器，定时器的启停
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //关闭定时器
    [self.timer fire];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self _initWHDTimer];
}

//滑动的时候
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //超过一半的时候进行
    if (self.myPageView) {
        self.myPageView.currentPage = scrollView.contentOffset.x/W_width + 0.5;
        _seletedPageNum = self.myPageView.currentPage;
    }else
    {
        _seletedPageNum = scrollView.contentOffset.x/W_width + 0.5;
    }
    
    _myLabel.text = [NSString stringWithFormat:@"%d/%d",_seletedPageNum,_totolNum];
    
}


#pragma mark - 配置pageView
/**
 *  初始化pageView
 */
-(void)configPageView
{
    CGFloat PG_height = 30;
    UIPageControl *pageView = [[UIPageControl alloc]initWithFrame:(CGRect){0,CGRectGetHeight(self.frame)-PG_height,W_width,PG_height}];
    [pageView addTarget:self action:@selector(pageViewAction:) forControlEvents:UIControlEventValueChanged];
    pageView.pageIndicatorTintColor = [UIColor whiteColor];
    pageView.currentPageIndicatorTintColor = [UIColor redColor];
    _myPageView = pageView;
    [self addSubview:_myPageView];
}

-(void)pageViewAction:(UIPageControl *)pageControl
{
    if (pageControl) {
        [_myscrollView setContentOffset:CGPointMake(pageControl.currentPage * W_width, 0) animated:YES];
    }else
        [_myscrollView setContentOffset:CGPointMake(_seletedPageNum * W_width, 0) animated:YES];
    
}

#pragma mark - 配置label
-(void)configLabel
{
    CGSize Lb_size = [@"10000/10000" sizeWithFont:W_font(14) constrainedToSize:(CGSize){CGFLOAT_MAX,CGFLOAT_MAX}];
    CGFloat magin = 10;
    UILabel *label = [[UILabel alloc]initWithFrame:(CGRect){CGRectGetWidth(self.frame)-Lb_size.width-magin,CGRectGetHeight(self.frame)-magin-Lb_size.height,Lb_size.width,Lb_size.height}];
    label.textAlignment = NSTextAlignmentRight;
    label.text = [NSString stringWithFormat:@"%f/%d",_myscrollView.contentOffset.x/CGRectGetWidth(self.frame),_totolNum];
    _myLabel = label;
    [self addSubview:label];
    
    
}

@end

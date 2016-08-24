//
//  AJHomeHeaderView.m
//  SP2P_7
//
//  Created by Ajax on 16/1/14.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "AJHomeHeaderView.h"

@interface AJHomeHeaderView ()<FocusImageFrameDelegate>
@property (nonatomic, weak) AdScrollView *adScrollView;

@property (nonatomic, weak) UIButton *login;
@property (nonatomic, weak) UIButton *registerbtn;

@end

@implementation AJHomeHeaderView

- (instancetype)initWithHeight:(CGFloat)height imageItems:(NSArray *)items
{
    CGRect frame = CGRectMake(0, 0, 0, height);
    if (self = [super initWithFrame:frame]) {
        // 顶部广告业
        CGRect adScrollViewF = CGRectMake(0, 0, MSWIDTH,height - (30 + 80)/2.f);// 宽度不根据Frame调整
        AdScrollView *adScrollView = [[AdScrollView alloc] initWithFrame:adScrollViewF delegate:self imageItems:items];
        self.adScrollView = adScrollView;
        [self addSubview:adScrollView];
        adScrollView.contentMode =  UIViewContentModeScaleAspectFit;
        
        // 登录注册按钮
        [self initLoginRegisterView];
    }
    return self;
}

- (void)initLoginRegisterView
{
    // 登录注册按钮
    UIView *loginRegister = [[UIView alloc] init];
    [self addSubview:loginRegister];
    loginRegister.backgroundColor = [UIColor clearColor];
    self.loginRegister = loginRegister;
    // 登录按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"home_login"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"登录" forState:UIControlStateNormal];
    self.login = btn;
    [loginRegister addSubview:btn];
    [btn addTarget:self action:@selector(loginRegisterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    // 注册按钮
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"home_register"] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 setTitle:@"注册" forState:UIControlStateNormal];
    [loginRegister addSubview:btn2];
    [btn2 addTarget:self action:@selector(loginRegisterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.registerbtn = btn2;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
      // 顶部广告业初始化已经设置
    // 登录注册按钮
    CGFloat selfW = self.bounds.size.width;
    CGFloat loginRegisterW = selfW - 2*10;
    CGFloat loginRegisterH = 80.f/2;
    self.loginRegister.frame = CGRectMake(10.f, CGRectGetMaxY(self.adScrollView.frame)+30/2.f, loginRegisterW, loginRegisterH);
    self.login.frame = CGRectMake(0, 0, loginRegisterW/2, loginRegisterH);
    self.registerbtn.frame = CGRectMake(CGRectGetMaxX(self.login.frame), 0, loginRegisterW/2, loginRegisterH);
}
- (void)loginRegisterBtnClick:(UIButton *)sender
{
    self.loginRegisterBlock(sender);
}
#pragma mark - FocusImageFrameDelegate
- (void)foucusImageFrame:(AdScrollView *)imageFrame didSelectItem:(AdvertiseGallery *)item
{
    self.tapImgBlock(item);
}

- (void)foucusImageFrame:(AdScrollView *)imageFrame currentItem:(int)index
{
    //DLOG(@"当前广告图片%d",index);
}
- (void)updateViewsContent:(NSArray *)aArray
{
    [self.adScrollView changeImageViewsContent:aArray];
}
@end

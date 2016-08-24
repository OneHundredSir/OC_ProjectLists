//
//  PushAlertView.m
//  SP2P_6.1
//
//  Created by kiu on 14/11/27.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "PushAlertView.h"
#import "ColorTools.h"

@interface PushAlertView ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *alertTitleLabel;             // 标题
@property (nonatomic, strong) UILabel *alertCollectCapitalLabel;    // 原待收金额
@property (nonatomic, strong) UILabel *alertHightestBidLabel;       // 竞拍最高价
@property (nonatomic, strong) UILabel *alertOfferPriceLabel;        // 我的竞价
@property (nonatomic, strong) UILabel *alertNewPriceLabel;          // 新的竞价

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *backImageView;

@end

@implementation PushAlertView

#define kAlertWidth 260.0f// 对话框的宽
#define kAlertHeight 220.0f// 对话框的高

#define kAlertBtnWidth 100.0f// 对话框 Button 的宽262
#define kAlertBtnHeight 25.0f// 对话框 Button 的高153

- (id)initWithTitle:(NSString *)title collectCapitalText:(NSString *)collectCapital hightestBidText:(NSString *)hightestBid offerPriceText:(NSString *)offerPrice leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rigthTitle
{
    if (self = [super init])
    {
        self.backgroundColor = [UIColor whiteColor];
        
        self.alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 , 0, kAlertWidth, 30)];
        self.alertTitleLabel.font = [UIFont systemFontOfSize:16.0f];
        self.alertTitleLabel.textColor = [UIColor whiteColor];
        self.alertTitleLabel.backgroundColor = KColor;
        self.alertTitleLabel.textAlignment =  NSTextAlignmentCenter;
        [self addSubview:self.alertTitleLabel];
        
        for (int i = 0; i < 4; i ++) {
            UILabel *maneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 40 + i * 25, 15, 24)];
            maneyLabel.font = [UIFont systemFontOfSize:12.0f];
            maneyLabel.textColor = [UIColor blackColor];
            maneyLabel.text = @"元";
            maneyLabel.textAlignment =  NSTextAlignmentLeft;
            [self addSubview:maneyLabel];
        }
        
        
        self.alertCollectCapitalLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 40, 200, 24)];
        self.alertCollectCapitalLabel.font = [UIFont systemFontOfSize:12.0f];
        self.alertCollectCapitalLabel.textColor = [UIColor blackColor];
        self.alertCollectCapitalLabel.textAlignment =  NSTextAlignmentLeft;
        [self addSubview:self.alertCollectCapitalLabel];
        
        // 最高竞价
        self.alertHightestBidLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 65, 200, 24)];
        self.alertHightestBidLabel.font = [UIFont systemFontOfSize:12.0f];
        self.alertHightestBidLabel.textColor = [UIColor blackColor];;
        self.alertHightestBidLabel.textAlignment  =  NSTextAlignmentLeft;
        [self addSubview:self.alertHightestBidLabel];
        
        // 我的竞价
        self.alertOfferPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 90, 200, 24)];
        self.alertOfferPriceLabel.font = [UIFont systemFontOfSize:12.0f];
        self.alertOfferPriceLabel.textColor = [UIColor blackColor];;
        self.alertOfferPriceLabel.textAlignment  =  NSTextAlignmentLeft;
        [self addSubview:self.alertOfferPriceLabel];
        
        // 新的竞价 Label
        self.alertNewPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 115, 200, 24)];
        self.alertNewPriceLabel.font = [UIFont systemFontOfSize:12.0f];
        self.alertNewPriceLabel.textColor = [UIColor blackColor];;
        self.alertNewPriceLabel.textAlignment  =  NSTextAlignmentLeft;
        [self addSubview:self.alertNewPriceLabel];
        
        // 新的竞价 TextField
        self.alertnewPriceTF = [[UITextField alloc] initWithFrame:CGRectMake(80, 117, 95, 20)];
        self.alertnewPriceTF.font = [UIFont systemFontOfSize:12.0f];
        self.alertnewPriceTF.layer.borderWidth = 0.5;
        self.alertnewPriceTF.textColor = [UIColor blackColor];
        self.alertnewPriceTF.textAlignment  =  NSTextAlignmentLeft;
        self.alertnewPriceTF.delegate = self;
        [self addSubview:self.alertnewPriceTF];
        
        UIView *leftview = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, 4, 24)];//只有宽度起到了作用
        leftview.backgroundColor = [UIColor clearColor];     // 要设置左视图模式
        self.alertnewPriceTF.leftView = leftview;
        self.alertnewPriceTF.leftViewMode = UITextFieldViewModeAlways;
        
        UILabel *dealLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 140, 200, 24)];
        dealLabel.font = [UIFont systemFontOfSize:12.0f];
        dealLabel.textColor = [UIColor blackColor];;
        dealLabel.textAlignment  =  NSTextAlignmentLeft;
        [self addSubview:dealLabel];
        
        // 交易密码
        _dealpwdTextF = [[UITextField alloc] initWithFrame:CGRectMake(80, 142, 95, 20)];
        _dealpwdTextF.font = [UIFont systemFontOfSize:12.0f];
        _dealpwdTextF.layer.borderWidth = 0.5;
        _dealpwdTextF.textColor = [UIColor blackColor];
        _dealpwdTextF.textAlignment  =  NSTextAlignmentLeft;
        _dealpwdTextF.delegate = self;
        _dealpwdTextF.secureTextEntry = YES;
        [self addSubview:_dealpwdTextF];
        
        UIView *dealview = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, 4, 24)];//只有宽度起到了作用
        dealview.backgroundColor = [UIColor clearColor];     // 要设置左视图模式
        _dealpwdTextF.leftView = dealview;
        _dealpwdTextF.leftViewMode = UITextFieldViewModeAlways;
        
        self.alertTitleLabel.text = title;
        self.alertCollectCapitalLabel.text = [NSString stringWithFormat:@"原待收金额:  %@", collectCapital];
        self.alertHightestBidLabel.text = [NSString stringWithFormat:@"竞拍最高价:  %@", hightestBid];
        self.alertOfferPriceLabel.text = [NSString stringWithFormat:@"我的竞价:  %@", offerPrice];
        self.alertNewPriceLabel.text = @"新的竞价: ";
        dealLabel.text = @"交易密码: ";
        
        CGRect leftBtnFrame  = CGRectMake((kAlertWidth - kAlertBtnWidth * 2) / 3, kAlertHeight - kAlertBtnHeight - 15, kAlertBtnWidth, kAlertBtnHeight);
        CGRect rightBtnFrame = CGRectMake((kAlertWidth - kAlertBtnWidth * 2 ) / 3 * 2 + kAlertBtnWidth, kAlertHeight - kAlertBtnHeight - 15, kAlertBtnWidth, kAlertBtnHeight);
        self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftBtn.frame = leftBtnFrame;
        self.leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.leftBtn.layer setCornerRadius:10];
        [self.leftBtn setBackgroundColor:GreenColor];
        [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        [self.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.leftBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.rightBtn.layer setCornerRadius:10];
        self.rightBtn.frame = rightBtnFrame;
        [self.rightBtn setBackgroundColor:GreenColor];
        [self.rightBtn setTitle:rigthTitle forState:UIControlStateNormal];
        self.rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        [self.leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.leftBtn.layer.masksToBounds = self.rightBtn.layer.masksToBounds = YES;
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)leftBtnClicked:(id)sender
{
    if (self.leftBlock) {
        self.leftBlock();
    }
    [self dismissAlert];
}

- (void)rightBtnClicked:(id)sender
{
    if (self.rightBlock) {
        self.rightBlock();
    }
    [self dismissAlert];
}

- (void)show
{
    UIViewController *topVC = [self appRootViewController];
    
    self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, CGRectGetHeight(topVC.view.bounds), kAlertWidth, kAlertHeight);
    [topVC.view addSubview:self];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    UIViewController *topVC = [self appRootViewController];
    
    if (!self.backImageView) {
        self.backImageView = [[UIView alloc] initWithFrame:topVC.view.bounds];
        self.backImageView.backgroundColor = [UIColor blackColor];
        self.backImageView.alpha = 0.6f;
        self.backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    [topVC.view addSubview:self.backImageView];
    //self.transform = CGAffineTransformMakeRotation(-M_1_PI / 2);
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, (CGRectGetHeight(topVC.view.bounds) - kAlertHeight) * 0.5, kAlertWidth, kAlertHeight);
    [UIView animateWithDuration:0.25f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformMakeRotation(0);
        self.frame = afterFrame;
    } completion:^(BOOL finished) {
    }];
    [super willMoveToSuperview:newSuperview];
}

- (void)dismissAlert
{
    [self removeFromSuperview];
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

- (void)removeFromSuperview
{
    [self.backImageView removeFromSuperview];
    self.backImageView = nil;
    UIViewController *topVC = [self appRootViewController];
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, CGRectGetHeight(topVC.view.bounds), kAlertWidth, kAlertHeight);
    
    [UIView animateWithDuration:0.25f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.frame = afterFrame;
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}

#pragma mark 释放键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
@end

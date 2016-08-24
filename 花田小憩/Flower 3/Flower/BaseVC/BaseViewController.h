//
//  BaseViewController.h
//  Flower
//
//  Created by HUN on 16/7/7.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CityCommonVC;

#define REFRESH_HEADER_HEIGHT 52.0f
@interface BaseViewController : UIViewController
//刷新部分
//{
//    UIView *refreshHeaderView;
//    UILabel *refreshLabel;
//    UIImageView *refreshArrow;
//    UIActivityIndicatorView *refreshSpinner;
//    BOOL isDragging;
//    BOOL isLoading;
//    NSString *textPull;
//    NSString *textRelease;
//    NSString *textLoading;
//}
//
//@property (nonatomic, strong) UIView *refreshHeaderView;
//@property (nonatomic, strong) UILabel *refreshLabel;
//@property (nonatomic, strong) UIImageView *refreshArrow;
//@property (nonatomic, strong) UIActivityIndicatorView *refreshSpinner;
//@property (nonatomic, strong) NSString *textPull;
//@property (nonatomic, strong) NSString *textRelease;
//@property (nonatomic, strong) NSString *textLoading;
//
//
//@property (nonatomic, strong) UICollectionView *myRefreshview;
//
//- (void)setupStrings;
//- (void)addPullToRefreshHeader;
//- (void)startLoading;
//- (void)stopRefreshing;
//- (void)refresh;
/**
 *  选中的地址
 */
@property(nonatomic,copy)NSString *seletedCityName;

@property(nonatomic,copy)void (^leftBtnBlock)(UIButton *btn);

@property(nonatomic,copy)void (^rightBtnBlock)(UIButton *btn);


@property(nonatomic,assign)BOOL isMainView;
/** 设置左边的按钮 */
-(void)setLeftBtn:(NSString *)iconStr andTitle:(NSString *)titleStr;

-(void)setLeftBtnIcon:(NSString *)iconStr andLeftBtnSeletdIcon:(NSString *)seletedStr;

/** 设置右边的按钮 */
-(void)setRightBtn:(NSString *)iconStr andTitle:(NSString *)titleStr;

/** 设置顶部 */
-(void)setViewTitle:(NSString *)title;

/**
 *  如果没有登陆就跳转别的
 */
-(void)isLoginSatueWith:(BaseViewController *)targetVC;

/**
 *  //获取根视图的控制器
 */
-(id)getRootViewController;


/**
 *  推栈出去
 */
-(id)PushVC:(NSString *)classStr andName:(NSString *)name isPush:(BOOL)isPush;


/**
 *  出栈多了一个判断
 */
-(void)popVC;


#pragma mark 自己写给登陆注册忘记密码的公用方法的方法(Login部分)
/**
 *  手机号是否存在
 */
- (BOOL)valiMobile:(NSString *)mobile;

/**
 *  弹窗
 */
-(void)alertMetionWitDetail:(NSString *)detailTitle;

/**
 *  带block的弹窗
 */
-(void)alertMetionWitDetail:(NSString *)detailTitle andFinishBlock:(void(^)())block;

/**
 *  网络请求
 */
-(void)webRequestLoginWithUserName:(NSString *)userName AndPassword:(NSString *)pwd andFinishBlock:(void(^)(NSData *  data, NSURLResponse *  response, NSError *  error))finishBlock;

/**
 *  model一个city的选择器
 */
-(CityCommonVC *)showCityView;

/**
 *  modal到网页带导航控制器
 *
 *  @param string 传进去的字符串
 */
-(void)showWebViewWithUrlString:(NSString *)string;

@end

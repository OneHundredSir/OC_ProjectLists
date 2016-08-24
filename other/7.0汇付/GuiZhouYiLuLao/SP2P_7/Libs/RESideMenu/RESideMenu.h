//
// REFrostedViewController.h
// RESideMenu
//
// Copyright (c) 2013-2014 Roman Efimov (https://github.com/romaonthego)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import <UIKit/UIKit.h>
#import "UIViewController+RESideMenu.h"

#ifndef IBInspectable
#define IBInspectable
#endif

@protocol RESideMenuDelegate;

@interface RESideMenu : UIViewController <UIGestureRecognizerDelegate>

#if __IPHONE_8_0
@property (strong, readwrite, nonatomic) IBInspectable NSString *contentViewStoryboardID;
@property (strong, readwrite, nonatomic) IBInspectable NSString *leftMenuViewStoryboardID;
@property (strong, readwrite, nonatomic) IBInspectable NSString *rightMenuViewStoryboardID;
#endif

@property (strong, readwrite, nonatomic) UIViewController *contentViewController;
@property (strong, readwrite, nonatomic) UIViewController *leftMenuViewController;
@property (strong, readwrite, nonatomic) UIViewController *rightMenuViewController;
@property (weak, readwrite, nonatomic) id<RESideMenuDelegate> delegate;

@property (assign, readwrite, nonatomic) NSTimeInterval animationDuration;
@property (strong, readwrite, nonatomic) UIImage *backgroundImage; //隐藏的菜单背景图

@property (assign, readwrite, nonatomic) BOOL panLeftGestureEnabled;// 拖动菜单是否支持手势
@property (assign, readwrite, nonatomic) BOOL panRightGestureEnabled;// 拖动菜单是否支持手势

@property (assign, readwrite, nonatomic) BOOL panFromEdge;// 是否支持只能从屏幕边缘拖动
@property (assign, readwrite, nonatomic) NSUInteger panMinimumOpenThreshold;// 手势拖动移动的位移量阈值（多大值才允许拖动有效）
@property (assign, readwrite, nonatomic) IBInspectable BOOL interactivePopGestureRecognizerEnabled;// ？？？
@property (assign, readwrite, nonatomic) IBInspectable BOOL fadeMenuView;// 菜单淡入淡出效果
@property (assign, readwrite, nonatomic) IBInspectable BOOL scaleContentView;// 主内容区是否支持缩放
@property (assign, readwrite, nonatomic) IBInspectable BOOL scaleBackgroundImageView;// 是否缩放背景图
@property (assign, readwrite, nonatomic) IBInspectable BOOL scaleMenuView;// 是否缩放菜单视图
@property (assign, readwrite, nonatomic) IBInspectable BOOL contentViewShadowEnabled;// 是否有主视图阴影图
@property (strong, readwrite, nonatomic) IBInspectable UIColor *contentViewShadowColor;// 主视图的阴影颜色
@property (assign, readwrite, nonatomic) IBInspectable CGSize contentViewShadowOffset;// 阴影的偏移量
@property (assign, readwrite, nonatomic) IBInspectable CGFloat contentViewShadowOpacity;// 阴影的透明度
@property (assign, readwrite, nonatomic) IBInspectable CGFloat contentViewShadowRadius;// 阴影的圆角

@property (assign, readwrite, nonatomic) IBInspectable CGFloat contentViewLeftScaleValue;// 主视图的左边菜单显示时候的缩放比例
@property (assign, readwrite, nonatomic) IBInspectable CGFloat contentViewRightScaleValue;// 主视图的右边菜单显示时候的缩放比例

@property (assign, readwrite, nonatomic) IBInspectable CGFloat contentViewInLandscapeOffsetCenterX;// 主视图的横屏时的水平偏移量

@property (assign, readwrite, nonatomic) IBInspectable CGFloat contentViewInPortraitOffsetLeftCenterX;// 主视图竖屏时的水平偏移量
@property (assign, readwrite, nonatomic) IBInspectable CGFloat contentViewInPortraitOffsetRightCenterX;// 主视图竖屏时的水平偏移量

@property (assign, readwrite, nonatomic) IBInspectable CGFloat parallaxMenuMinimumRelativeValue;// 菜单偏移量最小值
@property (assign, readwrite, nonatomic) IBInspectable CGFloat parallaxMenuMaximumRelativeValue;// 菜单偏移量最大值
@property (assign, readwrite, nonatomic) IBInspectable CGFloat parallaxContentMinimumRelativeValue;// 主视图偏移量最小值
@property (assign, readwrite, nonatomic) IBInspectable CGFloat parallaxContentMaximumRelativeValue;// 主视图偏移量最大值
@property (assign, readwrite, nonatomic) IBInspectable BOOL parallaxEnabled;// 菜单移动后的位移差是否可用配合上面4个属性一起用
@property (assign, readwrite, nonatomic) CGAffineTransform menuViewControllerTransformation; // ?????

@property (assign, readwrite, nonatomic) IBInspectable BOOL bouncesHorizontally;// 是否禁用反弹功能
@property (assign, readwrite, nonatomic) UIStatusBarStyle menuPreferredStatusBarStyle; // 菜单显示时候的状态栏颜色
@property (assign, readwrite, nonatomic) IBInspectable BOOL menuPrefersStatusBarHidden; // 菜单显示时候状态栏是否可见

- (id)initWithContentViewController:(UIViewController *)contentViewController
             leftMenuViewController:(UIViewController *)leftMenuViewController
            rightMenuViewController:(UIViewController *)rightMenuViewController;

- (void)presentLeftMenuViewController;
- (void)presentRightMenuViewController;
- (void)hideMenuViewController;
- (void)setContentViewController:(UIViewController *)contentViewController animated:(BOOL)animated;

@end

@protocol RESideMenuDelegate <NSObject>

@optional

- (void)sideMenu:(RESideMenu *)sideMenu didRecognizePanGesture:(UIPanGestureRecognizer *)recognizer;
- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController;
- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController;
- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController;
- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController;

@end

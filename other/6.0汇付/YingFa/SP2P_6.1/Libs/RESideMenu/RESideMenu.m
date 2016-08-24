//
// REFrostedViewController.m
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

#import "RESideMenu.h"
#import "UIViewController+RESideMenu.h"
#import "RECommonFunctions.h"

@interface RESideMenu ()

@property (strong, readwrite, nonatomic) UIImageView *backgroundImageView;
@property (assign, readwrite, nonatomic) BOOL visible;
@property (assign, readwrite, nonatomic) BOOL leftMenuVisible;
@property (assign, readwrite, nonatomic) BOOL rightMenuVisible;
@property (assign, readwrite, nonatomic) CGPoint originalPoint;
@property (strong, readwrite, nonatomic) UIButton *contentButton;
@property (strong, readwrite, nonatomic) UIView *menuViewContainer;
@property (strong, readwrite, nonatomic) UIView *contentViewContainer;
@property (assign, readwrite, nonatomic) BOOL didNotifyDelegate;

@end

static const CGFloat defaultLeftDistance = 30.0f;/**< 默认离左边的距离*/
//static const CGFloat defaultScale = 0.85;/**< 默认缩小范围*/
static const CGFloat defaultScale = 0.75;/**< 默认缩小范围*/

@implementation RESideMenu


- (id)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

#if __IPHONE_8_0
- (void)awakeFromNib
{
    if (self.contentViewStoryboardID) {
        self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:self.contentViewStoryboardID];
    }
    if (self.leftMenuViewStoryboardID) {
        self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:self.leftMenuViewStoryboardID];
    }
    if (self.rightMenuViewStoryboardID) {
        self.rightMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:self.rightMenuViewStoryboardID];
    }
}
#endif

- (void)commonInit
{
    // 默认初始化
    _menuViewContainer = [[UIView alloc] init];
    _contentViewContainer = [[UIView alloc] init];
    
    _animationDuration = 0.35f;
    _interactivePopGestureRecognizerEnabled = YES;
  
    _menuViewControllerTransformation = CGAffineTransformMakeScale(1.5f, 1.5f);
    
    _scaleContentView = YES;
    _scaleBackgroundImageView = YES;
    _scaleMenuView = YES;
    _fadeMenuView = YES;
    
    _parallaxEnabled = YES;
    _parallaxMenuMinimumRelativeValue = -15;
    _parallaxMenuMaximumRelativeValue = 15;
    _parallaxContentMinimumRelativeValue = -25;
    _parallaxContentMaximumRelativeValue = 25;
    
    _bouncesHorizontally = YES;
    
    _panLeftGestureEnabled = YES;
    _panRightGestureEnabled = YES;
    
    _panFromEdge = YES;
    _panMinimumOpenThreshold = 60.0;
    
    _contentViewShadowEnabled = NO;
    _contentViewShadowColor = [UIColor blackColor];
    _contentViewShadowOffset = CGSizeZero;
    _contentViewShadowOpacity = 0.4f;
    _contentViewShadowRadius = 8.0f;
    _contentViewInLandscapeOffsetCenterX = 30.f;
    
    _contentViewInPortraitOffsetLeftCenterX  = 30.f;
    _contentViewInPortraitOffsetRightCenterX  = 30.f;
    
    _contentViewLeftScaleValue = 0.7f;
    _contentViewRightScaleValue = 0.7f;
}

#pragma mark -
#pragma mark Public methods

- (id)initWithContentViewController:(UIViewController *)contentViewController leftMenuViewController:(UIViewController *)leftMenuViewController rightMenuViewController:(UIViewController *)rightMenuViewController
{
    self = [self init];
    if (self) {
        _contentViewController = contentViewController;
        _leftMenuViewController = leftMenuViewController;
        _rightMenuViewController = rightMenuViewController;
    }
    return self;
}


- (void)presentLeftMenuViewController
{
    [self presentMenuViewContainerWithMenuViewController:self.leftMenuViewController];
    [self showLeftMenuViewController];
}

- (void)presentRightMenuViewController
{
    [self presentMenuViewContainerWithMenuViewController:self.rightMenuViewController];
    [self showRightMenuViewController];
}

- (void)hideMenuViewController
{
    [self hideMenuViewControllerAnimated:YES];
}

- (void)setContentViewController:(UIViewController *)contentViewController animated:(BOOL)animated
{
    if (_contentViewController == contentViewController)
    {
        return;
    }
    
    if (!animated) {
        [self setContentViewController:contentViewController];
    } else {
        [self addChildViewController:contentViewController];
        contentViewController.view.alpha = 0;
        contentViewController.view.frame = self.contentViewContainer.bounds;
        [self.contentViewContainer addSubview:contentViewController.view];
        [UIView animateWithDuration:self.animationDuration animations:^{
            contentViewController.view.alpha = 1;
        } completion:^(BOOL finished) {
            [self hideViewController:self.contentViewController];
            [contentViewController didMoveToParentViewController:self];
            _contentViewController = contentViewController;

            [self statusBarNeedsAppearanceUpdate];
            [self updateContentViewShadow];
            
            if (self.visible) {
                [self addContentViewControllerMotionEffects];
            }
        }];
    }
}

#pragma mark View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundImageView = ({
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        imageView.image = self.backgroundImage;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView;
    });
    self.contentButton = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectNull];
        [button addTarget:self action:@selector(hideMenuViewController) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.menuViewContainer];
    [self.view addSubview:self.contentViewContainer];
    
    self.menuViewContainer.frame = self.view.bounds;
    self.menuViewContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    if (self.leftMenuViewController) {
        [self addChildViewController:self.leftMenuViewController];
        self.leftMenuViewController.view.frame = self.view.bounds;
        self.leftMenuViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.menuViewContainer addSubview:self.leftMenuViewController.view];
        [self.leftMenuViewController didMoveToParentViewController:self];
    }
    
    if (self.rightMenuViewController) {
        [self addChildViewController:self.rightMenuViewController];
        self.rightMenuViewController.view.frame = self.view.bounds;
        self.rightMenuViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.menuViewContainer addSubview:self.rightMenuViewController.view];
        [self.rightMenuViewController didMoveToParentViewController:self];
    }
    
    self.contentViewContainer.frame = self.view.bounds;
    self.contentViewContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self addChildViewController:self.contentViewController];
    self.contentViewController.view.frame = self.view.bounds;
    [self.contentViewContainer addSubview:self.contentViewController.view];
    [self.contentViewController didMoveToParentViewController:self];
    
    self.menuViewContainer.alpha = !self.fadeMenuView ?: 0;
    if (self.scaleBackgroundImageView)
        self.backgroundImageView.transform = CGAffineTransformMakeScale(1.7f, 1.7f);
    
    [self addMenuViewControllerMotionEffects];
    
    if (self.panLeftGestureEnabled || self.panRightGestureEnabled) {
        self.view.multipleTouchEnabled = NO;
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
        panGestureRecognizer.delegate = self;
        [self.view addGestureRecognizer:panGestureRecognizer];
    }
    
    [self updateContentViewShadow];
}

#pragma mark -
#pragma mark Private methods

- (void)presentMenuViewContainerWithMenuViewController:(UIViewController *)menuViewController
{
    self.menuViewContainer.transform = CGAffineTransformIdentity;
    if (self.scaleBackgroundImageView) {
        self.backgroundImageView.transform = CGAffineTransformIdentity;
        self.backgroundImageView.frame = self.view.bounds;
    }
    self.menuViewContainer.frame = self.view.bounds;
    if (self.scaleMenuView) {
        self.menuViewContainer.transform = self.menuViewControllerTransformation;
    }
    self.menuViewContainer.alpha = !self.fadeMenuView ?: 0;
    if (self.scaleBackgroundImageView)
        self.backgroundImageView.transform = CGAffineTransformMakeScale(1.7f, 1.7f);
    
    if ([self.delegate conformsToProtocol:@protocol(RESideMenuDelegate)] && [self.delegate respondsToSelector:@selector(sideMenu:willShowMenuViewController:)]) {
        [self.delegate sideMenu:self willShowMenuViewController:menuViewController];
    }
}

// 显示左边菜单视图控制器
- (void)showLeftMenuViewController
{
    if (!self.leftMenuViewController) {
        return;
    }
    self.leftMenuViewController.view.hidden = NO;
    self.rightMenuViewController.view.hidden = YES;
    [self.view.window endEditing:YES];
    [self addContentButton];
    [self updateContentViewShadow];
    [self resetContentViewScale];
    /*修改增加代码*/
//    CGAffineTransform oriT = CGAffineTransformIdentity;
//    self.leftMenuViewController.view.transform = oriT;
//    CGRect leftFrame = self.view.bounds;
//    self.leftMenuViewController.view.frame = leftFrame;
//    [self.view insertSubview:self.leftMenuViewController.view atIndex:1];
    
//    CGAffineTransform transRight = CGAffineTransformMakeTranslation(-_leftDistance, 0);
//    CGAffineTransform transScale = CGAffineTransformMakeScale(_scaleSize, _scaleSize);
//    CGAffineTransform transConcat = CGAffineTransformConcat(transRight, transScale);
//    self.leftMenuViewController.view.transform = transConcat;
    
    [UIView animateWithDuration:self.animationDuration animations:^{
        if (self.scaleContentView) {
           /*修改*/
//            self.contentViewContainer.transform = CGAffineTransformMakeScale(self.contentViewLeftScaleValue, self.contentViewLeftScaleValue);
            
            CATransform3D transform = [self getCATransform3D];
            self.contentViewContainer.layer.transform = transform;
            
            
        } else {
            self.contentViewContainer.transform = CGAffineTransformIdentity;
        }
        
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
            self.contentViewContainer.center = CGPointMake((UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ? self.contentViewInLandscapeOffsetCenterX + CGRectGetWidth(self.view.frame) : self.contentViewInPortraitOffsetLeftCenterX + CGRectGetWidth(self.view.frame)), self.contentViewContainer.center.y);
        } else {
            self.contentViewContainer.center = CGPointMake((UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ? self.contentViewInLandscapeOffsetCenterX + CGRectGetHeight(self.view.frame) : self.contentViewInPortraitOffsetLeftCenterX + CGRectGetWidth(self.view.frame)), self.contentViewContainer.center.y);
        }

        self.menuViewContainer.alpha = !self.fadeMenuView ?: 1.0f;
        self.menuViewContainer.transform = CGAffineTransformIdentity;
        if (self.scaleBackgroundImageView)
            self.backgroundImageView.transform = CGAffineTransformIdentity;
            
    } completion:^(BOOL finished) {
        [self addContentViewControllerMotionEffects];
        
        if (!self.visible && [self.delegate conformsToProtocol:@protocol(RESideMenuDelegate)] && [self.delegate respondsToSelector:@selector(sideMenu:didShowMenuViewController:)]) {
            [self.delegate sideMenu:self didShowMenuViewController:self.leftMenuViewController];
        }
        
        self.visible = YES;
        self.leftMenuVisible = YES;
    }];
    
    [self statusBarNeedsAppearanceUpdate];
}

// 显示右边菜单控制器
- (void)showRightMenuViewController
{
    if (!self.rightMenuViewController) {
        return;
    }
    self.leftMenuViewController.view.hidden = YES;
    self.rightMenuViewController.view.hidden = NO;
    [self.view.window endEditing:YES];
    [self addContentButton];
    [self updateContentViewShadow];
    [self resetContentViewScale];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:self.animationDuration animations:^{
        if (self.scaleContentView) {
            self.contentViewContainer.transform = CGAffineTransformMakeScale(self.contentViewRightScaleValue, self.contentViewRightScaleValue);
        } else {
            self.contentViewContainer.transform = CGAffineTransformIdentity;
        }
        self.contentViewContainer.center = CGPointMake((UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ? -self.contentViewInLandscapeOffsetCenterX : -self.contentViewInPortraitOffsetRightCenterX), self.contentViewContainer.center.y);
        
        self.menuViewContainer.alpha = !self.fadeMenuView ?: 1.0f;
        self.menuViewContainer.transform = CGAffineTransformIdentity;
        if (self.scaleBackgroundImageView)
            self.backgroundImageView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        if (!self.rightMenuVisible && [self.delegate conformsToProtocol:@protocol(RESideMenuDelegate)] && [self.delegate respondsToSelector:@selector(sideMenu:didShowMenuViewController:)]) {
            [self.delegate sideMenu:self didShowMenuViewController:self.rightMenuViewController];
        }
        
        self.visible = !(self.contentViewContainer.frame.size.width == self.view.bounds.size.width && self.contentViewContainer.frame.size.height == self.view.bounds.size.height && self.contentViewContainer.frame.origin.x == 0 && self.contentViewContainer.frame.origin.y == 0);
        self.rightMenuVisible = self.visible;
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [self addContentViewControllerMotionEffects];
    }];
    
    [self statusBarNeedsAppearanceUpdate];
}

- (void)hideViewController:(UIViewController *)viewController
{
    [viewController willMoveToParentViewController:nil];
    [viewController.view removeFromSuperview];
    [viewController removeFromParentViewController];
}

- (void)hideMenuViewControllerAnimated:(BOOL)animated
{
    BOOL rightMenuVisible = self.rightMenuVisible;
    if ([self.delegate conformsToProtocol:@protocol(RESideMenuDelegate)] && [self.delegate respondsToSelector:@selector(sideMenu:willHideMenuViewController:)]) {
        [self.delegate sideMenu:self willHideMenuViewController:rightMenuVisible ? self.rightMenuViewController : self.leftMenuViewController];
    }
    
    self.visible = NO;
    self.leftMenuVisible = NO;
    self.rightMenuVisible = NO;
    [self.contentButton removeFromSuperview];
    
    __typeof (self) __weak weakSelf = self;
    void (^animationBlock)(void) = ^{
        __typeof (weakSelf) __strong strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        strongSelf.contentViewContainer.transform = CGAffineTransformIdentity;
        strongSelf.contentViewContainer.frame = strongSelf.view.bounds;
        if (strongSelf.scaleMenuView) {
            strongSelf.menuViewContainer.transform = strongSelf.menuViewControllerTransformation;
        }
        strongSelf.menuViewContainer.alpha = !self.fadeMenuView ?: 0;
        if (strongSelf.scaleBackgroundImageView) {
            strongSelf.backgroundImageView.transform = CGAffineTransformMakeScale(1.7f, 1.7f);
        }
        if (strongSelf.parallaxEnabled) {
            IF_IOS7_OR_GREATER(
               for (UIMotionEffect *effect in strongSelf.contentViewContainer.motionEffects) {
                   [strongSelf.contentViewContainer removeMotionEffect:effect];
               }
            );
        }
    };
    void (^completionBlock)(void) = ^{
        __typeof (weakSelf) __strong strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        if (!strongSelf.visible && [strongSelf.delegate conformsToProtocol:@protocol(RESideMenuDelegate)] && [strongSelf.delegate respondsToSelector:@selector(sideMenu:didHideMenuViewController:)]) {
            [strongSelf.delegate sideMenu:strongSelf didHideMenuViewController:rightMenuVisible ? strongSelf.rightMenuViewController : strongSelf.leftMenuViewController];
        }
    };
    
    if (animated) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [UIView animateWithDuration:self.animationDuration animations:^{
            animationBlock();
        } completion:^(BOOL finished) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            completionBlock();
        }];
    } else {
        animationBlock();
        completionBlock();
    }
    [self statusBarNeedsAppearanceUpdate];
}

- (void)addContentButton
{
    if (self.contentButton.superview)
        return;

    self.contentButton.autoresizingMask = UIViewAutoresizingNone;
    self.contentButton.frame = self.contentViewContainer.bounds;
    self.contentButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentViewContainer addSubview:self.contentButton];
}

- (void)statusBarNeedsAppearanceUpdate
{
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [UIView animateWithDuration:0.3f animations:^{
            [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        }];
    }
}

- (void)updateContentViewShadow
{
    if (self.contentViewShadowEnabled) {
        CALayer *layer = self.contentViewContainer.layer;
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:layer.bounds];
        layer.shadowPath = path.CGPath;
        layer.shadowColor = self.contentViewShadowColor.CGColor;
        layer.shadowOffset = self.contentViewShadowOffset;
        layer.shadowOpacity = self.contentViewShadowOpacity;
        layer.shadowRadius = self.contentViewShadowRadius;
    }
}

- (void)resetContentViewScale
{
    CGAffineTransform t = self.contentViewContainer.transform;
    CGFloat scale = sqrt(t.a * t.a + t.c * t.c);
    CGRect frame = self.contentViewContainer.frame;
    self.contentViewContainer.transform = CGAffineTransformIdentity;
    self.contentViewContainer.transform = CGAffineTransformMakeScale(scale, scale);
    self.contentViewContainer.frame = frame;
}

#pragma mark -
#pragma mark iOS 7 Motion Effects (Private)

- (void)addMenuViewControllerMotionEffects
{
    if (self.parallaxEnabled) {
        IF_IOS7_OR_GREATER(
           for (UIMotionEffect *effect in self.menuViewContainer.motionEffects) {
               [self.menuViewContainer removeMotionEffect:effect];
           }
           UIInterpolatingMotionEffect *interpolationHorizontal = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
           interpolationHorizontal.minimumRelativeValue = @(self.parallaxMenuMinimumRelativeValue);
           interpolationHorizontal.maximumRelativeValue = @(self.parallaxMenuMaximumRelativeValue);
           
           UIInterpolatingMotionEffect *interpolationVertical = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
           interpolationVertical.minimumRelativeValue = @(self.parallaxMenuMinimumRelativeValue);
           interpolationVertical.maximumRelativeValue = @(self.parallaxMenuMaximumRelativeValue);
           
           [self.menuViewContainer addMotionEffect:interpolationHorizontal];
           [self.menuViewContainer addMotionEffect:interpolationVertical];
        );
    }
}

- (void)addContentViewControllerMotionEffects
{
    if (self.parallaxEnabled) {
        IF_IOS7_OR_GREATER(
            for (UIMotionEffect *effect in self.contentViewContainer.motionEffects) {
               [self.contentViewContainer removeMotionEffect:effect];
            }
            [UIView animateWithDuration:0.2 animations:^{
                UIInterpolatingMotionEffect *interpolationHorizontal = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
                interpolationHorizontal.minimumRelativeValue = @(self.parallaxContentMinimumRelativeValue);
                interpolationHorizontal.maximumRelativeValue = @(self.parallaxContentMaximumRelativeValue);

                UIInterpolatingMotionEffect *interpolationVertical = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
                interpolationVertical.minimumRelativeValue = @(self.parallaxContentMinimumRelativeValue);
                interpolationVertical.maximumRelativeValue = @(self.parallaxContentMaximumRelativeValue);

                [self.contentViewContainer addMotionEffect:interpolationHorizontal];
                [self.contentViewContainer addMotionEffect:interpolationVertical];
            }];
        );
    }
}

#pragma mark -
#pragma mark UIGestureRecognizer Delegate (Private)

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    IF_IOS7_OR_GREATER(
       if (self.interactivePopGestureRecognizerEnabled && [self.contentViewController isKindOfClass:[UINavigationController class]]) {
           UINavigationController *navigationController = (UINavigationController *)self.contentViewController;
           if (navigationController.viewControllers.count > 1 && navigationController.interactivePopGestureRecognizer.enabled) {
               return NO;
           }
       }
    );
  
    if (self.panFromEdge && [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && !self.visible) {
        CGPoint point = [touch locationInView:gestureRecognizer.view];
        if (point.x < 20.0 || point.x > self.view.frame.size.width - 20.0) {
            return YES;
        } else {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark -
#pragma mark Pan gesture recognizer (Private)

- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer
{
    if ([self.delegate conformsToProtocol:@protocol(RESideMenuDelegate)] && [self.delegate respondsToSelector:@selector(sideMenu:didRecognizePanGesture:)])
        [self.delegate sideMenu:self didRecognizePanGesture:recognizer];
    
    if (!self.panLeftGestureEnabled && !self.panRightGestureEnabled) {
        return;
    }

    if (recognizer.state == UIGestureRecognizerStateBegan) {
        // 手势开始动作
        [self updateContentViewShadow];
        
        //左上角起始点的坐标 (0, 0) 或者 (240, 0)
        self.originalPoint = CGPointMake(self.contentViewContainer.center.x - CGRectGetWidth(self.contentViewContainer.bounds) / 2.0,
                                         self.contentViewContainer.center.y - CGRectGetHeight(self.contentViewContainer.bounds) / 2.0);
        self.menuViewContainer.transform = CGAffineTransformIdentity;// 重置菜单视图容器
        if (self.scaleBackgroundImageView) {
            self.backgroundImageView.transform = CGAffineTransformIdentity;// 重置背景图片视图
            self.backgroundImageView.frame = self.view.bounds;
        }
        self.menuViewContainer.frame = self.view.bounds;
        [self addContentButton];
        [self.view.window endEditing:YES];
        self.didNotifyDelegate = NO;
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [recognizer translationInView:self.view];
        // 手势拖动了self.view 相对坐标
        //DLOG(@"[Point] = { x=%f , y=%f}", point.x, point.y);
        
        CGFloat delta = 0;// 左右菜单显示越大，此值越接近1，菜单显示越小，此值越接近于0
        if (self.visible) {
            // 如果左右菜单如果可见, 如果左上角起始点的坐标不等于0，......
             // 左右滑动幅度越大，delta越接近0，越小越接近1
            delta = self.originalPoint.x != 0 ? (point.x + self.originalPoint.x) / self.originalPoint.x : 0;
            //DLOG(@"[delta] = { Point.x=%f , self.originalPoint.x=%f, delta=%f}", point.x, self.originalPoint.x , delta);
        } else {
            // 如果左右菜单不可见
            // 滑动的的位移值相对于屏幕宽度的比例，越接近正负1，表示左右滑动的距离越大
            delta = point.x / self.view.frame.size.width;
            //DLOG(@"[delta] = { point.x=%f , delta=%f}", point.x, delta);
        }
        delta = MIN(fabs(delta), 1.6);// 求delta绝对值，并与1.6比较，取最小值
        //DLOG(@"[delta] = { delta=%f }", delta);
        
        CGFloat contentViewLeftScale = self.scaleContentView ? 1 - ((1 - self.contentViewLeftScaleValue) * delta) : 1;// 主视图的缩放比例
        CGFloat backgroundViewScale = 1.7f - (0.7f * delta);// 背景图片缩放的比例
        CGFloat menuViewScale = 1.5f - (0.5f * delta);// 菜单视图控制器缩放比例
        
        // 右边菜单显示，主视图的缩放比例
        CGFloat contentViewRightScale = self.scaleContentView ? 1 - ((1 - self.contentViewRightScaleValue) * delta) : 1;// 主视图的缩放比例
        
        if (!self.bouncesHorizontally) {
            // 如果无反弹效果
            contentViewLeftScale = MAX(contentViewLeftScale, self.contentViewLeftScaleValue);
            backgroundViewScale = MAX(backgroundViewScale, 1.0);
            menuViewScale = MAX(menuViewScale, 1.0);
            
            // 右边菜单显示，主视图的缩放比例
            contentViewRightScale = MAX(contentViewRightScale, self.contentViewRightScaleValue);
        }
        
        self.menuViewContainer.alpha = !self.fadeMenuView ?: delta;
        
        if (self.scaleBackgroundImageView) {
            self.backgroundImageView.transform = CGAffineTransformMakeScale(backgroundViewScale, backgroundViewScale);
        }
        
        if (self.scaleMenuView) {
            self.menuViewContainer.transform = CGAffineTransformMakeScale(menuViewScale, menuViewScale);
        }
        
        if (self.scaleBackgroundImageView) {
            if (backgroundViewScale < 1) {
                self.backgroundImageView.transform = CGAffineTransformIdentity;
            }
        }
        
       if (!self.bouncesHorizontally && self.visible) {
           // 如果无反弹效果, 而且菜单可见
           if (self.contentViewContainer.frame.origin.x > self.contentViewContainer.frame.size.width / 2.0)
           {
               point.x = MIN(0.0, point.x);
           }
           
            if (self.contentViewContainer.frame.origin.x < -(self.contentViewContainer.frame.size.width / 2.0))
            {
                point.x = MAX(0.0, point.x);
            }
        }
        
        // Limit size
        //
        if (point.x < 0) {
            point.x = MAX(point.x, -[UIScreen mainScreen].bounds.size.height);
        } else {
            point.x = MIN(point.x, [UIScreen mainScreen].bounds.size.height);
        }
        [recognizer setTranslation:point inView:self.view];
        
        if (!self.didNotifyDelegate) {
            if (point.x > 0 && self.panLeftGestureEnabled) {
                if (!self.visible && [self.delegate conformsToProtocol:@protocol(RESideMenuDelegate)] && [self.delegate respondsToSelector:@selector(sideMenu:willShowMenuViewController:)]) {
                    [self.delegate sideMenu:self willShowMenuViewController:self.leftMenuViewController];
                }
            }
            if (point.x < 0 && self.panRightGestureEnabled) {
                if (!self.visible && [self.delegate conformsToProtocol:@protocol(RESideMenuDelegate)] && [self.delegate respondsToSelector:@selector(sideMenu:willShowMenuViewController:)]) {
                    [self.delegate sideMenu:self willShowMenuViewController:self.rightMenuViewController];
                }
            }
            self.didNotifyDelegate = YES;
        }

        if (point.x > 0 && self.panLeftGestureEnabled && !self.visible) {
            
             if (contentViewLeftScale > 1) {
                 CGFloat oppositeScale = (1 - (contentViewLeftScale - 1));
                 self.contentViewContainer.transform = CGAffineTransformMakeScale(oppositeScale, oppositeScale);
                 self.contentViewContainer.transform = CGAffineTransformTranslate(self.contentViewContainer.transform, point.x, 0);
             } else {
                 self.contentViewContainer.transform = CGAffineTransformMakeScale(contentViewLeftScale, contentViewLeftScale);
                 self.contentViewContainer.transform = CGAffineTransformTranslate(self.contentViewContainer.transform, point.x, 0);
             }
             
        }
        
        if (point.x < 0 && self.panRightGestureEnabled && !self.visible) {
            if (contentViewRightScale > 1) {
                CGFloat oppositeScale = (1 - (contentViewRightScale - 1));
                self.contentViewContainer.transform = CGAffineTransformMakeScale(oppositeScale, oppositeScale);
                self.contentViewContainer.transform = CGAffineTransformTranslate(self.contentViewContainer.transform, point.x, 0);
            } else {
                self.contentViewContainer.transform = CGAffineTransformMakeScale(contentViewRightScale, contentViewRightScale);
                self.contentViewContainer.transform = CGAffineTransformTranslate(self.contentViewContainer.transform, point.x, 0);
            }
        }
        
        // 根据主视图控制器的起始坐标x判断当前左右视图的可见性
        self.leftMenuViewController.view.hidden = self.contentViewContainer.frame.origin.x < 0;
        self.rightMenuViewController.view.hidden = self.contentViewContainer.frame.origin.x > 0;
        
        if (!self.leftMenuViewController && self.contentViewContainer.frame.origin.x > 0) {
            //  复位主视图
            self.contentViewContainer.transform = CGAffineTransformIdentity;
            self.contentViewContainer.frame = self.view.bounds;
            self.visible = NO;
            self.leftMenuVisible = NO;
        } else  if (!self.rightMenuViewController && self.contentViewContainer.frame.origin.x < 0) {
            // 复位主视图
            self.contentViewContainer.transform = CGAffineTransformIdentity;
            self.contentViewContainer.frame = self.view.bounds;
            self.visible = NO;
            self.rightMenuVisible = NO;
        }
        
        [self statusBarNeedsAppearanceUpdate];
    }
    
   if (recognizer.state == UIGestureRecognizerStateEnded) {
       // 手势结束动作
        self.didNotifyDelegate = NO;
        if (self.panMinimumOpenThreshold > 0 && (
            (self.contentViewContainer.frame.origin.x < 0 && self.contentViewContainer.frame.origin.x > -((NSInteger)self.panMinimumOpenThreshold)) ||
            (self.contentViewContainer.frame.origin.x > 0 && self.contentViewContainer.frame.origin.x < self.panMinimumOpenThreshold))
            ) {
            // 手势终点坐标如果小于0 而且 终点坐标大于位移差的负值则依然不显示菜单，表示滑动右边菜单过小，不显示右边菜单控制器
            // 手势终点左边如果大于0 而且 终点坐标小于位移差则依然不显示菜单，表示滑动左边菜单幅度过小，不显示左边菜单控制器
            [self hideMenuViewController];
        }
        else if (self.contentViewContainer.frame.origin.x == 0) {
            // 手势终点左边如果等于0 表示刚好隐藏了菜单控制器，则直接隐藏菜单即可
            [self hideMenuViewControllerAnimated:NO];
        }
        else {
            if ([recognizer velocityInView:self.view].x > 0) {
                // 手势的滑动速度 的x方向的速度，大于0代表左往右滑动，越快值越大，即如果是向右滑动
                if (self.contentViewContainer.frame.origin.x < 0) {
                    
                    // 隐藏右边菜单控制器
                    if (self.panRightGestureEnabled) {
                        [self hideMenuViewController];
                    }
            
                } else {
         
                    if (self.leftMenuViewController && self.panLeftGestureEnabled) {
                        // 如果存在左边的视图，则显示左边的视图控制器
                        [self showLeftMenuViewController];
                    }
                }
            } else {
                // 手势的滑动速度 的x 方向的速度，小于0代表右往左滑动，越快值越大，即如果是向左滑动
                if (self.contentViewContainer.frame.origin.x < 20) {
                    if (self.rightMenuViewController && self.panRightGestureEnabled) {
                        // 如果存在右边的视图控制器，则显示右边视图控制器
                        [self showRightMenuViewController];
                    }
                } else {
                    if(self.panLeftGestureEnabled){
                        [self hideMenuViewController];
                    }
                }
            }
        }
    }
}

#pragma mark -
#pragma mark Setters

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    if (self.backgroundImageView)
        self.backgroundImageView.image = backgroundImage;
}

- (void)setContentViewController:(UIViewController *)contentViewController
{
    if (!_contentViewController) {
        _contentViewController = contentViewController;
        return;
    }
    [self hideViewController:_contentViewController];
    _contentViewController = contentViewController;
    
    [self addChildViewController:self.contentViewController];
    self.contentViewController.view.frame = self.view.bounds;
    [self.contentViewContainer addSubview:self.contentViewController.view];
    [self.contentViewController didMoveToParentViewController:self];
    
    [self updateContentViewShadow];
    
    if (self.visible) {
        [self addContentViewControllerMotionEffects];
    }
}

- (void)setLeftMenuViewController:(UIViewController *)leftMenuViewController
{
    if (!_leftMenuViewController) {
        _leftMenuViewController = leftMenuViewController;
        return;
    }
    [self hideViewController:_leftMenuViewController];
    _leftMenuViewController = leftMenuViewController;
   
    [self addChildViewController:self.leftMenuViewController];
    self.leftMenuViewController.view.frame = self.view.bounds;
    self.leftMenuViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.menuViewContainer addSubview:self.leftMenuViewController.view];
    [self.leftMenuViewController didMoveToParentViewController:self];
    
    [self addMenuViewControllerMotionEffects];
    [self.view bringSubviewToFront:self.contentViewContainer];
}

- (void)setRightMenuViewController:(UIViewController *)rightMenuViewController
{
    if (!_rightMenuViewController) {
        _rightMenuViewController = rightMenuViewController;
        return;
    }
    [self hideViewController:_rightMenuViewController];
    _rightMenuViewController = rightMenuViewController;
    
    [self addChildViewController:self.rightMenuViewController];
    self.rightMenuViewController.view.frame = self.view.bounds;
    self.rightMenuViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.menuViewContainer addSubview:self.rightMenuViewController.view];
    [self.rightMenuViewController didMoveToParentViewController:self];
    
    [self addMenuViewControllerMotionEffects];
    [self.view bringSubviewToFront:self.contentViewContainer];
}

#pragma mark -
#pragma mark View Controller Rotation handler

- (BOOL)shouldAutorotate
{
    return self.contentViewController.shouldAutorotate;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (self.visible) {
        self.menuViewContainer.bounds = self.view.bounds;
        self.contentViewContainer.transform = CGAffineTransformIdentity;
        self.contentViewContainer.frame = self.view.bounds;
        
        CGPoint center;
        if (self.leftMenuVisible) {
            // 如果左边的菜单可见
            if (self.scaleContentView) {
                self.contentViewContainer.transform = CGAffineTransformMakeScale(self.contentViewLeftScaleValue, self.contentViewLeftScaleValue);
            } else {
                self.contentViewContainer.transform = CGAffineTransformIdentity;
            }
            if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
                center = CGPointMake((UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? self.contentViewInLandscapeOffsetCenterX + CGRectGetWidth(self.view.frame) : self.contentViewInPortraitOffsetLeftCenterX + CGRectGetWidth(self.view.frame)), self.contentViewContainer.center.y);
            } else {
                center = CGPointMake((UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? self.contentViewInLandscapeOffsetCenterX + CGRectGetHeight(self.view.frame) : self.contentViewInPortraitOffsetLeftCenterX + CGRectGetWidth(self.view.frame)), self.contentViewContainer.center.y);
            }
        } else {
            if (self.scaleContentView) {
                self.contentViewContainer.transform = CGAffineTransformMakeScale(self.contentViewRightScaleValue, self.contentViewRightScaleValue);
            } else {
                self.contentViewContainer.transform = CGAffineTransformIdentity;
            }
            center = CGPointMake((UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? -self.contentViewInLandscapeOffsetCenterX : -self.contentViewInPortraitOffsetLeftCenterX), self.contentViewContainer.center.y);
        }
        
        self.contentViewContainer.center = center;
    }
    
    [self updateContentViewShadow];
}

#pragma mark -
#pragma mark Status Bar Appearance Management

- (UIStatusBarStyle)preferredStatusBarStyle
{
    UIStatusBarStyle statusBarStyle = UIStatusBarStyleDefault;
    IF_IOS7_OR_GREATER(
       statusBarStyle = self.visible ? self.menuPreferredStatusBarStyle : self.contentViewController.preferredStatusBarStyle;
       if (self.contentViewContainer.frame.origin.y > 10) {
           statusBarStyle = self.menuPreferredStatusBarStyle;
       } else {
           statusBarStyle = self.contentViewController.preferredStatusBarStyle;
       }
    );
    return statusBarStyle;
}

- (BOOL)prefersStatusBarHidden
{
    BOOL statusBarHidden = NO;
    IF_IOS7_OR_GREATER(
        statusBarHidden = self.visible ? self.menuPrefersStatusBarHidden : self.contentViewController.prefersStatusBarHidden;
        if (self.contentViewContainer.frame.origin.y > 10) {
            statusBarHidden = self.menuPrefersStatusBarHidden;
        } else {
            statusBarHidden = self.contentViewController.prefersStatusBarHidden;
        }
    );
    return statusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    UIStatusBarAnimation statusBarAnimation = UIStatusBarAnimationNone;
    IF_IOS7_OR_GREATER(
        statusBarAnimation = self.visible ? self.leftMenuViewController.preferredStatusBarUpdateAnimation : self.contentViewController.preferredStatusBarUpdateAnimation;
        if (self.contentViewContainer.frame.origin.y > 10) {
            statusBarAnimation = self.leftMenuViewController.preferredStatusBarUpdateAnimation;
        } else {
            statusBarAnimation = self.contentViewController.preferredStatusBarUpdateAnimation;
        }
    );
    return statusBarAnimation;
}

#pragma mark - 修改倾斜动画
/**
 *  获取view的动画效果(有倾斜)
 *
 *  @return 返回动画效果
 */
-(CATransform3D)getCATransform3D{
    CGFloat translateX = 0;
    CGFloat transcale = 0;
//    switch (self.leftMenuViewController.view.hidden == NO) {
//        case LeftMenuPanDirectionLeft:
//            translateX = -(defaultLeftDistance);
//            transcale = defaultScale;
//            break;
//        case LeftMenuPanDirectionRight:
            translateX = defaultLeftDistance;
            transcale = defaultScale;
//        default:
//            break;
//    }
    //    CGAffineTransform transT = CGAffineTransformMakeTranslation(translateX, 0);
    //    CGAffineTransform scaleT = CGAffineTransformMakeScale(transcale, transcale);
    //    CGAffineTransform conT = CGAffineTransformConcat(transT, scaleT);
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0/-100;//透视效果，要操作的这个对象要有旋转的角度，否则没有效果。正直/负值都有意义
    transform.m11 = transcale;//x轴缩放
    transform.m22 = transcale;//y轴缩放
    transform.m41 = translateX;//平移
    CGFloat angle =  30.0f * M_PI / 180.0f * (translateX/self.view.frame.size.width);
    transform = CATransform3DRotate(transform, angle , 0.0f, 10.0f, 0.0f);
    
    return transform;
}


@end

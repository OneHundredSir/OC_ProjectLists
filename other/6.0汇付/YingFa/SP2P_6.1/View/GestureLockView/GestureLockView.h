//
//  GestureLockView.h
//  SP2P_6.1
//
//  Created by 李小斌 on 14-6-23.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GestureLockView;

@protocol GestureLockViewDelegate <NSObject>
@optional
- (void)gestureLockView:(GestureLockView *)gestureLockView didBeginWithPasscode:(NSString *)passcode;

- (void)gestureLockView:(GestureLockView *)gestureLockView didEndWithPasscode:(NSString *)passcode;

- (void)gestureLockView:(GestureLockView *)gestureLockView didCanceledWithPasscode:(NSString *)passcode;
@end

@interface GestureLockView : UIView

@property (nonatomic, assign) NSUInteger numberOfGestureNodes;
@property (nonatomic, assign) NSUInteger gestureNodesPerRow;

@property (nonatomic, strong) UIImage *normalGestureNodeImage;
@property (nonatomic, strong) UIImage *selectedGestureNodeImage;

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, strong, readonly) UIView *contentView;//the container of the gesture notes
@property (nonatomic, assign) UIEdgeInsets contentInsets;

@property (nonatomic, weak) id<GestureLockViewDelegate> delegate;

@end

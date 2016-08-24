//
//  PassGuardViewController.h
//  webinvokepassgaurd
//
//  Created by apple on 13-11-8.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassGuardCtrl.h"
/**
 *  分别对应于所弹出文本框的“确定”、“取消”和键盘右下角的“收起”键盘按钮。通过实现这三个委托接口可以实现获取m_tf密文等操作。
 */
@protocol BarDelegate<NSObject>
- (void) DoneFun:   (id)sender;
- (void) CancelFun: (id)sender;
- (void) HideFun:   (id)sender;
@end


@interface PassGuardViewController : UIViewController<DoneDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate>

@property (nonatomic,retain) PassGuardTextField *m_tf;//iOS密码控件对象
@property (nonatomic,assign) id <BarDelegate> delegate;
@property (nonatomic) bool   m_isDispearWithTouchOutside;//设置为true时，当点击文本框和键盘以外区域时，将收起文本框和键盘；
                                                         //设置为false时，当点击文本框和键盘以外区域时，收起文本框和键盘，控件文本框不会失去焦点。
@property (nonatomic) bool   m_bshowtoolbar;

- (void) show;   //弹出iOS密码控件文本框及其键盘

- (void) dismiss;//收起iOS密码控件文本框及其键盘。

- (void) DoneFun:(id)sender;

@end

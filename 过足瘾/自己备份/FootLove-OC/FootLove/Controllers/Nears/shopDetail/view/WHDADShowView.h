//
//  WHDADShowView.h
//  FootLove
//
//  Created by HUN on 16/6/28.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHDADShowView : UIView

#pragma mark 设置定时器 //由于需要释放所以要在控制器关闭的时候去除
@property(nonatomic,weak)NSTimer *timer;

#pragma mark 把点击时间传出去
@property(nonatomic,copy)void (^btnBlock)(UIButton *btn);

-(void)initwhdSetAdViewWithImgUrlArr:(NSArray *)ImgUrlArr;


@end

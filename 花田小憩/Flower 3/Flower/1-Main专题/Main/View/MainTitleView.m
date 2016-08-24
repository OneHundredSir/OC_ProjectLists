//
//  MainTitleView.m
//  Flower
//
//  Created by HUN on 16/7/10.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "MainTitleView.h"

@implementation MainTitleView

-(instancetype)mainTitleViewInitWithTitleAcitonArr:(NSArray <NSString *> *)actionArr andFrame:(CGRect)frame
{
    MainTitleView *view = [[MainTitleView alloc]initWithFrame:frame];
    
    
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc]initWithFrame:(CGRect){0,0,frame.size.width,frame.size.height}];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    
    [blurView setEffect:effect];
    
    [view addSubview:blurView];
    
    UIImageView *imageView = [[UIImageView  alloc]initWithFrame:(CGRect){0,0,frame.size.width,frame.size.height}];
    UIImage *img = [UIImage imageNamed:@"p_comment"];
    img = [UIImage imageWithCGImage:img.CGImage scale:img.scale orientation:UIImageOrientationDown];
    img = [img resizableImageWithCapInsets:(UIEdgeInsets){5,0.5,5,0.5} resizingMode:UIImageResizingModeStretch];
    imageView.image = img;
    //让图片旋转，注意如果图片拉伸不好看记得自己进行裁剪
//    imageView.transform = CGAffineTransformMakeRotation(M_PI);
    imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    imageView.layer.shadowOffset = (CGSize){-2,-2};
    [view addSubview:imageView];
    
    //按要求添加按钮并且给赋值，显示的时候按钮按照
    //根据view的尺寸给以及magin值
    NSInteger totalNum = actionArr.count;
    CGFloat magin = 5 ;
    CGFloat btnH = frame.size.height - magin*2;
    CGFloat btnW = (frame.size.width - magin *(totalNum+1))/totalNum;
    for (int i=0; i<totalNum; i++)
    {
        UIButton *btn = [[UIButton alloc]initWithFrame:(CGRect){magin +(magin+btnW)*i,magin*2,btnW,btnH}];
        [btn setTitle:actionArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = font(13);
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 10 + i;
        [view addSubview:btn];
    }
    return view;
}

-(void)btnAction:(UIButton *)btn
{
    if (self.btnBlock) {
        self.btnBlock(btn);
    }
}


@end

//
//  UIButton+WHDtool.m
//  
//
//  Created by HUN on 16/6/2.
//
//

#import "UIButton+WHDtool.h"

@implementation UIButton (WHDtool)
+(instancetype)setImageAndTitleWithFrame:(CGRect)frame
                            andNomalName:(NSString *)NomalName
                           andNomalImage:(NSString *)Nomalimg
                        andHighLightName:(NSString *)HName
                       andHighLightImage:(NSString *)Himg
{
    UIButton *btn=[[UIButton alloc]initWithFrame:frame];
    [btn setTitle:NomalName forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:Nomalimg] forState:UIControlStateNormal];
    
    [btn setTitle:HName forState:UIControlStateHighlighted];
    [btn setImage:[UIImage imageNamed:Himg] forState:UIControlStateHighlighted];
    return btn;
}


+(instancetype)setImageAndTitleWithrame:(CGRect)frame
                           andNomalName:(NSString *)NomalName
                          andNomalImage:(NSString *)Nomalimg
                         andSeletedName:(NSString *)HName
                        andSeletedImage:(NSString *)Himg
{
    UIButton *btn=[[UIButton alloc]initWithFrame:frame];
    [btn setTitle:NomalName forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:Nomalimg] forState:UIControlStateNormal];
    
    [btn setTitle:HName forState:UIControlStateSelected];
    [btn setImage:[UIImage imageNamed:Himg] forState:UIControlStateSelected];
    return btn;
}
@end

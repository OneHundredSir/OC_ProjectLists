//
//  UIButton+WHDtool.h
//  
//
//  Created by HUN on 16/6/2.
//
//

#import <UIKit/UIKit.h>

@interface UIButton (WHDtool)
+(instancetype)setImageAndTitleWithFrame:(CGRect)frame
                               andNomalName:(NSString *)NomalName
                               andNomalImage:(NSString *)Nomalimg
                                   andHighLightName:(NSString *)HName
                           andHighLightImage:(NSString *)Himg;


+(instancetype)setImageAndTitleWithrame:(CGRect)frame
                              andNomalName:(NSString *)NomalName
                               andNomalImage:(NSString *)Nomalimg
                            andSeletedName:(NSString *)HName
                           andSeletedImage:(NSString *)Himg;
@end

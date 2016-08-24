//
//  MainTitleView.h
//  Flower
//
//  Created by HUN on 16/7/10.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTitleView : UIView

@property(nonatomic,copy)void (^btnBlock)(UIButton *btn);


-(instancetype)mainTitleViewInitWithTitleAcitonArr:(NSArray <NSString *>*)actionArr andFrame:(CGRect)frame;


@end

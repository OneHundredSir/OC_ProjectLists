//
//  BarButtonItem.m
//  QYGW
//
//  Created by 李小斌 on 14-4-10.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "BarButtonItem.h"

@interface BarButtonItem ()
@end

@implementation BarButtonItem


-(id) initWithImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage target:(id)target action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 30, 30)];
    [btn setImage:selectedImage forState:UIControlStateNormal];
    [btn setImage:selectedImage forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self = [[BarButtonItem alloc] initWithCustomView:btn];
    if(self){
        _customButton = btn;
        _customTarget=target;
        [self setNormalImage:normalImage];
        [self setSelectedImage:selectedImage];
        [self setCustomAction:action];
    }
    return  self;
}

+(BarButtonItem *)barItemWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage target:(id)target action:(SEL)action{
    return [[BarButtonItem alloc] initWithImage:image selectedImage:selectedImage target:target action:action];
}


- (void)setNormalImage:(UIImage *)image {
    _normalImage = image;
    [_customButton setImage:image forState:UIControlStateNormal];
}

- (void)setSelectedImage:(UIImage *)image {
    _selectedImage = image;
    [_customButton setImage:image forState:UIControlStateHighlighted];
}

- (void)setCustomAction:(SEL)action {
    _customAction = action;
    [_customButton removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
    [_customButton addTarget:_customTarget action:action forControlEvents:UIControlEventTouchUpInside];
}

@end

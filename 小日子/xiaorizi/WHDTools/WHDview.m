//
//  WHDview.m
//  xiaorizi
//
//  Created by HUN on 16/6/1.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDview.h"

@implementation WHDview

-(void)setR:(CGFloat)R
{
    _R=R;
    self.layer.cornerRadius=R;
    
}

-(void)setW:(CGFloat)W
{
    _W=W;
    self.layer.borderWidth=W;
}


-(void)setColor:(UIColor *)color
{
    _color=color;
    self.layer.borderColor=_color.CGColor;
}

@end

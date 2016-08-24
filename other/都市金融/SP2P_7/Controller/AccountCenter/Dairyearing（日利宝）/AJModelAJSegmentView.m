//
//  AJModelAJSegmentView.m
//  com.higgs.botrip
//
//  Created by 周利强 on 15/9/10.
//  Copyright (c) 2015年 周利强. All rights reserved.
//

#import "AJModelAJSegmentView.h"

@implementation AJModelAJSegmentView
- (instancetype)initWitharrTitle:(NSArray*)arrTitle colorSelected:(UIColor *)colorSelected colorNormal:(UIColor *)colorNormal font:(UIFont *)fontTitle
{
    if (self = [super init]) {
        self.arrTitle = arrTitle;
        self.colorSelected = colorSelected;
        self.colorNormal = colorNormal;
        self.fontTitle = fontTitle;
    }
    return self;
}
- (instancetype)initWithTitles:(NSArray *)titles colorTitle:(UIColor *)colortitle font:(UIFont *)font bgColors:(NSArray *)bgcolors
{
    if (self = [super init]) {
        self.arrTitle = titles;
        self.arrayBgColor = bgcolors;
        self.colorNormal = colortitle;
        self.fontTitle = font;
    }
    return self;
}
@end

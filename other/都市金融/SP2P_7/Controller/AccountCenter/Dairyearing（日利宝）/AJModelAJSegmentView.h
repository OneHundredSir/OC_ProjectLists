//
//  AJModelAJSegmentView.h
//  com.higgs.botrip
//
//  Created by 周利强 on 15/9/10.
//  Copyright (c) 2015年 周利强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AJModelAJSegmentView : NSObject
// 标题
@property (nonatomic, strong) NSArray *arrTitle;
// 选中时字体颜色
@property (nonatomic, strong) UIColor *colorSelected;
// 未选中时字体颜色颜色
@property (nonatomic, strong) UIColor *colorNormal;
// 字体
@property (nonatomic, strong) UIFont *fontTitle;
// 按钮背景颜色
@property (nonatomic,strong) NSArray *arrayBgColor;
- (instancetype)initWitharrTitle:(NSArray*)arrTitle colorSelected:(UIColor *)colorSelected colorNormal:(UIColor *)colorNormal font:(UIFont *)fontTitle;
- (instancetype)initWithTitles:(NSArray*)titles colorTitle:(UIColor *)colortitle font:(UIFont *)font bgColors:(NSArray*)bgcolors;
@end

//
//  AJSegmentView.m
//  com.higgs.botrip
//
//  Created by 周利强 on 15/9/10.
//  Copyright (c) 2015年 周利强. All rights reserved.
//

#import "AJSegmentView.h"
#import "AJModelAJSegmentView.h"

@interface AJSegmentView ()
@property (nonatomic, weak) UIView *selectIndicator;
@end

@implementation AJSegmentView

- (void)setAAJModelAJSegmentView:(AJModelAJSegmentView *)aAJModelAJSegmentView
{
    _aAJModelAJSegmentView = aAJModelAJSegmentView;
    
    NSArray *arrTemp = _aAJModelAJSegmentView.arrTitle;
    UIFont *fontVM = _aAJModelAJSegmentView.fontTitle;
    UIFont *font = fontVM ? fontVM:[UIFont systemFontOfSize:18];
    UIColor *colowNormal = _aAJModelAJSegmentView.colorNormal;
    // 1. 按钮
    NSMutableArray *mutArrTemp = [NSMutableArray arrayWithCapacity:arrTemp.count];
    CGFloat btnW = MSWIDTH / arrTemp.count;
#define kbtnH 70.f/2
    
    // 2.下标指示
    UIColor *colorSelect = _aAJModelAJSegmentView.colorSelected;
    if (colorSelect) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = colorSelect;
        [self addSubview:view];
        self.selectIndicator = view;
        view.bounds = (CGRect){CGPointZero, {btnW, 2}};
    }
    
    for (int i = 0; i < arrTemp.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
         [self addSubview:button];
        if (!colorSelect) {
             button.frame = CGRectMake(i*btnW, 0, btnW, self.bounds.size.height);
        }else{
             button.frame = CGRectMake(i*btnW, 0, btnW, kbtnH);
    
        }
        button.adjustsImageWhenHighlighted = NO;
        [button setTitle:arrTemp[i] forState:UIControlStateNormal];
        [button setTitleColor:colowNormal forState:UIControlStateNormal];
        //        [button setTitleColor:colorSelect forState:UIControlStateSelected];
        button.titleLabel.font = font;
        button.showsTouchWhenHighlighted = YES;
       
        if (aAJModelAJSegmentView.arrayBgColor) {
              button.backgroundColor = aAJModelAJSegmentView.arrayBgColor[i];
        }else{
              button.backgroundColor = [UIColor clearColor];
        }
        // 监听
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        [mutArrTemp addObject:button];
    }
    self.arrBtn = mutArrTemp;
    
      // 3 设置初始选中
    self.selectedSegmentIndex = 0;
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex
{
    _selectedSegmentIndex = selectedSegmentIndex;
    
     UIButton *btnSelect = (UIButton *)self.arrBtn[_selectedSegmentIndex];
    // 1. 动画改变底部横线frame
    if (self.selectIndicator) {
        CGPoint center = self.selectIndicator.center;
        CGFloat centerX = btnSelect.center.x;
        center = CGPointMake(centerX, CGRectGetMaxY(btnSelect.frame));
        [UIView animateWithDuration:0.5 animations:^{
            self.selectIndicator.center = center;
        }];
        
        // 2. 改变按钮颜色
        [btnSelect setTitleColor:self.aAJModelAJSegmentView.colorSelected forState:UIControlStateNormal];

    }
}

- (void)btnClick:(UIButton *)sender
{
    UIButton *btn = (UIButton *)self.arrBtn[_selectedSegmentIndex];
    NSInteger index =  [self.arrBtn indexOfObject:sender];
    
//    if (index == 0) {// 左边
//        [[NSNotificationCenter defaultCenter] postNotificationName:BTripAJSegmentViewClickLeft object:nil];
//
//    }else{// 右边
//         [[NSNotificationCenter defaultCenter] postNotificationName:BTripAJSegmentViewClickRight object:nil];
//    }
    if ([self.delegate respondsToSelector:@selector(AJSegmentViewClick:)]) {
        [self.delegate AJSegmentViewClick:index];
    }
    
    // 0.判断是否已选中
    if (btn == sender) return;
    
    // 1.改变原来按钮文字颜色
    if (self.selectIndicator) {
        [btn setTitleColor:self.aAJModelAJSegmentView.colorNormal forState:UIControlStateNormal];
    }
    // 2.设置选中index
    self.selectedSegmentIndex = index;
    
    // 3.告知代理
//    if ([self.delegate respondsToSelector:@selector(AJSegmentViewClick:)]) {
//        [self.delegate AJSegmentViewClick:self.selectedSegmentIndex];
//    }
}
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<AJSegmentViewDelegate>)delegate
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = delegate;
    }
    return self;
}
@end

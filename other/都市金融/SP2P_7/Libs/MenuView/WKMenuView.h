//
//  WKMenuView.h
//  CosChat
//
//  Created by Mark on 15/4/26.
//  Copyright (c) 2015年 yq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WKMenuView;
@class WKMenuItem;
typedef enum{
    WKMenuSlideToNextItem,
    WKMenuSlideToFrontItem
} WKMenuSlideType;
typedef enum{
    WKMenuViewStyleDefault,
    WKMenuViewStyleLine
} WKMenuViewStyle;
@protocol WKMenuViewDelegate <NSObject>
@optional
- (void)menuView:(WKMenuView *)menu didSelesctedIndex:(NSInteger)index;
- (void)menuView:(WKMenuView *)menu didSelesctedIndex:(NSInteger)index moveEnd:(BOOL)isEnd;
- (CGFloat)menuView:(WKMenuView *)menu widthForItemAtIndex:(NSInteger)index;
@end

@interface WKMenuView : UIView

@property (nonatomic, assign) WKMenuViewStyle style;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, weak) id<WKMenuViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame buttonItems:(NSArray *)items backgroundColor:(UIColor *)bgColor norSize:(CGFloat)norSize selSize:(CGFloat)selSize norColor:(UIColor *)norColor selColor:(UIColor *)selColor;
- (void)slideMenuAtProgress:(CGFloat)progress;
- (void)changeProgress:(CGFloat)progress;
- (void)selectItemAtIndex:(NSInteger)index;
@end

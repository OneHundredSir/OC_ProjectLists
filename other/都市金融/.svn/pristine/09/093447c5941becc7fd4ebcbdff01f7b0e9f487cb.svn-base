//
//  AJSegmentView.h
//  com.higgs.botrip
//
//  Created by 周利强 on 15/9/10.
//  Copyright (c) 2015年 周利强. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AJModelAJSegmentView;

@protocol AJSegmentViewDelegate <NSObject>
@optional
- (void)AJSegmentViewClick:(NSInteger)index;

@end
@interface AJSegmentView : UIView
@property (nonatomic, strong) NSArray *arrBtn;
@property (nonatomic, assign) NSInteger selectedSegmentIndex;
@property (nonatomic,strong) AJModelAJSegmentView *aAJModelAJSegmentView;

@property (nonatomic, weak) id<AJSegmentViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<AJSegmentViewDelegate>)delegate;
@end

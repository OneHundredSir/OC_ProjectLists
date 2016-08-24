//
//  XTListView.h
//  XTNews
//
//  Created by tage on 14-4-30.
//  Copyright (c) 2014年 XT. All rights reserved.
//

/**
 *  数据列表视图
 */

#import <UIKit/UIKit.h>
#import "AdScrollView.h"
#import "InformationViewController.h"
@interface XTListView : UIView

- (id)initWithFrame:(CGRect)frame;
- (void)headerViewData;
- (void)setupRefresh;
- (void)addContentView;
-(void)webData:(NSString *)typeId;

@property (nonatomic,strong)InformationViewController *InformationView;
@property (nonatomic,strong) UITableView *contentTableView;
@property (nonatomic, strong) AdScrollView *adScrollView;// 广告轮播图
@property (nonatomic,copy) NSString *typeIdStr;
@property (nonatomic,strong) NSMutableArray *tempArrays;


@end

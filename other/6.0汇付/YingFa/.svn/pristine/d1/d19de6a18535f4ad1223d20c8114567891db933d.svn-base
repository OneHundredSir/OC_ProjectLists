//
//  HomeListView.h
//  SP2P_6.1
//
//  Created by 李小斌 on 14-6-17.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HomeHeaderView.h"
#import "HomeViewController.h"

/**
 *  扩展展示类型
 */
typedef enum {
    
    HomeListViewTypeQuality,
    
    HomeListViewTypeFull
    
}HomeListViewType;

@interface HomeListView : UIView
@property (nonatomic) HomeListViewType type;

@property (nonatomic, strong) UITableView *contentTableView;

@property (nonatomic, strong) HomeHeaderView *headerView1;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) HomeViewController *HomeNAV;
@property (nonatomic, strong) NSMutableArray *qualityArr;
@property (nonatomic, strong) NSMutableArray *fullyArr;

- (void)addContentView:(NSMutableArray *)qualityArrr qualitydata:(NSMutableArray *)qualitydataArrr qualityIdArr:(NSMutableArray *)qualityIdArrr  full:(NSMutableArray *)fullyArr fullData:(NSMutableArray *)fullydataArr fullIdArr:(NSMutableArray *)fullIdArrr ;

- (id)initWithFrame:(CGRect)frame type:(HomeListViewType)type;

/**
 *  填充对象
 *
 */
- (void)fillTableWithObject:(id)object;

@end

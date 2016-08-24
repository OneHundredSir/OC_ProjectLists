//
//  MainPersonViewController.m
//  Flower
//
//  Created by HUN on 16/7/13.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "MainPersonViewController.h"

@interface MainPersonViewController ()

//专栏数据
@property(nonatomic,strong)NSMutableArray *columnArr;

//介绍
@property(nonatomic,strong)NSMutableArray *introduceArr;

//订阅者
@property(nonatomic,strong)NSMutableArray *bookArr;


@end


@implementation MainPersonViewController
#pragma mark lazyLoad;
-(NSMutableArray *)columnArr
{
    if (_columnArr == nil) {
        _columnArr = [NSMutableArray array];
    }
    return _columnArr;
}

-(NSMutableArray *)introduceArr
{
    if (_introduceArr == nil) {
        _introduceArr = [NSMutableArray array];
    }
    return _introduceArr;
}

-(NSMutableArray *)bookArr
{
    if (_bookArr == nil) {
        _bookArr = [NSMutableArray array];
    }
    return _bookArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
}



@end

//
//  ShopDetailTableView.m
//  FootLove
//
//  Created by HUN on 16/6/29.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "ShopDetailTableView.h"
#import "ShopDetailModel.h"
@interface ShopDetailTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *shopTelNum_LB;

@property (weak, nonatomic) IBOutlet UILabel *shopName_LB;

@property (weak, nonatomic) IBOutlet UILabel *JCount_LB;

@property (weak, nonatomic) IBOutlet UIScrollView *JScrollView;


@end

@implementation ShopDetailTableView

-(void)setModel:(ShopDetailModel *)model
{
    _model = model;
    
    //设置店铺电话
    
    //设置店铺名称
    
    //设置技师数目
    
    //设置技师的东西
    
    
}


@end

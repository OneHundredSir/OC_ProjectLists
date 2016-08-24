//
//  JSTableView.m
//  FootLove
//
//  Created by HUN on 16/6/30.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "JSTableView.h"

@interface JSTableView ()<UITableViewDataSource,UITableViewDelegate>
//说说
@property (weak, nonatomic) IBOutlet UILabel *shuoshuo_LB;
//门店
@property (weak, nonatomic) IBOutlet UILabel *mendian_LB;
//地址
@property (weak, nonatomic) IBOutlet UILabel *address_LB;
//员工
@property (weak, nonatomic) IBOutlet UILabel *staff_LB;

@end


@implementation JSTableView

-(void)setModel:(id)model
{
    _model = model;
    
    _shuoshuo_LB.text = nil;
    
    _mendian_LB.text = nil;
    
    _address_LB.text = nil;
    
    _staff_LB.text = nil;
    
}

#pragma mark delegate
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

@end

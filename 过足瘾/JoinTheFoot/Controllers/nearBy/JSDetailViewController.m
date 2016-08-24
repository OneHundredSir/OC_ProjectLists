//
//  JSDetailViewController.m
//  JoinTheFoot
//
//  Created by skd on 16/6/28.
//  Copyright © 2016年 lzm. All rights reserved.
//

#import "JSDetailViewController.h"
#import "JSDetailView.h"
#import "DetailCell.h"
@interface JSDetailViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatCRTS;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *YYCTS;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *CllCTS;

@property (nonatomic , strong) JSDetailView *detailview;
@property (nonatomic , weak) UITableView *tableview;

@end

@implementation JSDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat cts = (kScreen_W - (91 * 3)) /4.0;
    _chatCRTS.constant = cts;
    _YYCTS.constant = cts;
    _CllCTS.constant = cts;
    
//  加载xib
    self.detailview = [[[NSBundle mainBundle] loadNibNamed:@"JSDetailView" owner:nil options:nil] firstObject];

//    点语法  set方法
    self.detailview.jsModel = self.jsModel;
    
    
    [self.view addSubview:self.detailview];
    __block JSDetailViewController *temSelf = self;
    self.detailview.getDataFinished = ^(){
        [temSelf _loadTableView];
    };
//    返回按钮定义
    [self setLeftItem:nil OrImage:@"返回1"];
    self.leftAct = ^(UIButton *leftBtn){
        
        [temSelf.navigationController popViewControllerAnimated:YES];
    };


}

- (void)_loadTableView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:(CGRect){0,CGRectGetMaxY(self.detailview.frame),kScreen_W, kScreen_H - 64 - CGRectGetMaxY(self.detailview.frame) - 49}];
    self.tableview = tableView;
    tableView.separatorStyle = 0;
    tableView.delegate = self;
    tableView.dataSource = self;
    [_tableview registerNib:[UINib nibWithNibName:@"DetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
}

#pragma mark - 表视图代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.title.text = @"说说";
        cell.bgImageView.image = [UIImage imageNamed:@"边框"];
        
    }else if (indexPath.row == 1)
    {
        cell.title.text = @"门店";
        cell.name.text = [NSString stringWithFormat:@"%@",self.jsModel.shop_name];
        cell.num.text = [NSString stringWithFormat:@"工号：%@",self.jsModel.work_id];
        cell.bgImageView.image = [UIImage imageNamed:@"标题背景"];
    }else
    {
        cell.title.text = @"地址：";
        cell.name.text = [NSString stringWithFormat:@"%@",self.jsModel.shop_name];
        cell.bgImageView.image = [UIImage imageNamed:@"标题背景"];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
@end

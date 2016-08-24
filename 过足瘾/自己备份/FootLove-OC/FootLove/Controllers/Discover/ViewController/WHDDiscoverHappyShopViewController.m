//
//  WHDDiscoverHappyShopViewController.m
//  FootLove
//
//  Created by HUN on 16/6/30.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDDiscoverHappyShopViewController.h"
#import "WHDHappyShopHeaderView.h"
#import "WHDHappyShopTableViewCell.h"
#import "WHDDiscoverHappyShopHeaderModel.h"
#import "WHDDiscoverHappyShopCellModel.h"
@interface WHDDiscoverHappyShopViewController ()<UITableViewDataSource,UITableViewDelegate>

//配置头部
@property(nonatomic,weak) WHDHappyShopHeaderView *headerView ;

//配置tableView
@property (weak, nonatomic) IBOutlet UITableView *myTableView;



@end

@implementation WHDDiscoverHappyShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self configTable];
}


-(void)configTable
{
    self.automaticallyAdjustsScrollViewInsets = YES;
    //配置头部
    CGFloat hearderH = 100;
    WHDHappyShopHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"WHDHappyShopHeaderView" owner:nil options:nil] lastObject];
    headerView.frame = (CGRect){0,0,W_width,hearderH};
//    [[WHDHappyShopHeaderView alloc]initWithFrame:(CGRect){0,0,W_width,hearderH}];
    _headerView = headerView;
    _myTableView.tableHeaderView = headerView;
    [_myTableView reloadData];
    
    //配置下面
    [_myTableView registerNib:[UINib nibWithNibName:@"WHDHappyShopTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WHDHappyShopTableViewCell"];
    
    
}

#pragma mark datasoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WHDHappyShopTableViewCell *mycell = [tableView dequeueReusableCellWithIdentifier:@"WHDHappyShopTableViewCell"];
//    UITableViewCell *mycell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    return mycell;
}



@end

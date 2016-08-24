//
//  DetailViewController.m
//  FootLove
//
//  Created by HUN on 16/6/29.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self _initTableView];
}
#pragma mark 设置table
-(void)_initTableView
{
    _myTableView.mj_header = [MJRefreshNormalHeader  headerWithRefreshingBlock:^{
        [WHDHttpRequest  whdReuqestActionWith:nil and:nil andCompletion:^(NSData *wdata, NSURLResponse *wresponse, NSError *werror) {
            [_myTableView.mj_header endRefreshing];
        }];
    }];
}

#pragma mark dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
@end

//
//  WHDShopViewController.m
//  FootLove
//
//  Created by HUN on 16/6/28.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDShopViewController.h"
#import "WHDImgScrollView.h"
#import "ShopDetailTableView.h"
#import "ShopDetailModel.h"
@interface WHDShopViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation WHDShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _initTable];
}
#pragma mark 初始化
-(void)_initTable
{
    //设置上部分的滚动细节图
    CGFloat imgView_H = 80;
    WHDImgScrollView *imgShowView = [[WHDImgScrollView alloc]initWithFrame:(CGRect){0,0,W_width,imgView_H}];
    NSArray *Arr =@[];//测试用的
    [imgShowView initwhdSetAdViewWithImgUrlArr:Arr];
    [self.view addSubview:imgShowView];
    
    
    //设置
}

#pragma mark delegate

#pragma mark datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

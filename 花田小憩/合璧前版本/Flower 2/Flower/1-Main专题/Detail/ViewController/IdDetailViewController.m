//
//  IdDetailViewController.m
//  Flower
//
//  Created by HUN on 16/7/12.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "IdDetailViewController.h"
#import "MainTableModel.h"
#import "MainTableViewCell.h"
#import "MainDetailViewController.h"

@interface IdDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *modelArr;

@end

@implementation IdDetailViewController

-(NSMutableArray *)modelArr
{
    if (_modelArr == nil) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self _initTable];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(NSMutableDictionary *)paramas
{
    if (_paramas == nil) {
        _paramas = [NSMutableDictionary dictionary];
    }
    return _paramas;
}

NSString *CellID = @"MainTableViewCell";
-(void)_initTable
{
    
    _tableView.rowHeight = 300;
    [_tableView registerNib:[UINib nibWithNibName:CellID bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CellID];
    __block NSInteger index = 0;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.modelArr removeAllObjects];
        index = 0;
        [_paramas setValue:[NSString stringWithFormat:@"%d",index] forKey:@"currentPageIndex"];
        [self webActionWithUrl:MainBaseUrl AndParamas:_paramas];
    }];
//    NSLog(@"%@",self.paramas);
    _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        index++;
        [_paramas setValue:[NSString stringWithFormat:@"%d",index] forKey:@"currentPageIndex"];
        [self webActionWithUrl:MainBaseUrl AndParamas:_paramas];
    }];
    [_tableView.mj_header beginRefreshing];
}

-(void)webActionWithUrl:(NSString *)url AndParamas:(NSDictionary *)dic
{

    [WHDHttpRequest getHomeListWithparamters:_paramas andandCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {
        //数据加载完，把刷新结束
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if (!error) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSArray *arr = dic[@"result"];
            if (arr.count<=0) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }
            for (NSDictionary *result in arr) {
                MainTableModel *model = [MainTableModel mj_objectWithKeyValues:result];
                [self.modelArr addObject:model];
            }
            if (arr.count<=0) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            
            [_tableView reloadData];
            
        }else
        {
            NSLog(@"%@",error);
        }
        
    }];
}


#pragma mark delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MainDetailViewController *detailVC = [MainDetailViewController new];
    detailVC.view.frame = self.view.frame;
    detailVC.model = self.modelArr[indexPath.row];
    [detailVC setViewTitle: detailVC.model.title];
    [self.navigationController pushViewController:detailVC animated:YES];
    
    
}

#pragma mark datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    cell.model = self.modelArr[indexPath.row];
    return cell;
}
@end

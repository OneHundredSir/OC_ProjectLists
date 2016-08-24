//
//  WHDClassSeletedTableView.m
//  xiaorizi
//
//  Created by HUN on 16/6/6.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDClassSeletedTableView.h"
#import "WHDClassSeletedTableViewCell.h"
#import "WHDClassSeletedModel.h"
@interface WHDClassSeletedTableView ()
@property (strong, nonatomic) IBOutlet UITableView *table;


@property(nonatomic,strong)NSMutableArray *model_lists;
@end

@implementation WHDClassSeletedTableView

#pragma mark 懒加载
-(NSMutableArray *)model_lists
{
    if (_model_lists) {
        return _model_lists;
    }
    _model_lists=[NSMutableArray array];
    //获取路径
    NSString *path=[[NSBundle mainBundle] pathForResource:@"Details" ofType:nil];
    NSData *data=[NSData dataWithContentsOfFile:path];
    NSDictionary *getDic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *arr=getDic[@"list"];
    for (NSDictionary *modelDic in arr) {
        WHDClassSeletedModel *model=[WHDClassSeletedModel makeUpModel:modelDic];
        [_model_lists addObject:model];
    }
    NSLog(@"%d",_model_lists.count);
    return _model_lists;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTable];
}

-(void)setUpTable
{
    [_table registerNib:[UINib nibWithNibName:@"WHDClassSeletedTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WHDClassSeletedTableViewCell"];
    _table.rowHeight=200;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.model_lists.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WHDClassSeletedTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"WHDClassSeletedTableViewCell"];
    cell.model=self.model_lists[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WHDWebViewController *webVC=[[WHDWebViewController alloc]init];
    
    WHDClassSeletedModel *model =self.model_lists[indexPath.row];
    webVC.path=model.urlStr;
    [self.navigationController pushViewController:webVC animated:YES];
}

@end

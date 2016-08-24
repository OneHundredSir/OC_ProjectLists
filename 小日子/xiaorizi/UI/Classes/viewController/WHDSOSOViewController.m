//
//  WHDSOSOViewController.m
//  xiaorizi
//
//  Created by HUN on 16/6/7.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDSOSOViewController.h"

#import "WHDClassSeletedTableView.h"
#import "WHDClassSeletedModel.h"
#import "WHDClassSeletedTableViewCell.h"

@interface WHDSOSOViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UISearchBar *search;

//设置tableview
@property(nonatomic,strong)UITableView *table;

@property(nonatomic,strong)NSMutableArray *model_lists;

@end

@implementation WHDSOSOViewController
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


- (IBAction)searchWay:(UIButton *)sender {
    sender.selected=!sender.selected;
    if (sender.selected) {
        _scroll.contentOffset=(CGPoint){VIEWW,0};
    }else
    {
        _scroll.contentOffset=(CGPoint){0,0};
    }
}


- (IBAction)click:(WHDButton *)sender {
    _search.text=sender.titleLabel.text;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self makeUpScroll];
}

-(void)makeUpScroll
{
    _scroll.contentSize=(CGSize){VIEWW,0};
    _scroll.delegate=self;
    UITableView *table=[[UITableView alloc]initWithFrame:(CGRect){VIEWW,0,VIEWW,_scroll.frame.size.height}];
    [table registerNib:[UINib nibWithNibName:@"WHDClassSeletedTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WHDClassSeletedTableViewCell"];
    table.delegate=self;
    table.dataSource=self;
    
//    table.estimatedRowHeight=300;
//    table.rowHeight=UITableViewAutomaticDimension;
    table.rowHeight=250;
    [_scroll addSubview:table];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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

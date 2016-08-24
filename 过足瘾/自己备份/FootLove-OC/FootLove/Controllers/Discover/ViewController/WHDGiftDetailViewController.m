//
//  WHDGiftDetailViewController.m
//  FootLove
//
//  Created by HUN on 16/7/5.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDGiftDetailViewController.h"
#import "WHDGiftDetailTableViewOneCell.h"
#import "WHDWHDGiftDetailTableViewCell.h"
#import "WHDWHDGiftDetailTableViewThreeCell.h"
#import "DetailHeaderView.h"
#import "WHDDiscoverShopModel.h"


@interface WHDGiftDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property(nonatomic,strong)NSMutableArray *datasource;


@property (nonatomic , strong) WHDDiscoverShopModel *currentGiftModel;

@property (nonatomic , weak) DetailHeaderView *detaillHead;
@end

@implementation WHDGiftDetailViewController

-(NSMutableArray *)datasource
{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewTitle:@"商品详情"];
    [self _loadTableViewHeadview];
    [self getDataFromNetwork];
    
}
- (void)_loadTableViewHeadview
{
    
    DetailHeaderView *head = [[[NSBundle mainBundle] loadNibNamed:@"DetailHeaderView" owner:nil options:nil] firstObject];
    _detaillHead = head;
    _myTableView.tableHeaderView = head;
    [_myTableView registerNib:[UINib nibWithNibName:@"WHDGiftDetailTableViewOneCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"onecell"];
    [_myTableView registerNib:[UINib nibWithNibName:@"WHDWHDGiftDetailTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"twocell"];
    [_myTableView registerNib:[UINib nibWithNibName:@"WHDWHDGiftDetailTableViewThreeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"threecell"];
    
}

- (void)reloadUI
{
    
    _detaillHead.giftModel = _currentGiftModel;
    
}
- (IBAction)buyAction:(id)sender {
}

#pragma makr -网络加载
- (void)getDataFromNetwork
{
    
    //    1:准备一个作为接口调用参数的 字典
    NSMutableDictionary *pragram = [NSMutableDictionary dictionary];
    //    设置相关参数
    [pragram setObject:@1 forKey:@"appid"];
    [pragram setObject:[NSString stringWithFormat:@"%@",_gift_id] forKey:@"giftid"];
    
    [pragram setObject:@"BCCFFAAB6A7D79D1E6D1478F2B432B83CD451E2660F067BF" forKey:@"memberdes"];
    
    [WHDHttpRequest whdReuqestActionWith:@"http://gzy.api.kd52.com/gift.aspx?action=getgift" and:pragram andCompletion:^(NSData *wdata, NSURLResponse *wresponse, NSError *werror)
    {
        if (!werror) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:wdata options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            
            _currentGiftModel = [[WHDDiscoverShopModel alloc]initWithDic:dic[@"item"]];
            
            [self reloadUI];
        }else
        {
            
            //            错误处理
        }
        
    }];
    
}


- (IBAction)goToShopping:(UIButton *)sender
{
    
}

#pragma mark delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        return [tableView dequeueReusableCellWithIdentifier:@"onecell" forIndexPath:indexPath];
    }else if (indexPath.section == 1)
    {
        return [tableView dequeueReusableCellWithIdentifier:@"twocell" forIndexPath:indexPath];
    }else
    {
        
        return [tableView dequeueReusableCellWithIdentifier:@"threecell" forIndexPath:indexPath];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

@end

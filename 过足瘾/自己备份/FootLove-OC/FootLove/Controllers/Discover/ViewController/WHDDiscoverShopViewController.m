//
//  WHDDiscoverShopViewController.m
//  FootLove
//
//  Created by HUN on 16/6/30.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDDiscoverShopViewController.h"
#import "WHDDiscoverShopTableViewCell.h"
#import "WHDDiscoverShopModel.h"
#import "WHDGiftDetailViewController.h"
@interface WHDDiscoverShopViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property(nonatomic,strong)NSMutableArray *model_arr;

@end

@implementation WHDDiscoverShopViewController
#pragma mark lazyload
-(NSMutableArray *)model_arr
{
    if (_model_arr == nil) {
        _model_arr = [NSMutableArray array];
    }
    return _model_arr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self _initTable];
    [self getNetWorking];
    
}

-(void)_initTable
{
    [_myTableView registerNib:[UINib nibWithNibName:@"WHDDiscoverShopTableViewCell" bundle:[NSBundle mainBundle] ] forCellReuseIdentifier:@"Cell"];
    _myTableView.rowHeight= UITableViewAutomaticDimension;
    _myTableView.estimatedRowHeight = 10;
}

-(void)getNetWorking
{
    //    1:准备一个作为接口调用参数的 字典
    NSMutableDictionary *pragram = [NSMutableDictionary dictionary];
    //    设置相关参数
    [pragram setObject:@1 forKey:@"appid"];
    [pragram setObject:@1 forKey:@"giftkindid"];
    
    [pragram setObject:@"BCCFFAAB6A7D79D1E6D1478F2B432B83CD451E2660F067BF" forKey:@"memberdes"];
    
    [WHDHttpRequest whdReuqestActionWith:@"http://gzy.api.kd52.com/gift.aspx?action=getallgift" and:pragram andCompletion:^(NSData *wdata, NSURLResponse *wresponse, NSError *werror) {
        if (!werror) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:wdata options:NSJSONReadingMutableContainers error:nil];
            for (NSDictionary *temDic in dic[@"item"]) {
                WHDDiscoverShopModel *gm  = [[WHDDiscoverShopModel alloc]initWithDic:temDic];
                [self.model_arr addObject:gm];
            }
            [_myTableView reloadData];
        }else
        {
            NSLog(@"发现商品页面请求错误，错误:%@",werror);
        }
    }];
}

#pragma mark 技术页
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model_arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WHDDiscoverShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.model = self.model_arr[indexPath.row];
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WHDGiftDetailViewController *vc = [[WHDGiftDetailViewController alloc]init];
    WHDDiscoverShopModel *model = self.model_arr[indexPath.row];
    vc.gift_id = model.gift_id;
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end

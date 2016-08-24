//
//  ShopDetailTableView.m
//  FootLove
//
//  Created by HUN on 16/6/29.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "ShopDetailTableView.h"
@interface ShopDetailTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *shopTelNum_LB;

@property (weak, nonatomic) IBOutlet UILabel *shopName_LB;

@property (weak, nonatomic) IBOutlet UILabel *JCount_LB;

@property (weak, nonatomic) IBOutlet UIScrollView *JScrollView;


@end

@implementation ShopDetailTableView

-(void)setModel:(ShopDetailModel *)model
{
    _model = model;
    
    NSString *tmp =@"";
    //设置店铺电话
    _shopTelNum_LB.text = tmp;
    //设置店铺名称
    _shopName_LB.text = tmp;
    //设置技师数目
    _JCount_LB.text = tmp;
    //------设置技师的东西-----//
    CGFloat totalShowNum = 6.0;
    CGFloat maginX = 5;
    CGFloat maginY = 5;
    //每排只能放6个
    CGFloat imageWH = (W_width - (totalShowNum+1) * maginX)/totalShowNum;
    _JScrollView.contentSize =(CGSize){};
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:(CGRect){(maginX+imageWH),maginY,imageWH,imageWH}];
    [_JScrollView addSubview:imageV];
    
}


#pragma mark delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)//第一排
    {
        if (indexPath.row == 0)//店铺介绍，不是webview是自己自定义的一个坑爹的view
        {
            
            UIViewController *vc =[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ShopDETAIL"];
            vc.title = self.title;
            [self.navigationController  pushViewController:vc animated:YES];
        }else if(indexPath.row == 1)//打电话，弹出一个提示框
        {
            UIAlertController *telController = [UIAlertController alertControllerWithTitle:nil message:_shopTelNum_LB.text preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *tel_call = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //这里要启动打电话
                [[UIApplication sharedApplication] openURL:nil];
            }];
            
            UIAlertAction *tel_cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [telController addAction:tel_call];
            [telController addAction:tel_cancel];
            [self presentViewController:telController animated:YES completion:nil];
        }else if(indexPath.row == 2)//打开地图
        {
            UIViewController *vc =[UIViewController new];
            vc.title = self.title;
            [self.navigationController  pushViewController:vc animated:YES];
        }
    }else
    {
        if (indexPath.row == 0)//技师列表
        {
            UIViewController *vc =[UIViewController new];
            vc.title = self.title;
            [self.navigationController  pushViewController:vc animated:YES];
        }else if(indexPath.row == 1)//项目列表
        {
            UIViewController *vc =[UIViewController new];
            vc.title = @"本店项目";
            [self.navigationController  pushViewController:vc animated:YES];
        }
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 20;
    }
    return 0.01;
}



@end

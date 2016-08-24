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
#import "ShopDetailJSModel.h"
#import "ShopDetailModel.h"
#import "ShopDetailSkillModel.h"
@interface WHDShopViewController ()

@property(nonatomic,strong)ShopDetailModel *model;

@property(nonatomic,strong)NSArray *detailImgUrlArrs;

@end

@implementation WHDShopViewController

#pragma mark 懒加载
-(ShopDetailModel *)model
{
    if (_model == nil) {
        _model = [ShopDetailModel new];
    }
    return _model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _initNaviBar];
    [self _initTable];
}
#pragma mark - 网络请求//需要上一层传东西过来,所以我们要看看
-(void)_initWebRequest
{
    #pragma mark 请求第一部分数据
    //设置请求第一页数据
    NSString *urlStr = @"http://gzy.api.kd52.com/shop.aspx?action=getshopbyid";
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    [dic setObject:@1 forKey:@"appid"];
    [dic setObject:_shopId forKey:@"499562"];
    //以下两个不知道是否必要
    [dic setObject:@"69c00b2a841b74e3f6" forKey:@"sign"];
    [dic setObject:@"F55B38250E5CF1AB8A43568EED88E83A184FAB9E157969B058EE898A063E4953" forKey:@"memberdes"];
    
    [WHDHttpRequest  whdReuqestActionWith:urlStr and:dic andCompletion:^(NSData *wdata, NSURLResponse *wresponse, NSError *werror) {
        //数据就转出来
        //下面数组就是装这模型的字典数据
        NSDictionary *showDic =[NSDictionary dictionary];
        if (wdata) {
            showDic = [NSJSONSerialization JSONObjectWithData:wdata options:NSJSONReadingMutableContainers error:nil];
        }else
            showDic = @{@"data":@[]};
        
        NSDictionary *dic = showDic[@"data"];
        //分别获取店铺名称，电话，地址
        self.model.titleStr = dic[@"shop_name"];
        self.model.telStr = dic[@"shop_name"];
        self.model.adrStr = dic[@"shop_name"];
        if (werror) {
            NSLog(@"啦啦啦发生错误了....%@",werror);
        }
    }];
    
    #pragma mark 请求第二部分数据(图片数据)
    NSString *urlStr2 = @"http://gzy.api.kd52.com/shop.aspx?action=getphotos";
    NSMutableDictionary *dic2 =[NSMutableDictionary dictionary];
    [dic setObject:@1 forKey:@"appid"];
    [dic setObject:_shopId forKey:@"499562"];
    
    
    
    [WHDHttpRequest  whdReuqestActionWith:urlStr2 and:dic2 andCompletion:^(NSData *wdata, NSURLResponse *wresponse, NSError *werror) {
        //数据就转出来
        //下面数组就是装这模型的字典数据
        NSArray *showDic =[NSArray array];
        if (wdata) {
            showDic = [NSJSONSerialization JSONObjectWithData:wdata options:NSJSONReadingMutableContainers error:nil];
        }else
            showDic = @[];
        
        NSMutableArray *arrImgUrls =[NSMutableArray array];
        for (NSDictionary *dic in showDic) {
            NSString *url = dic[@"image_path"];
            [arrImgUrls addObject:url];
        }
        //获取详情数组
        self.detailImgUrlArrs = arrImgUrls;
        
        if (werror) {
            NSLog(@"啦啦啦发生错误了....%@",werror);
        }
    }];
    
#pragma mark 请求第三部分数据(人头像和细节),装到模型中
    NSString *urlStr3 = @"http://gzy.api.kd52.com/shop.aspx?action=getshopbyid";
    NSMutableDictionary *dic3 =[NSMutableDictionary dictionary];
    [dic setObject:@1 forKey:@"appid"];
    [dic setObject:_shopId forKey:@"499562"];

    
    [WHDHttpRequest  whdReuqestActionWith:urlStr3 and:dic3 andCompletion:^(NSData *wdata, NSURLResponse *wresponse, NSError *werror) {
        //数据就转出来
        //下面数组就是装这模型的字典数据
        NSArray *showDic =[NSArray array];
        if (wdata) {
            showDic = [NSJSONSerialization JSONObjectWithData:wdata options:NSJSONReadingMutableContainers error:nil];
        }else
            showDic = @[];
        NSMutableArray *modelArr =[@[] mutableCopy];
        for (NSDictionary *dic in showDic) {
            ShopDetailJSModel *model =[ShopDetailJSModel shopSetWithDictionary:dic];
            [modelArr addObject:model];
        }
        
        self.model.JS_Arr = modelArr;
        
        
        if (werror) {
            NSLog(@"啦啦啦发生错误了....%@",werror);
        }
    }];
    
    
#pragma mark 请求第四部分技艺数据
    NSString *urlStr4 = @"http://gzy.api.kd52.com/shop.aspx?action=getshopbyid";
    NSMutableDictionary *dic4 =[NSMutableDictionary dictionary];
    [dic setObject:@1 forKey:@"appid"];
    [dic setObject:_shopId forKey:@"499562"];
    //以下两个不知道是否必要
    [dic setObject:@"100" forKey:@"size"];
    [dic setObject:@"F55B38250E5CF1AB8A43568EED88E83A184FAB9E157969B058EE898A063E4953" forKey:@"memberdes"];
    [dic setObject:@1 forKey:@"page"];
    
    
    [WHDHttpRequest  whdReuqestActionWith:urlStr4 and:dic4 andCompletion:^(NSData *wdata, NSURLResponse *wresponse, NSError *werror) {
        //数据就转出来
        //下面数组就是装这模型的字典数据
        NSDictionary *showDic =[NSDictionary dictionary];
        if (wdata) {
            showDic = [NSJSONSerialization JSONObjectWithData:wdata options:NSJSONReadingMutableContainers error:nil];
        }else
            showDic = @{@"data":@""};
        NSArray *arr = showDic[@"data"];
        NSMutableArray *modelArr =[@[] mutableCopy];
        for (NSDictionary *dic in arr) {
            ShopDetailSkillModel *model =[ShopDetailSkillModel shopSetWithDictionary:dic];
            [modelArr addObject:model];
        }
        
        self.model.project_Arr = modelArr;
        
        
        if (werror) {
            NSLog(@"啦啦啦发生错误了....%@",werror);
        }
    }];
    
}

#pragma mark 头部
-(void)_initNaviBar
{
    [self setRightBtn:@"3点" andTitle:nil];
    __weak WHDShopViewController *weakSelf = self;
    self.rightBtnBlock=^{
      
        UIAlertController *alController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *al_shopDetail = [UIAlertAction actionWithTitle:@"门店详情" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *al_discountCard = [UIAlertAction actionWithTitle:@"我要优惠券" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIViewController *discountCardVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"discountCardVC"];
            discountCardVC.title = @"门店优惠券";
            [weakSelf.navigationController pushViewController:discountCardVC animated:YES];
        }];
        
        UIAlertAction *al_cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alController addAction:al_shopDetail];
        [alController addAction:al_discountCard];
        [alController addAction:al_cancel];
        [weakSelf presentViewController:alController animated:YES completion:nil];
        
    };
}

#pragma mark 初始化界面
-(void)_initTable
{
    //设置上部分的滚动细节图
    CGFloat imgView_H = 80;
    WHDImgScrollView *imgShowView = [[WHDImgScrollView alloc]initWithFrame:(CGRect){0,0,W_width,imgView_H}];
//    NSArray *Arr =@[@"店铺默认图"];//测试用的
    [imgShowView initwhdSetAdViewWithImgUrlArr:self.detailImgUrlArrs];
    [self.view addSubview:imgShowView];
    
    
    //设置
    ShopDetailTableView *tableViewVC =[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ShopDetailTableView"];
    tableViewVC.view.frame = CGRectMake(0,imgView_H , W_width, W_height - imgView_H);
    
    [self addChildViewController:tableViewVC];
    [self.view addSubview:tableViewVC.view];
    
    
}




@end

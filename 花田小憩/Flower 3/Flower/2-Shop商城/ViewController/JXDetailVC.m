//
//  JXDetailVC.m
//  Flower
//
//  Created by maShaiLi on 16/7/15.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "JXDetailVC.h"
#import "AheaderView.h"
#import "JXdetail.h"

//路径
#define fnCustomerId @"c5e04522-36cd-46a4-a77e-4bcf3bd2f975"
#define fnHeader @"http://ec.htxq.net/rest/htxq/goods/detail/"

@interface JXDetailVC ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *JscorllView;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *count;

@property (nonatomic,assign) int num;


#pragma mark - view
@property (nonatomic,strong) AheaderView *header;

@property (nonatomic,strong) UIWebView *web;

@property (nonatomic,assign) CGFloat webHeight;


#pragma mark - data

@property (nonatomic,strong) JXdetail *DETmodel;



@end

@implementation JXDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getDataFormNet:_model.fnId];

}

#pragma mark - 懒加载
//- (NSMutableArray *)dataArr
//{
//    if (!_dataArr) {
//        _dataArr = [@[] mutableCopy];
//    }
//    return _dataArr;
//}

#pragma mark - 加载数据
- (void)getDataFormNet:(id)pram
{
    //拼接请求路径
    NSString  *strPath = [NSString stringWithFormat:@"%@%@?%@",fnHeader,pram,fnCustomerId];
    NSLog(@"%@",strPath);
    //发起请求
    [WHDHttpRequest ReuqestGetActionWithUrlString:strPath and:nil andCompletion:^(NSData *wdata, NSURLResponse *wresponse, NSError *werror) {
        if (!werror) {
            //~~~~~~~~~~~~~~~~~~~~~~
            //解析
            NSDictionary *dict0 = [NSJSONSerialization JSONObjectWithData:wdata options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dict1 = dict0[@"result"][@"goods"];
            NSLog(@"%@",dict1);
            _DETmodel = [JXdetail mj_objectWithKeyValues:dict1];
            dispatch_async(dispatch_get_main_queue(), ^{
                 [self initWithUI];
            });
        }
        
    }];
}

#pragma mark - UI
- (void)initWithUI
{
    self.view.backgroundColor = [UIColor grayColor];
    [self setViewTitle:_model.fnName];
//    __weak JXDetailVC *temp = self;
//    self.leftBtnBlock = ^(UIButton *btn)
//    {
//        [temp dismissViewControllerAnimated:YES completion:nil];
//    };
    
    //~~~~~~~~~~~~~~~~~~~~~~
    //headerView
    _header = [[NSBundle mainBundle]loadNibNamed:@"AheaderView" owner:nil options:nil].firstObject;
    _header.frame = CGRectMake(0, 0, k_width, 540);
    _header.model = _DETmodel;
    [_JscorllView addSubview:_header];
    
    //~~~~~~~~~~~~~~~~~~~~~~
    //web
    _web = [[UIWebView alloc]initWithFrame:(CGRect){0,540,k_width,1000}];
    _web.delegate = self;
//    //~~~~~~~~~~~~~~~~~~~~~~
//    //拼接网页
    
    NSString *WebStr = [NSString stringWithFormat:@"%@%@%@%@",_DETmodel.fnSecondDesc,_DETmodel.fnThreeDesc,_DETmodel.fnFourthDesc,_DETmodel.fnFifthDesc];
    [_web loadHTMLString:WebStr baseURL:nil];
    _web.scalesPageToFit = YES;
    [_JscorllView addSubview:_web];
    //~~~~~~~~~~~~~~~~~~~~~~
    //scrollView
    _JscorllView.contentSize = CGSizeMake(0, 540 + 1000);
    _JscorllView.showsVerticalScrollIndicator = NO;
    _JscorllView.showsHorizontalScrollIndicator = NO;
    _JscorllView.bounces = YES;
    
    //~~~~~~~~~~~~~~~~~~~~~~
    //购物车
    _price.text = [NSString stringWithFormat:@"￥%ld",_DETmodel.fnMarketPrice];
    _count.layer.cornerRadius = 6.0;
    _count.layer.masksToBounds = YES;
    _count.text = [NSString stringWithFormat:@"%d",_num];
    _count.alpha = 0;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
}
- (IBAction)addBagAction:(UIButton *)sender {
     _num++;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _count.alpha = 1;
    });
    _count.layer.masksToBounds = YES;
    _count.text = [NSString stringWithFormat:@"%d",_num];
}

- (IBAction)buyAction:(id)sender {
}



//
//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    _webHeight = [[_web stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
//    //设置高度
//    _JscorllView.contentSize = CGSizeMake(0, 540+_webHeight);
//}

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

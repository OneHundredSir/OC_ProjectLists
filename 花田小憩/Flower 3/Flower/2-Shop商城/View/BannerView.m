//
//  BannerView.m
//  过足瘾
//
//  Created by maShaiLi on 16/6/29.
//  Copyright © 2016年 maShaiLi. All rights reserved.
//

#import "BannerView.h"
#import <UIButton+WebCache.h>
//图片个数
#define imgNum 3
#define BtnW self.hScrollView.frame.size.width


@interface BannerView ()<UIScrollViewDelegate>

//view
@property (weak, nonatomic) IBOutlet UIScrollView *hScrollView;

@property (weak, nonatomic) IBOutlet UIPageControl *hPage;

@property (weak, nonatomic) IBOutlet UIButton *Lbtn;

@property (weak, nonatomic) IBOutlet UIButton *Mbtn;

@property (weak, nonatomic) IBOutlet UIButton *Rbtn;

@property (weak, nonatomic) IBOutlet UIView *underView;


@property (nonatomic,strong) CALayer *underLayer;

//data
@property (nonatomic,strong) NSMutableArray *adArr;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,assign) NSInteger page;

@end

@implementation BannerView

- (NSMutableArray *)adArr
{
    if (!_adArr) {
        _adArr = [NSMutableArray array];
    }
    return _adArr;
}

//~~~~~~~~~~~~~~~~~~~~~~
//获取数据
- (void)getDataFromNet:(NSString *)url
{
    //设置请求
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSLog(@"%@",url);
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //解析数据
        if (!error) {
            NSDictionary *dict  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray *arr = dict[@"result"];
            dict = [arr firstObject];
            if (arr.count != 0) {
                //获取图片链接,由于数据原因，此时只能加载一样的图片
                NSString *str = dict[@"fnImageUrl"];
                for (int i = 0; i < imgNum; i++) {
                    [self.adArr addObject:str];
                }
            }
            
            //回到主线程显示UI
            dispatch_async(dispatch_get_main_queue(), ^{
                [self initWithUI];
            });

        }else
            NSLog(@"广告栏加载数据错误");
        
    }];
    [task resume];
    
    
}

- (void)initWithUI
{
    //清空
    for (UIButton *btn in self.hScrollView.subviews) {
        [btn removeFromSuperview];
    }
    //添加
    for (int i = 0; i < imgNum; i++) {
        CGFloat H = self.hScrollView.frame.size.height;
        UIButton *btn = [[UIButton alloc]initWithFrame:(CGRect){BtnW * i,0,BtnW,H}];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        if (self.adArr.count == 0) {
            [btn setImage:[UIImage imageNamed:@"default.jpg"] forState:UIControlStateNormal];
        }else
        {
            [btn sd_setImageWithURL:[NSURL URLWithString:self.adArr[i]] forState:UIControlStateNormal];
            
        }
        
        //添加lbl
        UILabel *lblCount = [[UILabel alloc]initWithFrame:(CGRect){15,30,100,10}];
        lblCount.text = [NSString stringWithFormat:@"第%d页",i+1];
        lblCount.textAlignment = NSTextAlignmentCenter;
        lblCount.textColor = [UIColor whiteColor];
        lblCount.font = font(22);
        [btn addSubview:lblCount];
        
        [self.hScrollView addSubview:btn];
    }
    _hScrollView.pagingEnabled = YES;
    if (self.adArr.count != 0) {
        _hPage.numberOfPages = self.adArr.count;
        _hScrollView.contentSize = CGSizeMake(BtnW * self.adArr.count, 0);
    }else
    {   _hPage.numberOfPages = imgNum;
        _hScrollView.contentSize = CGSizeMake(BtnW * imgNum, 0);
    }
    _hScrollView.showsHorizontalScrollIndicator = NO;
    _hScrollView.showsVerticalScrollIndicator = NO;
    _hScrollView.delegate  = self;
    
    //~~~~~~~~~~~~~~~~~~~~~~
    //设置按钮所在view
    _underLayer = [[CALayer alloc]init];
    _underLayer.cornerRadius = 1.5f;
    _underLayer.backgroundColor = [UIColor blackColor].CGColor;
    _underLayer.frame = CGRectMake(0, 0, 32, 3);
    CGPoint center = _Lbtn.center;
    center.y = CGRectGetMaxY(_Lbtn.frame) + 2;
    _underLayer.position = center;
    [self.underView.layer addSublayer:_underLayer];
    
    //~~~~~~~~~~~~~~~~~~~~~~
    //定时器
//    self.timer  = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(changePage) userInfo:nil repeats:YES];
}

#pragma mark - 三个按钮事件
- (IBAction)selectAction:(UIButton *)sender {
    //~~~~~~~~~~~~~~~~~~~~~~
    //改变选中按钮
    _Lbtn.selected = _Mbtn.selected = _Rbtn.selected = NO;
    sender.selected = YES;
    
    //~~~~~~~~~~~~~~~~~~~~~~
    //改变layer的位置
    CGPoint center = sender.center;
    center.y = CGRectGetMaxY(sender.frame) + 2;
    _underLayer.frame = CGRectMake(0, 0, 32, 3);
    _underLayer.position = center;
    
    //~~~~~~~~~~~~~~~~~~~~~~
    //调用block
    if (_btnBlock) {
        _btnBlock(sender);
    }
    
}


#pragma mark - scroll点击事件
- (void)btnAction:(UIButton *)btn
{
    if (self.advModelBlock) {
        _advModelBlock();
    }
    
}

#pragma mark - 自动滑动
- (void)changePage
{
    if (self.page < self.adArr.count-1) {
        _page ++;
        CGFloat offset = BtnW * self.page;
        [_hScrollView setContentOffset:(CGPoint){offset,0} animated:YES];
    }else
    {
        _page = 0;
        [_hScrollView setContentOffset:(CGPoint){0,0} animated:YES];
    }
    self.hPage.currentPage = _page;
}

#pragma mark - 滑动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = (scrollView.contentOffset.x + BtnW/2)/BtnW;
    self.hPage.currentPage = page;
}
@end

//
//  AdvHeaderView.m
//  JoinTheFoot
//
//  Created by skd on 16/6/28.
//  Copyright © 2016年 lzm. All rights reserved.
//

#import "AdvHeaderView.h"

#import "UIButton+WebCache.h"


@interface AdvHeaderView () <UIScrollViewDelegate>
//scrollview
@property (weak, nonatomic) IBOutlet UIScrollView *bannerScroll;
//pagecontrol
@property (weak, nonatomic) IBOutlet UIPageControl *pagecontrol;
//存放广告模型的数组
@property (nonatomic , strong) NSMutableArray *items;

@end

@implementation AdvHeaderView

//加载网络事件 并且处理UI的方法
- (void)setAdvertismentWithUrl:(NSString *)url pragram:(NSDictionary *)pragam
{


    [WDHttpRequest postWithURL:url pragram:pragam completion:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
//            处理结果
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            初始化数组
            _items = [NSMutableArray array];
//            解析封装模型
            for (NSDictionary *temDic in dic[@"item"]) {
                AdvModel *am = [[AdvModel alloc]initWith:temDic];
                [_items addObject:am];
            }
//            根据下载的结果 刷新（显示UI）
            [self reloadSubviews];
            
        }else
        {
        
        }
        
    }];

}
- (void)reloadSubviews
{
//如果下载的结果无数据 就什么也不做
    if (_items.count <= 0) {
//        如果真是这样，可以给张默认图
        return;
    }
    
//    先清空所有的按钮（防止多次调用这个方法，这样的话会不断的往scrollview里面增加子视图，覆盖）
    for (UIButton *btn in _bannerScroll.subviews) {
        [btn removeFromSuperview];
    }
    
//    遍历item 不断创建图片 （按钮）追加到scrollview中
    
    for (int i = 0; i < _items.count; i ++) {
        
        UIButton *img = [[UIButton alloc]initWithFrame:(CGRect){i * self.frame.size.width , 0 ,self.frame.size.width,self.frame.size.height}];
        img.tag = i + 100;
         AdvModel *currentM =_items[i];
        [img addTarget:self action:@selector(advAction:) forControlEvents:UIControlEventTouchUpInside];
        [img sd_setImageWithURL:[NSURL URLWithString:currentM.image_path] forState:UIControlStateNormal];
        [self.bannerScroll addSubview:img];
        
    }
//    设置scrollview的相关属性和当前爬个 control的页数
    
    _pagecontrol.numberOfPages = _items.count;
    _bannerScroll.contentSize = CGSizeMake(_items.count * self.frame.size.width , 0);
    _bannerScroll.pagingEnabled = YES;
    _bannerScroll.showsHorizontalScrollIndicator = NO;
    _bannerScroll.showsVerticalScrollIndicator = NO;
    _bannerScroll.delegate = self;

}

#pragma mark - 广告点击事件
- (void)advAction:(UIButton *)btn
{
//通过tag判断点击了哪一个按钮，然后从这个对应tag取出数组中对应的模型
    AdvModel *currentM =_items[btn.tag - 100];
//    通过block将这个模型抛出去，交给对应的控制器去接收
    if (self.tapADV) {
        self.tapADV(currentM);
    }
    

}
//用来让scrollview的滑动和pagecontol的显示 同步
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

    NSInteger index = scrollView.contentOffset.x / self.frame.size.width;

    _pagecontrol.currentPage = index;

}
@end

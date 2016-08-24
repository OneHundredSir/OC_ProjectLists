//
//  MenuView.m
//  Flower
//
//  Created by HUN on 16/7/9.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "MenuView.h"

@interface MenuView ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;



@end



@implementation MenuView


-(void)_setScrollViewWithTitleArray:(NSArray<NSString *> *)titleArr
{
    CGSize fontSize = [titleArr[0] sizeWithFont:font(13) constrainedToSize:CGSizeMake(MAXFLOAT, 40)];
    CGFloat magin = _scrollView.frame.size.height*0.08;
    NSInteger totalNum = titleArr.count;
    CGFloat scrollViewContentH = fontSize.height * totalNum + magin * (totalNum + 1);
    _scrollView.delegate = self;
    _scrollView.contentSize = (CGSize){k_width,scrollViewContentH};
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    CGFloat btnW = fontSize.width+magin*2;
    CGFloat btnH = fontSize.height;
    
    //这里开始家东西
    for (int i=0; i<totalNum; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = (CGRect){(k_width - btnW)/2.0,magin + (magin+btnH)*i,btnW,btnH};
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        if (i==0 || i==totalNum-1) {
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }else
        {
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
        
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i+10;
        [_scrollView addSubview:btn];
    }
}

-(void)btnAction:(UIButton *)btn
{
    if (self.btnBlock) {
        self.btnBlock(btn);
    }
}

@end

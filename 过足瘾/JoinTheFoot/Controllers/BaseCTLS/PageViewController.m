//
//  PageViewController.m
//  JoinTheFoot
//
//  Created by skd on 16/6/27.
//  Copyright © 2016年 lzm. All rights reserved.
//

#import "PageViewController.h"

@interface PageViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *pageScrollview;

@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initSubviews];
}

- (void)_initSubviews
{
    NSArray *images = @[@"引导页1",@"引导页2",@"引导页3",@"引导页4",@"引导页5"];

    for (int i = 0; i < images.count; i ++) {
        UIImageView *img = [[UIImageView alloc]initWithFrame:(CGRect){kScreen_W * i , 0 , kScreen_W,kScreen_H}];
        [img setImage:[UIImage imageNamed:images[i]]];
        [self.pageScrollview addSubview:img];
        if (i == 4) {
            UIButton *btn = [[UIButton alloc]initWithFrame:(CGRect){(kScreen_W - 150) / 2, kScreen_H - 125 , 150 , 45}];
            [img setUserInteractionEnabled:YES];
            [btn addTarget:self action:@selector(intoHomePage:) forControlEvents:UIControlEventTouchUpInside];
            [img addSubview:btn];
        }
        
    }

    self.pageScrollview.contentSize = CGSizeMake(kScreen_W *images.count, 0);
    
    self.pageScrollview.showsHorizontalScrollIndicator = NO;
    self.pageScrollview.showsVerticalScrollIndicator = NO;
    self.pageScrollview.pagingEnabled = YES;
    
}
- (void)intoHomePage:(UIButton *)sender
{
    if (self.hinddenPage) {
        self.hinddenPage();
    }

}
@end

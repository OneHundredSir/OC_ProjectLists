//
//  AJSearchBar.m
//  SP2P_7
//
//  Created by Ajax on 16/1/15.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "AJSearchBar.h"

@implementation AJSearchBar

- (instancetype)initWithFrame:(CGRect)frame searchBlock:(AJSearchBarSearchBlock)searchBlock
{
    if (self = [super initWithFrame:frame]) {
       // 右边放大镜
        UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *img = [UIImage imageNamed:@"invest_searchBar"];
        [searchBtn setImage:img forState:UIControlStateNormal];
        self.rightView = searchBtn;
        self.rightViewMode = UITextFieldViewModeAlways;
        [searchBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        searchBtn.bounds = CGRectMake(0, 0, img.size.width + 20, img.size.height);
        self.borderStyle = UITextBorderStyleRoundedRect;
        self.backgroundColor = [UIColor colorWithRed:218.f/255 green:76.f/255 blue:72.f/255 alpha:1];
        self.returnKeyType = UIReturnKeySearch;
        self.enablesReturnKeyAutomatically = YES;
        
        self.searchBlock = searchBlock;
    }
    return self;
}
- (void)btnClick:(UIButton *)sender
{
    self.searchBlock(self);
}
@end

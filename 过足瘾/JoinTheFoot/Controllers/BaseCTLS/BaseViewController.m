//
//  BaseViewController.m
//  JoinTheFoot
//
//  Created by skd on 16/6/27.
//  Copyright © 2016年 lzm. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    tabbarHidden(YES)
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    设置当前视图的背景颜色
    [self.view setBackgroundColor:bg_color];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    


}

//左边按钮
- (void)setLeftItem:(NSString *)title OrImage:(NSString *)image
{
    
    UIButton *left = [[UIButton alloc]init];
    
    if (title) {
        
        CGSize titleSize = [title sizeWithFont:font(13) constrainedToSize:(CGSize){MAXFLOAT,44}];
        left.frame = CGRectMake(0, 0, titleSize.width + 5, 44);
        [left setTitle:title forState:UIControlStateNormal];
        
        
    }else
    {
        UIImage *leftimage = [UIImage imageNamed:image];
    
        left.frame = CGRectMake(0, 0, leftimage.size.width + 5, 44);
        [left setImage:leftimage forState:UIControlStateNormal];
    
    }
    

    [left addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:left];
    self.navigationItem.leftBarButtonItem = item;
    
}

//顶部按钮
- (void)setTopView:(NSString *)title
{
    UILabel *top = [[UILabel alloc]initWithFrame:(CGRect){0,0,200,44}];
    [top setTextAlignment: NSTextAlignmentCenter];
    top.textColor = [UIColor whiteColor];
    top.font = font(19);
    top.text = title;
    self.navigationItem.titleView = top;

}

//右边按钮
- (void)setRightItem:(NSString *)title OrImage:(NSString *)image
{
    UIButton *right = [[UIButton alloc]init];
    
    if (title) {
        
        CGSize titleSize = [title sizeWithFont:font(13) constrainedToSize:(CGSize){MAXFLOAT,44}];
        right.frame = CGRectMake(0, 0, titleSize.width + 5, 44);
        [right setTitle:title forState:UIControlStateNormal];
        
        
    }else
    {
        UIImage *rightimage = [UIImage imageNamed:image];
        
        right.frame = CGRectMake(0, 0, rightimage.size.width + 5, 44);
        [right setImage:rightimage forState:UIControlStateNormal];
        
    }
    
    
    [right addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = item;
    
}


#pragma mark - itemActions
- (void)leftAction:(UIButton *)sender
{

    if (self.leftAct) {
        self.leftAct(sender);
    }
}

- (void)rightAction:(UIButton *)sender
{
    if (self.rightAct) {
        self.rightAct(sender);
    }
}
@end

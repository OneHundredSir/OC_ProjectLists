//
//  WHDViewController.m
//  xiaorizi
//
//  Created by HUN on 16/6/1.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDViewController.h"
#import "WHDSeletedcities.h"
#import "WHDSeletedcities.h"
#import "AppDelegate.h"
@interface WHDViewController ()
@property(nonatomic,strong)UIButton *mybtn;


@end

@implementation WHDViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpLeftBarItem];
}


-(void)setUpLeftBarItem
{
    //由于设置单例，所以先不动，看看能不能用单例
    UIButton *leftbtn=[[UIButton alloc]initWithFrame:(CGRect){0,0,VIEWW/6.0,44}];
    [leftbtn setTitle:@"北京" forState:UIControlStateNormal];
    _mybtn=leftbtn;
    [leftbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    leftbtn.titleLabel.font=[UIFont systemFontOfSize:14];
    leftbtn.titleLabel.textAlignment=NSTextAlignmentLeft;
    [leftbtn setImage:[UIImage imageNamed:@"home_down"] forState:UIControlStateNormal];
    //按钮设置一下偏移
    leftbtn.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 10);
    leftbtn.imageEdgeInsets=UIEdgeInsetsMake(0, 65, 0, 0);
    leftbtn.contentEdgeInsets=UIEdgeInsetsMake(0, -30, 0, 0);
    UIBarButtonItem *leftitem=[[UIBarButtonItem alloc]initWithCustomView:leftbtn];
    [leftbtn addTarget:self action:@selector(leftbuttonshow) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=leftitem;
}

#pragma mark 单例选回来


-(void)leftbuttonshow
{
    
    WHDSeletedcities *viewController=[WHDSeletedcities shareSeleted];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    AppDelegate *delegate=[UIApplication sharedApplication].delegate;
    WHDSeletedcities *viewController=[delegate seletedController];
    if (viewController==nil) {
        viewController=[[WHDSeletedcities alloc]init];
        delegate.seletedController=viewController;
    }
    [self.mybtn setTitle:viewController.curCityName forState:UIControlStateNormal];
    
}

@end

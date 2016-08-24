//
//  ReleaseSuccessViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-7-4.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "ReleaseSuccessViewController.h"
#import "LiteratureAuditViewController.h"
#import "ColorTools.h"
@interface ReleaseSuccessViewController ()
{

    NSArray *titleArr;

}
@end

@implementation ReleaseSuccessViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 初始化数据
    [self initData];
    
    // 初始化视图
    [self initView];
    
}

/**
 * 初始化数据
 */
- (void)initData
{
    titleArr = @[@"借款标编号:",@"借款金额:",@"借款标标题:",@"借款标状态:"];
    
}

/**
 初始化数据
 */
- (void)initView
{
    
    [self initNavigationBar];
    self.view.backgroundColor = KblackgroundColor;
    
    UIView *backView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 205)];
    backView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView1];
   
    for (int i=0; i<[titleArr count]; i++) {
        
        UILabel  *textlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80+i*30, 80,30)];
        textlabel.lineBreakMode = NSLineBreakByCharWrapping;
        textlabel.font = [UIFont boldSystemFontOfSize:14.0f];
        textlabel.text = [titleArr objectAtIndex:i];
        [backView1  addSubview:textlabel];
    }
    
    
    UILabel *idLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 80, 150, 30)];
    idLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    idLabel.textColor = [UIColor lightGrayColor];
    idLabel.text = _idString;
    [backView1 addSubview:idLabel];
    
    UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 110, 150, 30)];
    amountLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    amountLabel.textColor = [UIColor lightGrayColor];
    amountLabel.text = [NSString stringWithFormat:@"¥ %@",_amountString];
    [backView1 addSubview:amountLabel];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 140, 150, 30)];
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    titleLabel.text = _titleString;
    titleLabel.textColor = [UIColor lightGrayColor];
    [backView1 addSubview:titleLabel];
    
    
    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 170, 150, 30)];
    stateLabel.numberOfLines = 0;
    stateLabel.lineBreakMode = NSLineBreakByCharWrapping;
    stateLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    stateLabel.textColor = [UIColor lightGrayColor];
    stateLabel.text = _stateString;
    [backView1 addSubview:stateLabel];
    
    
    
    
    UIView *backView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 215, self.view.frame.size.width, self.view.frame.size.height - 210)];
    backView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView2];
    
    
    UILabel *textLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 220, 200, 30)];
    textLabel2.font = [UIFont boldSystemFontOfSize:13.0f];
    textLabel2.text = @"离成功借款还有重要的一步:";
    [self.view addSubview:textLabel2];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 220, 90, 30)];
    textLabel.text = @"提交审核材料";
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor blueColor];
    textLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    [self.view addSubview:textLabel];

    
    UILabel *textLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(5, 250, 200, 30)];
    textLabel3.font = [UIFont boldSystemFontOfSize:13.0f];
    textLabel3.text = @"审核资料:";
    [self.view addSubview:textLabel3];
    
    
    for (int i=0; i<[_requiredArr count]; i++) {
        
        UILabel *textLabel31 = [[UILabel alloc] initWithFrame:CGRectMake(80+i%2*120, 250+i/2*30, 200, 30)];
        textLabel31.font = [UIFont boldSystemFontOfSize:13.0f];
        textLabel31.text = [NSString stringWithFormat:@"%d.%@",i+1,[_requiredArr objectAtIndex:i]];
        textLabel31.textColor = [UIColor lightGrayColor];
        [self.view addSubview:textLabel31];
    }

    
    //边框
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(self.view.frame.size.width*0.5-100, 340, 200, 35);
    [submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setTitle:@"资料已准备好，现在提交" forState:UIControlStateNormal];
    submitBtn.backgroundColor = GreenColor;
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    submitBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13.0];
    [submitBtn.layer setMasksToBounds:YES];
    [submitBtn.layer setCornerRadius:3.0];
    [self.view addSubview:submitBtn];
    

    //边框
    UIButton *prepareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    prepareBtn.frame = CGRectMake(self.view.frame.size.width*0.5-100, 395, 200, 35);
    [prepareBtn addTarget:self action:@selector(prepareClick) forControlEvents:UIControlEventTouchUpInside];
    [prepareBtn setTitle:@"现在去准备资料，回头提交" forState:UIControlStateNormal];
    prepareBtn.backgroundColor = [UIColor blueColor];
    [prepareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    prepareBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13.0];
    [prepareBtn.layer setMasksToBounds:YES];
    [prepareBtn.layer setCornerRadius:3.0];
    [self.view addSubview:prepareBtn];
    

}


/**
 * 初始化导航条
 */
- (void)initNavigationBar
{
    self.title = @"发布成功";
    [self.navigationController.navigationBar setBarTintColor:KColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    // 导航条返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    
    
}


#pragma 返回按钮触发方法
- (void)backClick
{
    // DLOG(@"返回按钮");
    [self.navigationController popToRootViewControllerAnimated:YES];

    
}


#pragma 直接提交
- (void)submitClick
{
     DLOG(@"提交按钮");
    LiteratureAuditViewController *LiteratureAuditView = [[LiteratureAuditViewController alloc] init];
    UINavigationController *LiteratureNAV = [[UINavigationController alloc] initWithRootViewController:LiteratureAuditView];
    [self presentViewController:LiteratureNAV animated:YES completion:nil];
    
    
}


#pragma 准备资料提交
- (void)prepareClick
{
    DLOG(@"准备资料提交按钮");
    [self.navigationController popToRootViewControllerAnimated:NO];
    
}


@end

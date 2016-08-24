//
//  ApplicationRequirementsViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-7-3.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//借款申请条件
#import "ApplicationRequirementsViewController.h"
#import "ColorTools.h"
@interface ApplicationRequirementsViewController ()

@end

@implementation ApplicationRequirementsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

/**
 *初始化视图
 ****/
- (void)initView
{
    
    self.view.frame = CGRectMake(0, 0, 1000, 110);
    self.view.backgroundColor = [UIColor whiteColor];
    
   
    
    UILabel  *textlabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 260, 30)];
    textlabel1.textColor = [UIColor blackColor];
    textlabel1.numberOfLines = 0;
    textlabel1.lineBreakMode = NSLineBreakByCharWrapping;
    textlabel1.font = [UIFont boldSystemFontOfSize:14.0f];
    textlabel1.text = @"申请条件:";
    [self.view addSubview:textlabel1];
    
    
    UILabel  *textlabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, 285,60)];
    textlabel2.numberOfLines = 0;
    textlabel2.lineBreakMode = NSLineBreakByCharWrapping;
    textlabel2.font = [UIFont systemFontOfSize:13.0f];
    textlabel2.text = self.applyStr;
    textlabel2.textColor = [UIColor lightGrayColor];
    [self.view addSubview:textlabel2];
    
    
    UILabel  *textlabel5 = [[UILabel alloc] initWithFrame:CGRectMake(25, 75, 250, 30)];
    textlabel5.numberOfLines = 0;
    textlabel5.lineBreakMode = NSLineBreakByCharWrapping;
    textlabel5.font = [UIFont systemFontOfSize:13.0f];
    textlabel5.text = @"借款额度:";
    textlabel5.textColor = PinkColor;
    [self.view addSubview:textlabel5];
    
    
    UILabel  *textlabel6 = [[UILabel alloc] initWithFrame:CGRectMake(85, 75, 260, 30)];
    textlabel6.numberOfLines = 0;
    textlabel6.textColor = [UIColor redColor];
    textlabel6.lineBreakMode = NSLineBreakByWordWrapping
    ;
    textlabel6.font = [UIFont systemFontOfSize:13.0f];
    textlabel6.text = [NSString stringWithFormat:@"%@ -- %@ 元",self.minAmount,self.maxAmount];
    textlabel6.textColor = PinkColor;
    [self.view addSubview:textlabel6];
    

}

@end

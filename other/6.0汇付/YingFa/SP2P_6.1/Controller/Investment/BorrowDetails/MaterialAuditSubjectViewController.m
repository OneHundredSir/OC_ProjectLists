//
//  MaterialAuditSubjectViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-7-2.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//借款详情========》》必须审核科目
#import "MaterialAuditSubjectViewController.h"
#import "ColorTools.h"
@interface MaterialAuditSubjectViewController ()


@end

@implementation MaterialAuditSubjectViewController
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
    [self initData];
    
    [self initView];
}

-(void)initData
{

}



-(void)initView
{

    
    self.view.frame = CGRectMake(0, 0, 1000, 260);
    self.view.backgroundColor = [UIColor whiteColor];
    
}


@end

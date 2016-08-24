//
//  DetailsDescriptionViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-7-2.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//借款详情=========》》详情描述
#import "DetailsDescriptionViewController.h"

@interface DetailsDescriptionViewController ()


@end

@implementation DetailsDescriptionViewController
@synthesize textlabel = _textlabel;
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
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.labelSize.height+20);
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _textlabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.view.frame.size.width-30, self.labelSize.height+20)];
    _textlabel.numberOfLines = 0;
    _textlabel.lineBreakMode = NSLineBreakByCharWrapping;
    _textlabel.font = [UIFont boldSystemFontOfSize:13.0f];
    _textlabel.text = self.textString;
    _textlabel.textColor = [UIColor grayColor];
    [self.view addSubview:_textlabel];
}



@end

//
//  CBORiskControlSystemViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-7-2.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "CBORiskControlSystemViewController.h"

@interface CBORiskControlSystemViewController ()

@end

@implementation CBORiskControlSystemViewController

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
    
    self.view.frame = CGRectMake(0, 0, 1000, 80);
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _textlabel = [[UILabel alloc] initWithFrame:CGRectMake(30, -5, 260, 90)];
    _textlabel.numberOfLines = 0;
    _textlabel.lineBreakMode = NSLineBreakByCharWrapping;
    _textlabel.font = [UIFont boldSystemFontOfSize:13.0f];
    _textlabel.textColor = [UIColor grayColor];
    _textlabel.text = _CBOtextString;
    [self.view addSubview:_textlabel];
    

}


@end

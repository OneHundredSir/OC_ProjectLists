//
//  ExtensionDetailViewController.m
//  xxoo
//
//  Created by kiu on 14-6-27.
//  Copyright (c) 2014年 kiu. All rights reserved.
//

#import "ExtensionDetailViewController.h"

#import "ColorTools.h"

@interface ExtensionDetailViewController ()

//  会员注册时间
@property (nonatomic, strong) UILabel *registrationDateLabel;
//  推广人
@property (nonatomic, strong) UILabel *recommendLabel;
//  理财交易额
@property (nonatomic, strong) UILabel *manageLabel;
//  CPS奖金
@property (nonatomic, strong) UILabel *bonusLabel;

@end

@implementation ExtensionDetailViewController

@synthesize registrationDate;

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
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 130);
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 画直线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.1, self.view.frame.size.width, 1)];
    lineView.backgroundColor = KblackgroundColor;
    [self.view addSubview:lineView];
    
    
    UIFont *_font = [UIFont fontWithName:@"Arial" size:14.0];
    
    _registrationDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, MSWIDTH-20, 20)];
    _registrationDateLabel.font = _font;
    _registrationDateLabel.text = [NSString stringWithFormat:@"注册时间: %@", registrationDate];
    [self.view addSubview:_registrationDateLabel];

    
    _manageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 38, 150, 20)];
    _manageLabel.font = _font;
    _manageLabel.text = [NSString stringWithFormat:@"理财交易额: ￥%@", _manage];
    [self.view addSubview:_manageLabel];
    
    _bonusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 68, 150, 20)];
    _bonusLabel.font = _font;
    _bonusLabel.text = [NSString stringWithFormat:@"CPS奖金: ￥%@", _bonus];
    [self.view addSubview:_bonusLabel];
    
    
    _recommendLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 98, 150, 20)];
    _recommendLabel.font = _font;
    
    if (_recommend != nil && ![_recommend isEqual:[NSNull null]] && ![_recommend isEqualToString:@""]) {
        _recommendLabel.text = [NSString stringWithFormat:@"推广人: %@", _recommend];
    }else{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 100);
    }

    [self.view addSubview:_recommendLabel];
    
    DLOG(@"_registrationDateLabel -> %@", _registrationDateLabel.text);
    DLOG(@"_recommend -> %@",_recommend);
    DLOG(@"_manageLabel -> %@", _manageLabel.text);
    DLOG(@"_bonusLabel -> %@", _bonusLabel.text);
}

@end

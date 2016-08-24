//
//  HistoricalRecordViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-7-2.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//历史记录
#import "HistoricalRecordViewController.h"

@interface HistoricalRecordViewController ()
{

    NSArray *titleArr;


}
@end

@implementation HistoricalRecordViewController

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


- (void)initData
{

    titleArr = @[@"注册时间:",@"成功借款次数:",@"正常还款次数:",@"逾期还款次数:",@"待还款金额:",@"共计借入金额:",@"理财投标笔数:",@"待收款金额:"];

}
/**
 *初始化视图
 ****/
- (void)initView
{
    
    self.view.frame = CGRectMake(0, 0, 1000, 210);
    self.view.backgroundColor = [UIColor whiteColor];

    
    for (int i=0; i<8; i++) {
        UILabel *textlabel =  [[UILabel alloc] initWithFrame:CGRectMake(10, 5+25*i, 150, 30)];
        textlabel.font = [UIFont boldSystemFontOfSize:13.0f];
        textlabel.numberOfLines = 0;
        textlabel.lineBreakMode = NSLineBreakByCharWrapping;
        textlabel.text = [titleArr objectAtIndex:i];
        textlabel.textColor = [UIColor grayColor];
        [self.view addSubview:textlabel];
        
    }

    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 150, 30)];
    timeLabel.numberOfLines = 0;
    timeLabel.lineBreakMode = NSLineBreakByCharWrapping;
    timeLabel.font = [UIFont systemFontOfSize:13.0f];
    timeLabel.text = _timeString;
    timeLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:timeLabel];
    
    UILabel *successfulLabel = [[UILabel alloc] initWithFrame:CGRectMake(110,30, 150, 30)];
    successfulLabel.numberOfLines = 0;
    successfulLabel.lineBreakMode = NSLineBreakByCharWrapping;
    successfulLabel.font = [UIFont systemFontOfSize:13.0f];
    successfulLabel.text = _successfulnumString;
    successfulLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:successfulLabel];
    
    UILabel *normalLabel = [[UILabel alloc] initWithFrame:CGRectMake(110,55, 150, 30)];
    normalLabel.numberOfLines = 0;
    normalLabel.lineBreakMode = NSLineBreakByCharWrapping;
    normalLabel.font = [UIFont systemFontOfSize:13.0f];
    normalLabel.text = _normalnumString;
    normalLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:normalLabel];
    
    
    UILabel *limitLabel = [[UILabel alloc] initWithFrame:CGRectMake(110,80, 150, 30)];
    limitLabel.numberOfLines = 0;
    limitLabel.lineBreakMode = NSLineBreakByCharWrapping;
    limitLabel.font = [UIFont systemFontOfSize:13.0f];
    limitLabel.text = _limitnumString;
    limitLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:limitLabel];
    
    
    UILabel *repaymentLabel = [[UILabel alloc] initWithFrame:CGRectMake(90,105, 150, 30)];
    repaymentLabel.numberOfLines = 0;
    repaymentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    repaymentLabel.font = [UIFont systemFontOfSize:13.0f];
    repaymentLabel.text = _repaymentString;
    repaymentLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:repaymentLabel];
    
    UILabel *borrowLabel = [[UILabel alloc] initWithFrame:CGRectMake(100,130, 150, 30)];
    borrowLabel.numberOfLines = 0;
    borrowLabel.lineBreakMode = NSLineBreakByCharWrapping;
    borrowLabel.font = [UIFont systemFontOfSize:13.0f];
    borrowLabel.text = _borrowString;
    borrowLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:borrowLabel];
    
    
    UILabel *tenderLabel = [[UILabel alloc] initWithFrame:CGRectMake(110,155, 150, 30)];
    tenderLabel.numberOfLines = 0;
    tenderLabel.lineBreakMode = NSLineBreakByCharWrapping;
    tenderLabel.font = [UIFont systemFontOfSize:13.0f];
    tenderLabel.text = _tendernumString;
    tenderLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:tenderLabel];
    
    
    UILabel *receiptLabel = [[UILabel alloc] initWithFrame:CGRectMake(90,180, 150, 30)];
    receiptLabel.numberOfLines = 0;
    receiptLabel.lineBreakMode = NSLineBreakByCharWrapping;
    receiptLabel.font = [UIFont systemFontOfSize:13.0f];
    receiptLabel.text = _receiptString;
    receiptLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:receiptLabel];
    
    
}


@end

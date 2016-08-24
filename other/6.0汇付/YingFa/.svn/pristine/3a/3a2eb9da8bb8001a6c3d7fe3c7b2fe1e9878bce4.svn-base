//
//  TransferSnapshotViewController.m
//  SP2P_6.1
//
//  Created by Jerry on 14-7-8.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//债权详情-------》》转让标简况
#import "TransferSnapshotViewController.h"
#import "ColorTools.h"

@interface TransferSnapshotViewController ()
{

    NSArray *titleArr;


}
@end

@implementation TransferSnapshotViewController

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
    
    titleArr = @[@"借款金额:",@"投标本金:",@"年利率:",@"本息合计应收金额:",@"已收金额:",@"剩余应收款:",@"待收本金:",@"逾期情况:",@"还款日期:"];
    
}
/**
 *初始化视图
 ****/
- (void)initView
{
    
    self.view.frame = CGRectMake(0, 0, 1000, 170);
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    for (int i=0; i<[titleArr count]; i++) {
        UILabel *textlabel =  [[UILabel alloc] initWithFrame:CGRectMake(10, 5+25*i, 150, 30)];
        
        
        switch (i) {
            case 2:
                   textlabel.frame = CGRectMake(170, 5+25*(i-1), 150, 30);
                break;
            case 3:
            case 4:
                textlabel.frame = CGRectMake(10, 5+25*(i-1), 150, 30);
                break;
            case 5:
                 textlabel.frame = CGRectMake(170, 5+25*(i-2), 150, 30);
                break;
            case 6:
                textlabel.frame = CGRectMake(10, 5+25*(i-2), 150, 30);
                break;
            case 7:
                textlabel.frame = CGRectMake(170, 5+25*(i-3), 150, 30);
                break;
            case 8:
                textlabel.frame = CGRectMake(10, 5+25*(i-3), 150, 30);
                break;
        }

        textlabel.font = [UIFont boldSystemFontOfSize:13.0f];
        textlabel.numberOfLines = 0;
        textlabel.textColor = [UIColor grayColor];
        textlabel.lineBreakMode = NSLineBreakByCharWrapping;
        textlabel.text = [titleArr objectAtIndex:i];
        [self.view addSubview:textlabel];
        
    }
    
    
  
    
    UILabel *borrowLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 150, 30)];
    borrowLabel.lineBreakMode = NSLineBreakByCharWrapping;
    borrowLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    borrowLabel.text = _borrowingStr;
    borrowLabel.textColor = GreenColor;
    [self.view addSubview:borrowLabel];
    
    UILabel *principalLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, 150, 30)];
    principalLabel.lineBreakMode = NSLineBreakByCharWrapping;
    principalLabel.font = [UIFont systemFontOfSize:13.0f];
    principalLabel.text = _principalStr;
    principalLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:principalLabel];
    
    
    UILabel *YearRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 30, 150, 30)];
    YearRateLabel.lineBreakMode = NSLineBreakByCharWrapping;
    YearRateLabel.font = [UIFont systemFontOfSize:13.0f];
    YearRateLabel.text = _YearRateStr;
    YearRateLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:YearRateLabel];
    
    
    UILabel *interestLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 55, 150, 30)];
    interestLabel.lineBreakMode = NSLineBreakByCharWrapping;
    interestLabel.font = [UIFont systemFontOfSize:13.0f];
    interestLabel.text = _interestStr;
    interestLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:interestLabel];
    
    
    
    UILabel *receiveLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 80, 150, 30)];
    receiveLabel.lineBreakMode = NSLineBreakByCharWrapping;
    receiveLabel.font = [UIFont systemFontOfSize:13.0f];
    receiveLabel.text = _receivedStr;
    receiveLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:receiveLabel];
    
    
    UILabel *remainingLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 80, 150, 30)];
    remainingLabel.lineBreakMode = NSLineBreakByCharWrapping;
    remainingLabel.font = [UIFont systemFontOfSize:13.0f];
    remainingLabel.text = _remainingStr;
    remainingLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:remainingLabel];
    

    UILabel *collectedLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 105, 150, 30)];
    collectedLabel.lineBreakMode = NSLineBreakByCharWrapping;
    collectedLabel.font = [UIFont systemFontOfSize:13.0f];
    collectedLabel.text = _collectedStr;
    collectedLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:collectedLabel];
    
    UILabel *overdueLabel = [[UILabel alloc] initWithFrame:CGRectMake(235, 105, 150, 30)];
    overdueLabel.lineBreakMode = NSLineBreakByCharWrapping;
    overdueLabel.font = [UIFont systemFontOfSize:13.0f];
    overdueLabel.text = _overdueStr;
    overdueLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:overdueLabel];
    
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 5+25*5, 150, 30)];
    timeLabel.numberOfLines = 0;
    timeLabel.lineBreakMode = NSLineBreakByCharWrapping;
    timeLabel.font = [UIFont systemFontOfSize:13.0f];
    timeLabel.text = _timeStr;
    timeLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:timeLabel];


    
}

@end

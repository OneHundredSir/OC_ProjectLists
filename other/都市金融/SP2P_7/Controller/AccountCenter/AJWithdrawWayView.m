//
//  AJWithdrawWayView.m
//  SP2P_7
//
//  Created by Ajax on 16/2/29.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "AJWithdrawWayView.h"



@implementation AJWithdrawWayView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
       
        // 普通
        CGFloat commonWithdrawX = 0;
        CGFloat space = 5.f;
        UIButton *commonWithdraw = [UIButton buttonWithType:UIButtonTypeCustom];
        [commonWithdraw setImage:[UIImage imageNamed:@"circleCheckBox_unselected"] forState:UIControlStateNormal];
        [commonWithdraw setImage:[UIImage imageNamed:@"circleCheckBox_selected"] forState:UIControlStateSelected];
        commonWithdraw.selected = YES;
        [commonWithdraw setTitle:@"普通取现" forState:UIControlStateNormal];
        [commonWithdraw setTitleColor:[ColorTools colorWithHexString:@"#646464"] forState:UIControlStateNormal];
        commonWithdraw.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:commonWithdraw];
        commonWithdraw.frame = CGRectMake(commonWithdrawX ,0, 80, 23);
        [commonWithdraw addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        commonWithdraw.tag = 0+24250;
        [self btnClick:commonWithdraw];
        
        UILabel *common = [[UILabel alloc] init];
        common.font = commonWithdraw.titleLabel.font;
        common.textColor = commonWithdraw.titleLabel.textColor;
        [self addSubview:common];
        common.text = @"手续费2元";
        common.frame = CGRectMake(commonWithdrawX + 23,CGRectGetMaxY(commonWithdraw.frame)+space, 250, 15);
        
        // 快速
        UIButton *fast = [UIButton buttonWithType:UIButtonTypeCustom];
        [fast setImage:[UIImage imageNamed:@"circleCheckBox_unselected"] forState:UIControlStateNormal];
        [fast setImage:[UIImage imageNamed:@"circleCheckBox_selected"] forState:UIControlStateSelected];
        [fast setTitle:@"快速取现" forState:UIControlStateNormal];
        [fast setTitleColor:[ColorTools colorWithHexString:@"#646464"] forState:UIControlStateNormal];
        fast.titleLabel.font = commonWithdraw.titleLabel.font;
        [self addSubview:fast];
        fast.frame = CGRectMake(commonWithdrawX , CGRectGetMaxY(common.frame) + space, commonWithdraw.bounds.size.width, commonWithdraw.bounds.size.height);
        [fast addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        fast.tag = 1+24250;

        UILabel *fastLabel = [[UILabel alloc] init];
        fastLabel.font = commonWithdraw.titleLabel.font;
        fastLabel.textColor = commonWithdraw.titleLabel.textColor;
        [self addSubview:fastLabel];
        fastLabel.text = @"手续费为取现总额*0.05%+2元";
        fastLabel.frame = CGRectMake(common.frame.origin.x,CGRectGetMaxY(fast.frame)+space, 250, 15);

        // 即时
        UIButton *immediately = [UIButton buttonWithType:UIButtonTypeCustom];
        [immediately setImage:[UIImage imageNamed:@"circleCheckBox_unselected"] forState:UIControlStateNormal];
        [immediately setImage:[UIImage imageNamed:@"circleCheckBox_selected"] forState:UIControlStateSelected];
        [immediately setTitle:@"即时取现" forState:UIControlStateNormal];
        [immediately setTitleColor:[ColorTools colorWithHexString:@"#646464"] forState:UIControlStateNormal];
        immediately.titleLabel.font = commonWithdraw.titleLabel.font;
        [self addSubview:immediately];
        immediately.frame = CGRectMake(commonWithdrawX , CGRectGetMaxY(fastLabel.frame) + space, commonWithdraw.bounds.size.width, commonWithdraw.bounds.size.height);
        [immediately addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        immediately.tag = 2+24250;
        
        UILabel *immediatelyLabel = [[UILabel alloc] init];
        immediatelyLabel.font = commonWithdraw.titleLabel.font;
        immediatelyLabel.textColor = commonWithdraw.titleLabel.textColor;
        [self addSubview:immediatelyLabel];
        immediatelyLabel.text = @"手续费为取现总额*0.05%+2元";
        immediatelyLabel.frame = CGRectMake(common.frame.origin.x,CGRectGetMaxY(immediately.frame)+space, 250, 15);

        //注
        UILabel *annotation = [[UILabel alloc] init];
        annotation.font = commonWithdraw.titleLabel.font;
        annotation.textColor = commonWithdraw.titleLabel.textColor;
        [self addSubview:annotation];
        annotation.text = @"注：所有提现费由客户自行承担";
        annotation.frame = CGRectMake( commonWithdrawX,CGRectGetMaxY(immediatelyLabel.frame)+10, 250, 15);
        
//        frame.size.height = CGRectGetMaxY(annotation.frame)+5;
    }
    return self;
}


- (void)btnClick:(UIButton *)sender
{
    if(sender.selected) return;
    UIButton *btn = [self viewWithTag:self.selectedIndex + 24250];
    btn.selected = NO;
    sender.selected = !sender.selected;
    self.selectedIndex = (int)sender.tag - 24250;
}
@end

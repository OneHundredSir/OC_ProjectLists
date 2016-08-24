//
//  AJTransferFooter.m
//  SP2P_7
//
//  Created by Ajax on 16/1/19.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "AJTransferFooter.h"

@interface AJTransferFooter ()
@property (nonatomic, weak) UIButton *transferIn;
@property (nonatomic, weak) UIButton *transferOut;
@end
@implementation AJTransferFooter

- (instancetype)initWithFrame:(CGRect)frame btnClickblock:(btnClickBlock)block
{
    if (self = [super initWithFrame:frame]) {
        // 转入
        UIButton *transferIn = [UIButton buttonWithType:UIButtonTypeCustom];
        [transferIn setBackgroundColor:kButtonColor];
        [transferIn setTitleColor:[ColorTools colorWithHexString:kTextColor] forState:UIControlStateNormal];
        [transferIn setTitle:@"转入" forState:UIControlStateNormal];
        transferIn.titleLabel.font = [UIFont systemFontOfSize:19];
        transferIn.layer.cornerRadius = 10.0f;
        transferIn.layer.masksToBounds = YES;
        [self addSubview:transferIn];
        [transferIn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        transferIn.showsTouchWhenHighlighted = YES;
        self.transferIn = transferIn;
        // 转出
        UIButton *transferOut = [UIButton buttonWithType:UIButtonTypeCustom];;
        [transferOut setBackgroundColor:kButtonColor];
        [transferOut setTitleColor:[ColorTools colorWithHexString:kTextColor] forState:UIControlStateNormal];
        [transferOut setTitle:@"转出" forState:UIControlStateNormal];
        transferOut.titleLabel.font = transferIn.titleLabel.font;
        transferOut.layer.cornerRadius = 10.0f;
        transferOut.layer.masksToBounds = YES;
        [self addSubview:transferOut];
        [transferOut addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        transferOut.showsTouchWhenHighlighted = transferIn.showsTouchWhenHighlighted;
        self.transferOut = transferOut;
        self.block = block;
    }
    return self;
}
- (void)btnClick:(UIButton *)sender
{
    self.block(sender);
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat transferInW = 300.f/2;
    CGFloat transferInH = 75.f/2;
    CGFloat transferInY = 80.f/2;
    CGFloat transferInX = (self.bounds.size.width/2 - transferInW)/2;
    self.transferIn.frame = CGRectMake(transferInX, transferInY, transferInW, transferInH);
    
    CGFloat transferOutX = self.bounds.size.width/2 + transferInX;
    self.transferOut.frame = CGRectMake(transferOutX, transferInY, transferInW, transferInH);

}
@end

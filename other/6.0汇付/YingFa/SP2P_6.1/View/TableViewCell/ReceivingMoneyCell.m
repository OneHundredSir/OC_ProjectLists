//
//  ReceivingMoneyCell.m
//  SP2P_6.1
//
//  Created by Jerry on 14-7-31.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "ReceivingMoneyCell.h"
#import <QuartzCore/QuartzCore.h>
#import "ColorTools.h"

@implementation ReceivingMoneyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width-5, 20)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [self addSubview:_titleLabel];
        
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,35, 40, 20)];
        _stateLabel.backgroundColor = GreenColor;
        _stateLabel.textColor = [UIColor whiteColor];
        _stateLabel.font = [UIFont systemFontOfSize:10.0f];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_stateLabel];
        
//        _typeImg = [[UIImageView alloc]  initWithFrame:CGRectMake(65, 35, 20, 20)];
//        [self addSubview:_typeImg];
        
        _expandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _expandBtn.frame = CGRectMake(260, 3, 60, 30);
            //DLOG(@"self.frame.size.height -> %f", self.frame.size.height);
        _expandBtn.frame = CGRectMake(MSWIDTH - 65, 17.5, 60, 30);
        _expandBtn.backgroundColor = GreenColor;
        _expandBtn.layer.borderWidth = 0.8f;
        _expandBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
        [_expandBtn setImage:[UIImage imageNamed:@"financial_expand_normal"] forState:UIControlStateNormal];
         [_expandBtn setImage:[UIImage imageNamed:@"financial_expand_selected"] forState:UIControlStateSelected];
        [self addSubview:_expandBtn];
        
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreBtn.frame = CGRectMake(MSWIDTH -35, 35, 20, 20);
        [_moreBtn setImage:[UIImage imageNamed:@"account_more"] forState:UIControlStateNormal];
        [_moreBtn setImage:[UIImage imageNamed:@"account_more"] forState:UIControlStateSelected];
//        [self addSubview:_moreBtn];
        
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 35, 200, 20)];
        _moneyLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        _moneyLabel.textColor = [UIColor grayColor];
        [self addSubview:_moneyLabel];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    

    _expandBtn.backgroundColor = GreenColor;



}
@end

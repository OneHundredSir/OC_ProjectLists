//
//  BorrowBillCell.m
//  SP2P_6.1
//
//  Created by Jerry on 14-7-29.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "BorrowBillCell.h"

@implementation BorrowBillCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width, 20)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [self addSubview:_titleLabel];
        
        
        _overdueView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 32, 20, 20)];
        [self addSubview:_overdueView];
        
        
        _repayView = [[UIImageView alloc] initWithFrame:CGRectMake(35, 32, 30, 20)];
        [self addSubview:_repayView];
        
        
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, 200, 20)];
        _moneyLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        _moneyLabel.textColor = [UIColor grayColor];
        [self addSubview:_moneyLabel];
        
    
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  CollectionBorrowsTableViewCell.m
//  SP2P_6.1
//
//  Created by 李小斌 on 14-10-11.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "CollectionBorrowsTableViewCell.h"

#import "LDProgressView.h"
#import "ColorTools.h"
#import <QuartzCore/QuartzCore.h>

#import "CollectionBorrow.h"

#import "UIImageView+WebCache.h"


@interface CollectionBorrowsTableViewCell()

@property (nonatomic , strong) id object;

@property (nonatomic , strong) UILabel *titleLabel;
@property (nonatomic , strong) UIImageView *levelImageView;
@property (nonatomic , strong) UIImageView *typemageView;
@property (nonatomic , strong) UIImageView *stateImageView;

@property (nonatomic , strong) UILabel *amountLabelValue;
@property (nonatomic , strong) UILabel *periodLabelValue;
@property (nonatomic , strong) UILabel *rateLabelValue;
@property (nonatomic , strong) UILabel *progressLabelValue;

@end

@implementation CollectionBorrowsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    
        _stateImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - 12 - 46, 6, 46, 30)];
        _stateImageView.contentMode = UIViewContentModeScaleToFill;
        _stateImageView.userInteractionEnabled = NO;
        _stateImageView.layer.masksToBounds = YES;
        [self addSubview:_stateImageView];
        
        _typemageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_stateImageView.frame) - 30 -12, CGRectGetMidY(_stateImageView.frame) - 15, 30, 30)];
        _typemageView.contentMode = UIViewContentModeScaleToFill;
        _typemageView.userInteractionEnabled = NO;
        _typemageView.layer.masksToBounds = YES;
        [self addSubview:_typemageView];
        
        _levelImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_typemageView.frame) - 30 -12, CGRectGetMidY(_stateImageView.frame) -15, 30, 30)];
        _levelImageView.contentMode = UIViewContentModeScaleAspectFill;
        _levelImageView.userInteractionEnabled = NO;
        _levelImageView.layer.masksToBounds = YES;
        [self addSubview:_levelImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMidY(_stateImageView.frame) - 15, CGRectGetMinX(_levelImageView.frame) -12 -12, 30)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.textColor = [ColorTools colorWithHexString:@"#333333"];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_titleLabel];
        
        
        UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_titleLabel.frame) + 0, 100, 20)];
        amountLabel.font = [UIFont boldSystemFontOfSize:12];
        amountLabel.textColor = [ColorTools colorWithHexString:@"#808080"];
        amountLabel.backgroundColor = [UIColor clearColor];
        amountLabel.text = @"借款金额";
        amountLabel.lineBreakMode = NSLineBreakByCharWrapping;
        amountLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:amountLabel];
        
        UILabel *periodLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(amountLabel.frame), CGRectGetMinY(amountLabel.frame) , 60, 20)];
        periodLabel.font = [UIFont boldSystemFontOfSize:12];
        periodLabel.textColor = [ColorTools colorWithHexString:@"#808080"];
        periodLabel.backgroundColor = [UIColor clearColor];
        periodLabel.text = @"借款期限";
        periodLabel.lineBreakMode = NSLineBreakByCharWrapping;
        periodLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:periodLabel];
        
        UILabel *rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(periodLabel.frame), CGRectGetMinY(amountLabel.frame), 60, 20)];
        rateLabel.font = [UIFont boldSystemFontOfSize:12];
        rateLabel.textColor = [ColorTools colorWithHexString:@"#808080"];
        rateLabel.backgroundColor = [UIColor clearColor];
        rateLabel.lineBreakMode = NSLineBreakByCharWrapping;
        rateLabel.textAlignment = NSTextAlignmentCenter;
        rateLabel.text = @"年利率";
        [self addSubview:rateLabel];
        
        UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(rateLabel.frame), CGRectGetMinY(amountLabel.frame), 60, 20)];
        stateLabel.font = [UIFont boldSystemFontOfSize:12];
        stateLabel.textColor = [ColorTools colorWithHexString:@"#808080"];
        stateLabel.backgroundColor = [UIColor clearColor];
        stateLabel.lineBreakMode = NSLineBreakByCharWrapping;
        stateLabel.text = @"资料审核";
        stateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:stateLabel];
        
        _amountLabelValue = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(amountLabel.frame), CGRectGetMaxY(amountLabel.frame) + 0, 100, 20)];
        _amountLabelValue.font = [UIFont boldSystemFontOfSize:12];
        _amountLabelValue.textColor = [ColorTools colorWithHexString:@"#808080"];
        _amountLabelValue.backgroundColor = [UIColor clearColor];
        _amountLabelValue.lineBreakMode = NSLineBreakByCharWrapping;
        _amountLabelValue.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_amountLabelValue];
        
        _periodLabelValue = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_amountLabelValue.frame), CGRectGetMinY(_amountLabelValue.frame), 60, 20)];
        _periodLabelValue.font = [UIFont boldSystemFontOfSize:12];
        _periodLabelValue.textColor = [ColorTools colorWithHexString:@"#808080"];
        _periodLabelValue.backgroundColor = [UIColor clearColor];
        _periodLabelValue.lineBreakMode = NSLineBreakByCharWrapping;
        _periodLabelValue.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_periodLabelValue];
        
        _rateLabelValue = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_periodLabelValue.frame), CGRectGetMinY(_amountLabelValue.frame), 60, 20)];
        _rateLabelValue.font = [UIFont boldSystemFontOfSize:12];
        _rateLabelValue.textColor = [ColorTools colorWithHexString:@"#808080"];
        _rateLabelValue.backgroundColor = [UIColor clearColor];
        _rateLabelValue.lineBreakMode = NSLineBreakByCharWrapping;
        _rateLabelValue.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_rateLabelValue];
        
        _progressLabelValue = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_rateLabelValue.frame), CGRectGetMinY(_amountLabelValue.frame), 60, 20)];
        _progressLabelValue.font = [UIFont boldSystemFontOfSize:12];
        _progressLabelValue.textColor = [ColorTools colorWithHexString:@"#808080"];
        _progressLabelValue.backgroundColor = [UIColor clearColor];
        _progressLabelValue.lineBreakMode = NSLineBreakByCharWrapping;
        _progressLabelValue.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_progressLabelValue];
        
    }
    return self;
}

- (void) calculatorClick:(id) sender
{
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.object) {
        if ([self.object isMemberOfClass:[CollectionBorrow class]]) {
            CollectionBorrow *object = self.object;
            
            _titleLabel.text = object.title;
        
            
            [_levelImageView  sd_setImageWithURL:[NSURL URLWithString:object.creditLevel]
                       placeholderImage:[UIImage imageNamed:@""]];
            
            [_typemageView  sd_setImageWithURL:[NSURL URLWithString:object.type]
                             placeholderImage:[UIImage imageNamed:@""]];
            
            _stateImageView.image = [UIImage imageNamed:@""];
    
            _amountLabelValue.text = [NSString stringWithFormat:@"￥%0.2f",object.amount];
            _periodLabelValue.text = [NSString stringWithFormat:@"%ld",(long)object.period];
            _rateLabelValue.text = [NSString stringWithFormat:@"%0.2f%%",object.apr];
            _progressLabelValue.text = [NSString stringWithFormat:@"%ld/%ld", (long)object.productItemCount, (long)object.userItemCountTrue];
            
        }
        
    }
}

- (void)fillCellWithObject:(id)object
{
    self.object = object;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end

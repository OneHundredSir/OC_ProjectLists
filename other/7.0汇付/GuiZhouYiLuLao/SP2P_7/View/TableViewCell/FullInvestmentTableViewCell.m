//
//  FullInvestmentTableViewCell.m
//  SP2P_7
//
//  Created by 李小斌 on 14-6-19.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "FullInvestmentTableViewCell.h"

#import "Investment.h"
#import "ColorTools.h"


@interface FullInvestmentTableViewCell()

@property (nonatomic , strong) id object;

@property (nonatomic , strong) UIImageView *showImageView;
//@property (nonatomic , strong) UIImageView *showImageView;

@property (nonatomic , strong) UIImageView *tagImageView;

@property (nonatomic , strong) UILabel *titleLabel;

@property (nonatomic , strong) UILabel *amountLabel;
@property (nonatomic , strong) UILabel *fullLabel;

@property (nonatomic , strong) UILabel *rateLabelValue;
@property (nonatomic , strong) UILabel *fullLabelValue;

@property (nonatomic,strong)UIImageView *fullImgView;

@end


@implementation FullInvestmentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _showImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
        _showImageView.layer.cornerRadius = 30;
        _showImageView.userInteractionEnabled = NO;
        _showImageView.layer.masksToBounds = YES;
        [self addSubview:_showImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_titleLabel];
        
        _amountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _amountLabel.font = [UIFont systemFontOfSize:12];
        _amountLabel.textColor = [ColorTools colorWithHexString:@"#999999"];
        _amountLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _amountLabel.backgroundColor = [UIColor clearColor];
        _amountLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_amountLabel];
        
        _fullLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _fullLabel.font = [UIFont systemFontOfSize:12];
        _fullLabel.textColor = [ColorTools colorWithHexString:@"#999999"];
        _fullLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _fullLabel.backgroundColor = [UIColor clearColor];
        _fullLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_fullLabel];
        
        _rateLabelValue = [[UILabel alloc] initWithFrame:CGRectZero];
        _rateLabelValue.font = [UIFont systemFontOfSize:12];
        _rateLabelValue.textColor = [ColorTools colorWithHexString:@"#999999"];
        _rateLabelValue.lineBreakMode = NSLineBreakByWordWrapping;
        _rateLabelValue.backgroundColor = [UIColor clearColor];
        _rateLabelValue.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_rateLabelValue];
        
        _fullLabelValue = [[UILabel alloc] initWithFrame:CGRectZero];
        _fullLabelValue.font = [UIFont boldSystemFontOfSize:28];
        _fullLabelValue.textColor = [ColorTools colorWithHexString:@"#999999"];
        _fullLabelValue.lineBreakMode = NSLineBreakByWordWrapping;
        _fullLabelValue.backgroundColor = [UIColor clearColor];
        _fullLabelValue.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_fullLabelValue];
        
        _fullImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_fullImgView];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.object) {
        if ([self.object isMemberOfClass:[Investment class]]) {
            Investment *object = self.object;
            
            [_showImageView sd_setImageWithURL:[NSURL URLWithString:object.imgurl] placeholderImage:[UIImage imageNamed:@"news_image_default"] ];
         
            _showImageView.frame = CGRectMake(10, 10, 60, 60);
            
            
            //_titleLabel.text = object.title;
            _titleLabel.frame = CGRectMake(CGRectGetMaxX(_showImageView.frame) + 20, CGRectGetMinY(_showImageView.frame),CGRectGetWidth(self.bounds) - CGRectGetMaxX(_showImageView.frame) - 10, 20);
            
            _amountLabel.text = [NSString stringWithFormat:@"¥%0.1f",object.amount];
            _amountLabel.frame = CGRectMake(CGRectGetMinX(_titleLabel.frame)-25, CGRectGetMaxY(_titleLabel.frame) -8, (CGRectGetWidth(self.bounds) - CGRectGetMinX(_titleLabel.frame) - 10)*0.5, 15);
            
            _fullLabel.text = @"人参加";
            _fullLabel.frame = CGRectMake(CGRectGetMaxX(_amountLabel.frame)+10, CGRectGetMaxY(_titleLabel.frame), (CGRectGetWidth(self.bounds) - CGRectGetMinX(_titleLabel.frame) - 10)*0.5, 15);
            
    
            _rateLabelValue.text = [NSString stringWithFormat:@"(年利率%0.1f%%)",object.rate];
            _rateLabelValue.frame = CGRectMake(CGRectGetMinX(_titleLabel.frame)-25, CGRectGetMaxY(_amountLabel.frame) , (CGRectGetWidth(self.bounds) - CGRectGetMinX(_titleLabel.frame) - 10)*0.5, 15);
            
            _fullLabelValue.text = object.numStr;
            _fullLabelValue.frame = CGRectMake(CGRectGetMaxX(_rateLabelValue.frame)-25, CGRectGetMaxY(_fullLabel.frame) -25, (CGRectGetWidth(self.bounds) - CGRectGetMinX(_titleLabel.frame) - 10)*0.5, 30);
            
            [_fullImgView setImage:[UIImage imageNamed:@"full_tag"]];
            _fullImgView.frame = CGRectMake(CGRectGetWidth(self.bounds)-65, 0, 60, 60);

        }
    }
}

- (void)fillCellWithObject:(id)object
{
    self.object = object;
}

- (NSString *)replyCount:(NSString *)replyCount
{
    int count = [replyCount intValue];
    if (count < 10000) {
        return replyCount;
    }else{
        return [NSString stringWithFormat:@"%.1f万",count / 10000.0];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

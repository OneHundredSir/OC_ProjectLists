//
//  CreditorTransferTableViewCell.m
//  SP2P_6.1
//
//  Created by 李小斌 on 14-6-19.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "CreditorTransferTableViewCell.h"
#import "CreditorTransfer.h"
#import "ColorTools.h"

@interface CreditorTransferTableViewCell ()

@property (nonatomic , strong) id object;

@property (nonatomic , strong) UIImageView *tagImageView;

@property (nonatomic , strong) UIImageView *highqualityImg;

@property (nonatomic , strong) UILabel *titleLabel;
@property (nonatomic , strong) UILabel *contentLabel;

@property (nonatomic ,strong)  UIView *redView;
@property (nonatomic ,strong)  UIView *grayView;
@property (nonatomic ,strong)  UIImageView *clockView;
@property (nonatomic ,strong)  UILabel *timeLabel;
@property (nonatomic , strong) UILabel *unitsLabel;

@property (nonatomic , strong) UILabel *principalLabel;// 本金
@property (nonatomic , strong) UILabel *minPrincipalLabel;// 底价
@property (nonatomic , strong) UILabel *currentPrincipalLabel;// 当前价格

@property (nonatomic , strong) UILabel *principalLabelValue;// 本金
@property (nonatomic , strong) UILabel *minPrincipalLabelValue;// 底价
@property (nonatomic , strong) UILabel *currentPrincipalLabelValue;// 当前价格


@end

@implementation CreditorTransferTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_titleLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = [UIColor lightGrayColor];
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _contentLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_contentLabel];
        
        
        _redView = [[UIView alloc] initWithFrame:CGRectZero];
        _redView.backgroundColor = PinkColor;
        [self addSubview:_redView];
        
        _grayView = [[UIView alloc] initWithFrame:CGRectZero];
        _grayView.backgroundColor = KblackgroundColor;
        [self addSubview:_grayView];
        
        _clockView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _clockView.backgroundColor = [UIColor clearColor];
        [_redView addSubview:_clockView];
        
     
        
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font =  [UIFont fontWithName:@"Arial-BoldMT" size:25.0];
        _timeLabel.textColor = PinkColor;
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [_grayView addSubview:_timeLabel];
        
        _unitsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _unitsLabel.backgroundColor = [UIColor clearColor];
        _unitsLabel.font =  [UIFont boldSystemFontOfSize:12.0f];
        _unitsLabel.textColor = PinkColor;
        [_grayView addSubview:_unitsLabel];
        
        
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, MSWIDTH-20, 0.8)];
        lineLabel.backgroundColor = KblackgroundColor;
        [self addSubview:lineLabel];
        
        _principalLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _principalLabel.font = [UIFont boldSystemFontOfSize:12];
        _principalLabel.textColor = [UIColor darkGrayColor];
        _principalLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _principalLabel.backgroundColor = [UIColor clearColor];
        _principalLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_principalLabel];
        
        _minPrincipalLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _minPrincipalLabel.font = [UIFont boldSystemFontOfSize:12];
        _minPrincipalLabel.textColor = [UIColor darkGrayColor];
        _minPrincipalLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _minPrincipalLabel.backgroundColor = [UIColor clearColor];
        _minPrincipalLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_minPrincipalLabel];
        
        
        _currentPrincipalLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _currentPrincipalLabel.font = [UIFont boldSystemFontOfSize:12];
        _currentPrincipalLabel.textColor = [UIColor darkGrayColor];
        _currentPrincipalLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _currentPrincipalLabel.backgroundColor = [UIColor clearColor];
        _currentPrincipalLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_currentPrincipalLabel];


        
        _principalLabelValue = [[UILabel alloc] initWithFrame:CGRectZero];
        _principalLabelValue.font = [UIFont systemFontOfSize:12];
        _principalLabelValue.textColor = GreenColor;
        _principalLabelValue.lineBreakMode = NSLineBreakByWordWrapping;
        _principalLabelValue.backgroundColor = [UIColor clearColor];
        _principalLabelValue.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_principalLabelValue];
        
        _minPrincipalLabelValue = [[UILabel alloc] initWithFrame:CGRectZero];
        _minPrincipalLabelValue.font = [UIFont systemFontOfSize:12];
        _minPrincipalLabelValue.textColor = GreenColor;
        _minPrincipalLabelValue.lineBreakMode = NSLineBreakByWordWrapping;
        _minPrincipalLabelValue.backgroundColor = [UIColor clearColor];
        _minPrincipalLabelValue.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_minPrincipalLabelValue];
        
        _currentPrincipalLabelValue = [[UILabel alloc] initWithFrame:CGRectZero];
        _currentPrincipalLabelValue.font = [UIFont systemFontOfSize:12];
        _currentPrincipalLabelValue.textColor = PinkColor;
        _currentPrincipalLabelValue.lineBreakMode = NSLineBreakByWordWrapping;
        _currentPrincipalLabelValue.backgroundColor = [UIColor clearColor];
        _currentPrincipalLabelValue.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_currentPrincipalLabelValue];
        
        _highqualityImg  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        [self addSubview:_highqualityImg];
        
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.object) {
        if ([self.object isMemberOfClass:[CreditorTransfer class]]) {
            CreditorTransfer *object = self.object;
        
            

           _titleLabel.text = object.title;
           _titleLabel.frame = CGRectMake(10, 10,self.frame.size.width-120, 20);
            
            
            _redView.frame = CGRectMake(CGRectGetMaxX(_titleLabel.frame) + 35, 8, 60, 20);
            _grayView.frame = CGRectMake(CGRectGetMaxX(_titleLabel.frame) + 35, 28, 60, 35);
            _redView.backgroundColor = PinkColor;
            _grayView.backgroundColor = KblackgroundColor;
            
            
            _clockView.frame = CGRectMake(21, 2, 18, 18);
            _clockView.image = [UIImage imageNamed:@"clock_mid"];
            
            
            if (object.isQuality) {
                _highqualityImg.image = [UIImage imageNamed:@"high_hot"];//high_quality
            }else{
                _highqualityImg.image = nil;
            }
            
            _timeLabel.frame = CGRectMake(2, 1, 37, 35);
            _timeLabel.text = object.time;
            
            _unitsLabel.frame = CGRectMake(39, 15, 18, 15);
            _unitsLabel.text = object.units;
          
            _contentLabel.text = object.content;
            _contentLabel.frame = CGRectMake(10, CGRectGetMaxY(_titleLabel.frame) + 2, CGRectGetWidth(_titleLabel.frame)+25, 30);
            
            _principalLabel.text = @"待收本金";
            _principalLabel.frame = CGRectMake(10, CGRectGetMaxY(_contentLabel.frame) + 25, (CGRectGetWidth(self.bounds)-12) / 3.0, 14);
            
            _minPrincipalLabel.text = @"拍卖底价";
            _minPrincipalLabel.frame = CGRectMake(CGRectGetMaxX(_principalLabel.frame), CGRectGetMaxY(_contentLabel.frame) + 25, (CGRectGetWidth(self.bounds)-20) / 3.0, 14);
            
            _currentPrincipalLabel.text = @"目前拍价";
            _currentPrincipalLabel.frame = CGRectMake(CGRectGetMaxX(_minPrincipalLabel.frame), CGRectGetMaxY(_contentLabel.frame) + 25, (CGRectGetWidth(self.bounds)-20) / 3.0, 14);
           
            _principalLabelValue.text = [NSString stringWithFormat:@"¥%0.2f", object.principal];
           // _principalLabelValue.text = [NSString stringWithFormat:@"$200,000"];
            _principalLabelValue.frame = CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_principalLabel.frame) + 3, (CGRectGetWidth(self.bounds)-20) / 3.0, 14);
            
            _minPrincipalLabelValue.text =  [NSString stringWithFormat:@"¥%0.2f", object.minPrincipal];
            //_minPrincipalLabelValue.text =  [NSString stringWithFormat:@"$190,000"];
            _minPrincipalLabelValue.frame = CGRectMake(CGRectGetMaxX(_principalLabelValue.frame), CGRectGetMaxY(_minPrincipalLabel.frame) + 3, (CGRectGetWidth(self.bounds)-20) / 3.0, 14);
            
            _currentPrincipalLabelValue.text =  [NSString stringWithFormat:@"¥%0.2f", object.currentPrincipal];
            //_currentPrincipalLabelValue.text =  [NSString stringWithFormat:@"$210,000"];
            _currentPrincipalLabelValue.frame = CGRectMake(CGRectGetMaxX(_minPrincipalLabel.frame), CGRectGetMaxY(_currentPrincipalLabel.frame) + 3, (CGRectGetWidth(self.bounds)-20) / 3.0, 14);
            
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

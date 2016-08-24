//
//  CreditorTransferTableViewCell.m
//  SP2P_7
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

@property (nonatomic ,strong)  UILabel *timeLabel;
@property (nonatomic , strong) UILabel *unitsLabel;

@property (nonatomic , strong) UILabel *principalLabel;// 本金
@property (nonatomic , strong) UILabel *minPrincipalLabel;// 底价
@property (nonatomic , strong) UILabel *currentPrincipalLabel;// 最高价
@property (nonatomic , strong) UILabel *bidNumLabel;// 出价次数

@property (nonatomic , strong) UILabel *principalLabelValue;// 本金
@property (nonatomic , strong) UILabel *minPrincipalLabelValue;// 底价
@property (nonatomic , strong) UILabel *currentPrincipalLabelValue;// 当前价格
@property (nonatomic , strong) UILabel *bidNumStrLabel;// 出价次数


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
        
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font =  [UIFont fontWithName:@"Arial-BoldMT" size:14.0];
        _timeLabel.textColor = GreenColor;
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_timeLabel];
        
        
      
        
        
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
        
        _bidNumLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _bidNumLabel.font = [UIFont boldSystemFontOfSize:12];
        _bidNumLabel.textColor = [UIColor darkGrayColor];
        _bidNumLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _bidNumLabel.backgroundColor = [UIColor clearColor];
        _bidNumLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_bidNumLabel];


        
        _principalLabelValue = [[UILabel alloc] initWithFrame:CGRectZero];
        _principalLabelValue.font = [UIFont systemFontOfSize:12];
        _principalLabelValue.textColor = GreenColor;
        _principalLabelValue.adjustsFontSizeToFitWidth = YES;
        _principalLabelValue.backgroundColor = [UIColor clearColor];
        _principalLabelValue.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_principalLabelValue];
        
        _minPrincipalLabelValue = [[UILabel alloc] initWithFrame:CGRectZero];
        _minPrincipalLabelValue.font = [UIFont systemFontOfSize:12];
        _minPrincipalLabelValue.textColor = PinkColor;
        _minPrincipalLabelValue.adjustsFontSizeToFitWidth = YES;
        _minPrincipalLabelValue.backgroundColor = [UIColor clearColor];
        _minPrincipalLabelValue.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_minPrincipalLabelValue];
        
        _currentPrincipalLabelValue = [[UILabel alloc] initWithFrame:CGRectZero];
        _currentPrincipalLabelValue.font = [UIFont systemFontOfSize:12];
        _currentPrincipalLabelValue.textColor = BluewordColor;
        _currentPrincipalLabelValue.adjustsFontSizeToFitWidth = YES;
        _currentPrincipalLabelValue.backgroundColor = [UIColor clearColor];
        _currentPrincipalLabelValue.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_currentPrincipalLabelValue];
        
        _bidNumStrLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _bidNumStrLabel.font = [UIFont systemFontOfSize:12];
        _bidNumStrLabel.textColor = BluewordColor;
        _bidNumStrLabel.adjustsFontSizeToFitWidth = YES;
        _bidNumStrLabel.backgroundColor = [UIColor clearColor];
        _bidNumStrLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_bidNumStrLabel];
        
        
        _tenderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _tenderBtn.frame = CGRectZero;
        _tenderBtn.backgroundColor = PinkColor;
        [_tenderBtn setTitle:@"立即竞拍" forState:UIControlStateNormal];
        [_tenderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        _tenderBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
        [_tenderBtn.layer setMasksToBounds:YES];
        [_tenderBtn.layer setCornerRadius:3.0];
        [self  addSubview:_tenderBtn];
        
        
//        _highqualityImg  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
//        [self addSubview:_highqualityImg];
        
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
           _titleLabel.frame = CGRectMake(20, 5,MSWIDTH - 45, 30);
            _titleLabel.textAlignment = NSTextAlignmentLeft;

            
            for (int i = 1; i <= 3; i++) {
                
                UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(i * MSWIDTH/4, CGRectGetMaxY(_titleLabel.frame)+8, 1, 25)];
                lineLabel.backgroundColor = [UIColor lightGrayColor];
                [self addSubview:lineLabel];
            }
            
//            if (object.isQuality) {
//                _highqualityImg.image = [UIImage imageNamed:@"hot_quality"];
//
//            }else{
//            
//                _highqualityImg.image = nil;
//            }
            
            _principalLabel.text = @"待收本金";
            _principalLabel.frame = CGRectMake(2, CGRectGetMaxY(_titleLabel.frame)+5, MSWIDTH/4-4, 14);
            
            _minPrincipalLabel.text = @"拍卖底价";
            _minPrincipalLabel.frame = CGRectMake(MSWIDTH/4 + 2, CGRectGetMaxY(_titleLabel.frame) + 5, MSWIDTH/4-4, 14);
            
            _currentPrincipalLabel.text = @"当前最高价";
            _currentPrincipalLabel.frame = CGRectMake(MSWIDTH/2 + 2, CGRectGetMaxY(_titleLabel.frame)+5, MSWIDTH/4-4, 14);
            
            _bidNumLabel.text = @"出价次数";
            _bidNumLabel.frame = CGRectMake(3*MSWIDTH/4 + 2, CGRectGetMaxY(_titleLabel.frame)+5, MSWIDTH/4-4, 14);
           
            _principalLabelValue.text = [NSString stringWithFormat:@"¥%0.2f", object.principal];
           // _principalLabelValue.text = [NSString stringWithFormat:@"$200,000"];
            _principalLabelValue.frame = CGRectMake(2, CGRectGetMaxY(_principalLabel.frame) + 3, MSWIDTH/4-4, 14);
            
            _minPrincipalLabelValue.text =  [NSString stringWithFormat:@"¥%0.2f", object.minPrincipal];
            _minPrincipalLabelValue.frame = CGRectMake(MSWIDTH/4 + 2, CGRectGetMaxY(_minPrincipalLabel.frame) + 3, MSWIDTH/4-4, 14);
            
            _currentPrincipalLabelValue.text =  [NSString stringWithFormat:@"¥%0.2f", object.currentPrincipal];
            //_currentPrincipalLabelValue.text =  [NSString stringWithFormat:@"$210,000"];
            _currentPrincipalLabelValue.frame = CGRectMake(MSWIDTH/2 + 2, CGRectGetMaxY(_currentPrincipalLabel.frame) + 3, MSWIDTH/4-4, 14);
            
            _bidNumStrLabel.text =  object.joinNumStr;
            //_currentPrincipalLabelValue.text =  [NSString stringWithFormat:@"$210,000"];
            _bidNumStrLabel.frame = CGRectMake(3*MSWIDTH/4 + 2, CGRectGetMaxY(_currentPrincipalLabel.frame) + 3, MSWIDTH/4-4, 14);
            
            _timeLabel.frame = CGRectMake(MSWIDTH-200, CGRectGetMaxY(_bidNumStrLabel.frame) + 15, 180, 15);
            
            _tenderBtn.frame = CGRectMake(45, CGRectGetMaxY(_timeLabel.frame)+25,MSWIDTH-100, 35);
            
            if ([object.time isEqualToString:@"0"]) {
//                _timeLabel.text = @"已结束";
//                _timeLabel.textAlignment = NSTextAlignmentCenter;
                _tenderBtn.backgroundColor = [UIColor lightGrayColor];
                [_tenderBtn setTitle:@"查看详情" forState:UIControlStateNormal];
            }else {
                _tenderBtn.backgroundColor = PinkColor;
                _timeLabel.text =[NSString stringWithFormat:@"剩余时间:%@",object.time];
            }
          
            
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

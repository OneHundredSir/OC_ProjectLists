//
//  IntegralSubsidiaryCell.m
//  SP2P_7
//
//  Created by Jerry on 14-8-6.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "IntegralSubsidiaryCell.h"
#import <QuartzCore/QuartzCore.h>
#import "ColorTools.h"
#import "NormalIntegralDetail.h"
#import "SuccessfulTenderIntegral.h"
#import "BillOverdueIntegral.h"
#import "SuccessfulBorrowingIntegral.h"

@interface IntegralSubsidiaryCell()

@property (nonatomic , strong) id object;

@end

@implementation IntegralSubsidiaryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,8, self.frame.size.width, 20)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_titleLabel];
        
        
        _idLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,35, 200, 18)];
        _idLabel.font = [UIFont systemFontOfSize:14.0f];
        _idLabel.textAlignment = NSTextAlignmentLeft;
        _idLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:_idLabel];
        
//        _otherLabel = [[UILabel alloc] initWithFrame:CGRectMake(140,35, 60, 20)];
        _otherLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _otherLabel.font = [UIFont systemFontOfSize:14.0f];
        _otherLabel.textAlignment = NSTextAlignmentCenter;
        _otherLabel.textColor = [UIColor grayColor];
        _otherLabel.layer.cornerRadius = 3.0f;
        _otherLabel.layer.masksToBounds = YES;
        _otherLabel.backgroundColor = KblackgroundColor;
        [self addSubview:_otherLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-80, 8, 80, 15)];
        _timeLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = [UIColor grayColor];
        [self addSubview:_timeLabel];
        
        
        _backView = [[UIImageView alloc] init];
        _backView.frame =CGRectMake(self.frame.size.width-40, 25, 30, 30);
        [self addSubview:_backView];
        
        
        _scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 5, 25, 20)];
        _scoreLabel.textColor = [UIColor whiteColor];
        _scoreLabel.textAlignment = NSTextAlignmentCenter;
        _scoreLabel.font = [UIFont boldSystemFontOfSize:11.0f];
        [_backView addSubview:_scoreLabel];
        
   
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.object) {
        if ([self.object isMemberOfClass:[NormalIntegralDetail class]]) {
            
            switch (_typeRow) {
                case 1:
                {
                    NormalIntegralDetail *object = self.object;
                    
                    _titleLabel.text = object.title;
                    _idLabel.text = [NSString stringWithFormat:@"编号：%@", object.bidNo];
                    _otherLabel.text = object.period;
                    [_backView setImage:[UIImage imageNamed:@"integral_red_back"]];
                    _scoreLabel.text = [NSString stringWithFormat:@"+%d", object.score];
                    _timeLabel.text = object.auditTime;
                }
                    break;
                case 2:
                {
                    SuccessfulBorrowingIntegral *object = self.object;
                    
                    [_otherLabel removeFromSuperview];
                    
                    _titleLabel.text = object.title;
                    _idLabel.text = [NSString stringWithFormat:@"编号：%@", object.bidNo];
                    [_backView setImage:[UIImage imageNamed:@"integral_red_back"]];
                    _scoreLabel.text = [NSString stringWithFormat:@"+%@", object.score];
                    _timeLabel.text = object.auditTime;
                }
                    break;
                case 3:
                {
                    SuccessfulTenderIntegral *object = self.object;
                    
                    _titleLabel.text = object.title;
                    _idLabel.text = [NSString stringWithFormat:@"编号：%@", object.bidNo];
                    _otherLabel.text = object.name;
                    [_backView setImage:[UIImage imageNamed:@"integral_red_back"]];
                    _scoreLabel.text = [NSString stringWithFormat:@"+%d", object.score];
                    _timeLabel.text = object.investTime;
                }
                    
                    break;
                case 4:
                {
                    BillOverdueIntegral *object = self.object;
                    
                    _titleLabel.text = object.title;
                    _idLabel.text = [NSString stringWithFormat:@"编号：%@", object.bidNo];
                    _otherLabel.text = object.period;
                    [_backView setImage:[UIImage imageNamed:@"integral_red_back"]];
                    _scoreLabel.text = [NSString stringWithFormat:@"-%d", object.score];
                    _timeLabel.text = object.auditTime;
                }
                    
                    break;
            }
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            UIFont *font = [UIFont boldSystemFontOfSize:14.0f];
            NSDictionary *attributes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle.copy};
            CGSize LabelSiZe = [_otherLabel.text boundingRectWithSize:CGSizeMake(999, 20)options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            
            _otherLabel.frame =  CGRectMake(140,35, LabelSiZe.width + 15, 20);
        }
        
    }
}

- (void)fillCellWithObject:(id)object
{
    self.object = object;
}

@end

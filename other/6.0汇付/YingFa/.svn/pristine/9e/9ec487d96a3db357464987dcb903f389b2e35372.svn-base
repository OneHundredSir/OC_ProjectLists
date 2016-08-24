//
//  XTTableViewCell.m
//  XTNews
//
//  Created by tage on 14-4-30.
//  Copyright (c) 2014年 XT. All rights reserved.
//

#import "XTTableViewCell.h"
#import "NewsObject.h"
#import "UIImageView+WebCache.h"

@interface XTTableViewCell ()

@property (nonatomic , strong) id object;

@property (nonatomic , strong) UIImageView *showImageView;

@property (nonatomic , strong) UILabel *titleLabel;

@property (nonatomic , strong) UILabel *timeLabel;

@property (nonatomic , strong) UILabel *digestLabel;

@property (nonatomic , strong) UILabel *replyCountLabel;

@property (nonatomic , strong) UIImageView *tagImageView;

@property (nonatomic , strong) UIImageView *firstImageView;

@property (nonatomic , strong) UIImageView *secondImageView;

@property (nonatomic , strong) UIImageView *thirdImageView;

@end

@implementation XTTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _showImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _secondImageView.contentMode = UIViewContentModeCenter;
        [self addSubview:_showImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.numberOfLines = 0;
//        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = [UIFont systemFontOfSize:11.0f];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_timeLabel];
        
        _digestLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _digestLabel.backgroundColor = [UIColor clearColor];
        _digestLabel.textColor = [UIColor lightGrayColor];
        _digestLabel.numberOfLines = 0;
        _digestLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _digestLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_digestLabel];
        
        _replyCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _replyCountLabel.backgroundColor = [UIColor clearColor];
        _replyCountLabel.textColor = [UIColor lightGrayColor];
        _replyCountLabel.font = [UIFont systemFontOfSize:11];
        _replyCountLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_replyCountLabel];
        
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    _object = nil;
    
    [self resetImageView:_showImageView];
    
    [_titleLabel setFrame:CGRectZero];
    
    [_timeLabel setFrame:CGRectZero];
    
    [_digestLabel setFrame:CGRectZero];
    
    [_replyCountLabel setFrame:CGRectZero];
    
}

- (void)resetImageView:(UIImageView *)imageView
{
    [imageView setImage:nil];
    [imageView setFrame:CGRectZero];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.object) {
        
        if ([self.object isMemberOfClass:[NewsObject class]]) {
            
            NewsObject *object = self.object;
            
            [_showImageView sd_setImageWithURL:[NSURL URLWithString:object.imageSRC] placeholderImage:[UIImage imageNamed:@"news_image_default"]];
            
            
            _showImageView.frame = CGRectMake(13, 10, 75, 60);
            
            _titleLabel.text = object.title;
            
            _titleLabel.frame = CGRectMake(CGRectGetMaxX(_showImageView.frame) + 5, CGRectGetMinY(_showImageView.frame)-5,CGRectGetWidth(self.bounds) - CGRectGetMaxX(_showImageView.frame) - 15, 40);
            
              _timeLabel.frame = CGRectMake(CGRectGetMinX(_showImageView.frame)+5, CGRectGetMaxY(_showImageView.frame)+3,CGRectGetWidth(_showImageView.frame), 20);
             _timeLabel.text = object.timeStr;
            
            _digestLabel.text = object.digest;
            
            _digestLabel.frame = CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_titleLabel.frame) + 1, CGRectGetWidth(_titleLabel.frame) - 10, 30);
            
            _replyCountLabel.text = [NSString stringWithFormat:@"浏览数:%@",[self replyCount:object.replyCount]];
            
            _replyCountLabel.frame = CGRectMake(CGRectGetWidth(self.bounds) - 93, CGRectGetMaxY(_digestLabel.frame)+1 , 70, 20);
            
            
        }
    }
}

- (void)fillCellWithObject:(id)object
{
    self.object = object;    
}

+ (CGFloat)rowHeightForObject:(id)object
{
    
    return 95;
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

}

@end

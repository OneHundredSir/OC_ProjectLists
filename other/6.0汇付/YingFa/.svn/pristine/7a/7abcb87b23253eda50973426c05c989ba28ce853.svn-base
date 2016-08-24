//
//  LoanTypeTableViewCell.m
//  SP2P_6.1
//
//  Created by 李小斌 on 14-6-11.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "LoanTypeTableViewCell.h"

#import "LoanType.h"

@interface LoanTypeTableViewCell()

@property (nonatomic , strong) id object;

@property (nonatomic , strong) UIImageView *showImageView;

@property (nonatomic , strong) UILabel *titleLabel;

@property (nonatomic , strong) UILabel *digestLabel;

@property (nonatomic , strong) UILabel *replyCountLabel;

@property (nonatomic , strong) UIImageView *tagImageView;

@end

@implementation LoanTypeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _showImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _showImageView.layer.cornerRadius = 35.0f;
        _showImageView.layer.masksToBounds = YES;
        [self addSubview:_showImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
        
        _digestLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _digestLabel.backgroundColor = [UIColor clearColor];
        _digestLabel.textColor = [UIColor darkGrayColor];
        _digestLabel.numberOfLines = 0;
        _digestLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _digestLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_digestLabel];
        
        _replyCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _replyCountLabel.backgroundColor = [UIColor clearColor];
        _replyCountLabel.textColor = [UIColor lightGrayColor];
        _replyCountLabel.font = [UIFont systemFontOfSize:12];
        _replyCountLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_replyCountLabel];
        
        _tagImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_tagImageView];
        
        _expanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _expanBtn.frame = CGRectZero;
        [_expanBtn setImage:[UIImage imageNamed:@"expan_down_btn"] forState:UIControlStateNormal];
        [_expanBtn setImage:[UIImage imageNamed:@"expand_up_btn"] forState:UIControlStateHighlighted];
        [self addSubview:_expanBtn];
        
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];

    _object = nil;
    [self resetImageView:_showImageView];
    [_titleLabel setFrame:CGRectZero];
    [_digestLabel setFrame:CGRectZero];
    [_replyCountLabel setFrame:CGRectZero];
    [self resetImageView:_tagImageView];
    [_expanBtn setFrame:CGRectZero];
    [_tagImageView setBackgroundColor:[UIColor clearColor]];
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
        LoanType *object = self.object;
        if (object.imageurl != nil && ![object.imageurl isEqual:[NSNull null]])
        {
            if ([[NSString stringWithFormat:@"%@",object.imageurl] hasPrefix:@"http"]) {
                
                [_showImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",object.imageurl]]
                  placeholderImage:[UIImage imageNamed:@"news_image_default"]];
            }else{
                
                [_showImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Baseurl,object.imageurl]] placeholderImage:[UIImage imageNamed:@"news_image_default"]];
                
            }
        }
       
        _showImageView.frame = CGRectMake(13, 10, 70, 70);
        _titleLabel.text = object.name;
        _titleLabel.frame = CGRectMake(CGRectGetMaxX(_showImageView.frame) + 10, CGRectGetMinY(_showImageView.frame),CGRectGetWidth(self.bounds) - CGRectGetMaxX(_showImageView.frame) - 10, 20);
        _digestLabel.text = object.des;
        _digestLabel.frame = CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_titleLabel.frame) + 2, CGRectGetWidth(_titleLabel.frame) - 70, 30);
        
        _expanBtn.frame = CGRectMake(self.frame.size.width-45, 30, 40, 30);

    }
}

- (void)fillCellWithObject:(id)object
{
    self.object = object;
}

+ (CGFloat)rowHeightForObject:(id)object
{
    if ([object isMemberOfClass:[LoanType class]]) {
        return 86;
    }
    return 86;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

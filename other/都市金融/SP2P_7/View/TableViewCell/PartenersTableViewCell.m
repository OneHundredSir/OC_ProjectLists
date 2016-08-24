//
//  PartenersTableViewCell.m
//  SP2P_7
//
//  Created by kiu on 14-6-17.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "PartenersTableViewCell.h"

@implementation PartenersTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 18, 152, 62)];
        //        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imgView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 84, 280, 30)];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
        
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 114.0f, 320.0f, 1.0f)];
//        [lineView setBackgroundColor:[UIColor lightGrayColor]];
//        [self addSubview:lineView];
        
        _desLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 116, 280, 120)];
        _desLabel.backgroundColor = [UIColor clearColor];
        _desLabel.numberOfLines = 0;
        _desLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _desLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_desLabel];
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

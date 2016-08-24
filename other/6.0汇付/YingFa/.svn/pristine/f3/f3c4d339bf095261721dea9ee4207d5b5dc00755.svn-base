//
//  MoreAboutUsTableViewCell.m
//  SP2P_6.1
//
//  Created by kiu on 14-6-16.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "MoreAboutUsTableViewCell.h"

#import "ColorTools.h"

@implementation MoreAboutUsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 18, 70, 105)];
//        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        _imgView.layer.borderWidth = 1.5;
        _imgView.layer.borderColor = [GreenColor CGColor];
        [self addSubview:_imgView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, 70, 30)];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = GreenColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_imgView addSubview:_titleLabel];
        
        _desLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 13, 200, 180)];
        _desLabel.backgroundColor = [UIColor clearColor];
        _desLabel.contentMode = UIViewContentModeTopLeft;
        _desLabel.numberOfLines = 0;
        _desLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _desLabel.font = [UIFont systemFontOfSize:14];
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

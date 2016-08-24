//
//  AuditingTableViewCell.m
//  SP2P_6.1
//
//  Created by 李小斌 on 14-10-10.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "AuditingTableViewCell.h"

@implementation AuditingTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, MSWIDTH-120, 20)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [self addSubview:_titleLabel];
        
        
        _typeView = [[UIImageView alloc] init];
        _typeView.frame = CGRectMake(CGRectGetMaxX(_titleLabel.frame)-10, 5, 20, 20);
        [self addSubview:_typeView];
        
        UILabel *nopostText = [[UILabel alloc] initWithFrame:CGRectMake(5, 32, 90, 20)];
        nopostText.font = [UIFont boldSystemFontOfSize:13.0f];
        nopostText.text = @"未提交资料:";
        nopostText.textColor = [UIColor grayColor];
        [self addSubview:nopostText];
        
        UILabel *nopassText = [[UILabel alloc] initWithFrame:CGRectMake(120, 32, 90, 20)];
        nopassText.font = [UIFont boldSystemFontOfSize:13.0f];
        nopassText.text = @"未通过资料:";
        nopassText.textColor = [UIColor grayColor];
        [self addSubview:nopassText];
        
        _nopostLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 32, 20, 20)];
        _nopostLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        _nopostLabel.textColor = [UIColor grayColor];
        [self addSubview:_nopostLabel];
        
        
        _nopassLabel = [[UILabel alloc] initWithFrame:CGRectMake(195, 32, 200, 20)];
        _nopassLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        _nopassLabel.textColor = [UIColor grayColor];
        [self addSubview:_nopassLabel];
        
        
        _roundimgView = [[UIImageView alloc] initWithFrame:CGRectMake(MSWIDTH-70, 17, 30, 30)];
        [self addSubview:_roundimgView];
        
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(MSWIDTH-65, 24, 30, 15)];
        _progressLabel.font = [UIFont systemFontOfSize:10];
        _progressLabel.textColor = [UIColor whiteColor];
        [self addSubview:_progressLabel];
        
        
        
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

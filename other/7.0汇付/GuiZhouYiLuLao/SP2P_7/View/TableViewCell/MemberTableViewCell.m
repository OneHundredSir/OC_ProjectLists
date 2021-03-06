//
//  MemberTableViewCell.m
//  SP2P_7
//
//  Created by kiu on 14-6-20.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "MemberTableViewCell.h"

#import "Member.h"
#import "ColorTools.h"

@implementation MemberTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        

        _name = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 150, 20)];
        _name.font = [UIFont fontWithName:@"Arial" size:14.0];
        [self addSubview:_name];
        
        _dateTime = [[UILabel alloc] initWithFrame:CGRectMake(MSWIDTH - 170, 8, 150, 20)];
        _dateTime.textAlignment = NSTextAlignmentRight;
        _dateTime.font = [UIFont fontWithName:@"Arial" size:13.0];
        [self addSubview:_dateTime];
        
        _youxiao = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 50, 20)];
        _youxiao.text = @"有效";
        _youxiao.textAlignment = NSTextAlignmentCenter;
        _youxiao.font = [UIFont fontWithName:@"Arial" size:12.0];
        _youxiao.backgroundColor = [ColorTools colorWithHexString:@"#0c78b9"];
        _youxiao.textColor = [UIColor whiteColor];
        [self addSubview:_youxiao];
        
        
        _more = [UIButton buttonWithType:UIButtonTypeCustom];
        _more.frame = CGRectMake(MSWIDTH - 42, 36, 28, 28);
        [_more setImage:[UIImage imageNamed:@"expan_down_btn"] forState:UIControlStateNormal];
        [_more setImage:[UIImage imageNamed:@"expand_up_btn"] forState:UIControlStateSelected];
        _more.userInteractionEnabled = NO;
        
        [self addSubview:_more];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.object) {
        Member *object = self.object;
        _name.text = object.name;
        _dateTime.text = object.dateTime;
        
        if (!object.isActive) {
            _youxiao.text = @"无效";
        }else{
            _youxiao.text = @"有效";
        }
        
    }
}

- (void)fillCellWithObject:(id)object
{
    self.object = object;
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

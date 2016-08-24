//
//  AuditSubjectCell.m
//  SP2P_7
//
//  Created by Jerry on 14/11/24.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "AuditSubjectCell.h"
#import <QuartzCore/QuartzCore.h>
#import "ColorTools.h"

@implementation AuditSubjectCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(35,2, self.frame.size.width, 30)];
    _nameLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:_nameLabel];
    
    
    _imgLabel = [[UILabel alloc] initWithFrame:CGRectMake(35,40, 40, 20)];
    _imgLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    _imgLabel.layer.cornerRadius = 3.0f;
    _imgLabel.layer.masksToBounds = YES;
    _imgLabel.adjustsFontSizeToFitWidth = YES;
    _imgLabel.textAlignment = NSTextAlignmentCenter;
    _imgLabel.textColor = [UIColor grayColor];
    _imgLabel.backgroundColor = KblackgroundColor;
    [self addSubview:_imgLabel];
    
    
    _depictLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-130,40, 130, 20)];
    _depictLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    _depictLabel.adjustsFontSizeToFitWidth = YES;
    _depictLabel.textAlignment = NSTextAlignmentCenter;
    _depictLabel.textColor = [UIColor grayColor];
    [self addSubview:_depictLabel];
        
    
    _payLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-60,10, 40, 20)];
    _payLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    _payLabel.layer.cornerRadius = 3.0f;
    _payLabel.layer.masksToBounds = YES;
    _payLabel.adjustsFontSizeToFitWidth = YES;
    _payLabel.textAlignment = NSTextAlignmentCenter;
    _payLabel.textColor = [UIColor grayColor];
    _payLabel.backgroundColor = KblackgroundColor;
    [self addSubview:_payLabel];
   }
    return self;
}
@end

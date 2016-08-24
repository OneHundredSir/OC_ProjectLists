//
//  UploadDocumentsCell.m
//  SP2P_7
//
//  Created by Jerry on 14-8-6.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "UploadDocumentsCell.h"
#import "ColorTools.h"
#import <QuartzCore/QuartzCore.h>

@implementation UploadDocumentsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 120, 30)];
        _NameLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        _NameLabel.textColor = [UIColor grayColor];
        [self addSubview:_NameLabel];
        
        
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 40, 40, 18)];
        _stateLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        _stateLabel.backgroundColor = [UIColor redColor];
        _stateLabel.textColor = [UIColor whiteColor];
        _stateLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_stateLabel];
     
        
        
        _uploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _uploadBtn.frame = CGRectMake(self.frame.size.width-40, 15, 35, 35);
        [_uploadBtn setImage:[UIImage imageNamed:@"upload _documents_btn"] forState:UIControlStateNormal];
        [_uploadBtn setImage:[UIImage imageNamed:@"upload _documents_btn"] forState:UIControlStateSelected];
        [self addSubview:_uploadBtn];
        
        
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    


}
@end

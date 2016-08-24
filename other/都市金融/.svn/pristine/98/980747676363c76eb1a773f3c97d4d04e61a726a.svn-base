//
//  AJInvestDetailOrganitionHeader.m
//  SP2P_7
//
//  Created by Ajax on 16/1/28.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "AJInvestDetailOrganitionHeader.h"


@interface AJInvestDetailOrganitionHeader ()
@property (nonatomic,weak) UILabel *organizationLabel;
@property (nonatomic,weak) UILabel *organizationtextLabel;//合作机构
@end
@implementation AJInvestDetailOrganitionHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.organizationtextLabel = [self labelViewWithFont:12.f textColor:[ColorTools colorWithHexString:kblackColor]];
        self.organizationtextLabel.text = @"合作机构:";
        
        self.organizationLabel = [self labelViewWithFont:12.f textColor:[UIColor darkGrayColor]];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat selfW = self.bounds.size.width;
    CGFloat selfH = self.bounds.size.height;
    CGFloat organizationtextLabelY = selfH - kLeftBgViewH - kPadding - kidLabelH;
    //
    self.organizationtextLabel.frame = CGRectMake(kLabelBeginX, organizationtextLabelY, kAmoutTextW, kidLabelH);
    
    CGFloat organizationLabelX = CGRectGetMaxX(self.organizationtextLabel.frame);
    self.organizationLabel.frame = CGRectMake(organizationLabelX, organizationtextLabelY, selfW - organizationLabelX - kPadding, kidLabelH);
}
@end

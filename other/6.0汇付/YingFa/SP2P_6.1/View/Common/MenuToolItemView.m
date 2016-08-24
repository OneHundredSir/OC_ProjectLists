//
//  MenuToolItemView.m
//  SP2P_6.1
//
//  Created by 李小斌 on 14-6-10.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "MenuToolItemView.h"



@implementation MenuToolItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width *0.5 - kICON_WIDTH_HEIGH*0.5, kPADDING, kICON_WIDTH_HEIGH,  kICON_WIDTH_HEIGH)];
        self.icon.backgroundColor = [UIColor clearColor];

        
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(0, kPADDING + kICON_WIDTH_HEIGH, frame.size.width,  kNAME_LABEL_HEIGH)];
        self.name.textAlignment = NSTextAlignmentCenter;
        self.name.lineBreakMode = 0;
        self.name.textColor = [UIColor whiteColor];
        self.name.font = [UIFont systemFontOfSize:9.0f];
        
        [self addSubview:self.icon];
        [self addSubview:self.name];
    }
    return self;
}

@end

//
//  HomeHeaderView.m
//  SP2P_6.1
//
//  Created by 李小斌 on 14-6-20.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "HomeHeaderView.h"
#import "ColorTools.h"

@implementation HomeHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 62, 55)];
        backView.backgroundColor = GreenColor;
        [self addSubview:backView];
        
        
        _title = [[UILabel alloc] initWithFrame:CGRectZero];
        _title.font = [UIFont systemFontOfSize:14];
        _title.textColor = [UIColor darkGrayColor];
        _title.backgroundColor = [UIColor clearColor];
        _title.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_title];
        
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 55, CGRectGetWidth(self.bounds)- 20, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line];
    
    }
    return self;
}

-(void)layoutSubviews
{
   [super layoutSubviews];
    
    
    _title.frame = CGRectMake(75, 2,self.frame.size.width - 10, 15);
    

}
@end

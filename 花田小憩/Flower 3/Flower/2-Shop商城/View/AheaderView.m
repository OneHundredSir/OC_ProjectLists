//
//  AheaderView.m
//  Flower
//
//  Created by maShaiLi on 16/7/15.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "AheaderView.h"

@interface AheaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *IMG;
@property (weak, nonatomic) IBOutlet UILabel *TITLE;
@property (weak, nonatomic) IBOutlet UILabel *DET;
@property (weak, nonatomic) IBOutlet UIImageView *JIAN;
@property (weak, nonatomic) IBOutlet UILabel *HOT;
@property (weak, nonatomic) IBOutlet UILabel *INT;

@end

@implementation AheaderView

- (void)setModel:(JXdetail *)model
{
    _model = model;
    [_IMG sd_setImageWithURL:[NSURL URLWithString:model.fnAttachment] placeholderImage:[UIImage imageNamed:@"default"]];
    _TITLE.text = model.fnEnName;
    _DET.text = model.fnName;
    _HOT.text = model.fnJian == 1 ? @"推荐" : @"最热";
    UIImage *image = model.fnJian == 1 ? [UIImage imageNamed:@"f_jian_56x51"] : [UIImage imageNamed:@"f_hot_56x51"];
    _JIAN.image = image;
    _INT.text = model.fnFirstDesc;

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

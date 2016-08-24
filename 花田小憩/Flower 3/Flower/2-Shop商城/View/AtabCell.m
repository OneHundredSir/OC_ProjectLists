//
//  AtabCell.m
//  Flower
//
//  Created by maShaiLi on 16/7/11.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "AtabCell.h"

@interface AtabCell ()

@property (weak, nonatomic) IBOutlet UIImageView *AimgView;
@property (weak, nonatomic) IBOutlet UILabel *Aetitle;
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *price;

@property (weak, nonatomic) IBOutlet UILabel *jian;
@property (weak, nonatomic) IBOutlet UIImageView *HOTIMG;

@end

@implementation AtabCell

- (void)setModel:(JXmodel *)model
{
    _model = model;
    [_AimgView sd_setImageWithURL:[NSURL URLWithString:model.fnAttachment] placeholderImage:[UIImage imageNamed:@"default"]];
    _Aetitle.text = model.fnEnName;
    _title.text = model.fnName;
    _jian.text = [model.fnJian intValue] == 1 ? @"推荐" : @"最热";
    UIImage *image = [model.fnJian intValue] == 1 ? [UIImage imageNamed:@"f_jian_56x51"] : [UIImage imageNamed:@"f_hot_56x51"];
    _HOTIMG.image = image;
    _price.text = [NSString stringWithFormat:@"￥%@",model.fnMarketPrice];
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

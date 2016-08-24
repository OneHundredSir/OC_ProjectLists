//
//  MyTableViewCell.m
//  JoinTheFoot
//
//  Created by skd on 16/6/28.
//  Copyright © 2016年 lzm. All rights reserved.
//

#import "MyTableViewCell.h"

@interface MyTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *dpImageview;
@property (weak, nonatomic) IBOutlet UILabel *dpName;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UILabel *distance;

@end
@implementation MyTableViewCell

- (void)setDpModel:(DPModel *)dpModel
{
    _dpModel = dpModel;
    
    [_dpImageview sd_setImageWithURL:[NSURL URLWithString:dpModel.image_path] placeholderImage:[UIImage imageNamed:@"default1"]];
    _dpName.text = [NSString stringWithFormat:@"%@",dpModel.shop_name];
    _count.text = [NSString stringWithFormat:@"%@",dpModel.reserve_num];
    
    CGFloat dis = [dpModel.distance floatValue] / 1000.0;
    BOOL ret = dis - 1 < 0.1;
    _distance.text =ret?@"<100m": [NSString stringWithFormat:@"%.1lfkm",dis];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

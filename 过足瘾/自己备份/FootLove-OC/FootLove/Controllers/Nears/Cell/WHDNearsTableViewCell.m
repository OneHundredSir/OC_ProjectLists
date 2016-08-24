//
//  WHDNearsTableViewCell.m
//  FootLove
//
//  Created by HUN on 16/6/28.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDNearsTableViewCell.h"
#import "WHDDPModel.h"

@interface WHDNearsTableViewCell ()
//图片
@property (weak, nonatomic) IBOutlet UIImageView *shopImg;
//商店
@property (weak, nonatomic) IBOutlet UILabel *shopLB;
//距离
@property (weak, nonatomic) IBOutlet UILabel *distanceLb;
//下单数目
@property (weak, nonatomic) IBOutlet UILabel *dealCountLB;
//店铺属性
@property (weak, nonatomic) IBOutlet UILabel *shopDetail;


@end

@implementation WHDNearsTableViewCell

-(void)setModel:(WHDDPModel *)model
{
    _model = model;
    [_shopImg sd_setImageWithURL:[NSURL URLWithString:_model.image_path] placeholderImage:[UIImage imageNamed:@"8我的欢乐购-分享_QQ"]];
    _shopLB.text = _model.shop_name;
    
    //设置店铺距离
    CGFloat realDis = [_model.distance floatValue]/1000.0;
    _distanceLb.text = realDis < 1 ? @"<100M" :[NSString stringWithFormat:@"%.1lfKM",realDis];
    
    //设置购买数目
    _dealCountLB.text = [NSString stringWithFormat:@"成交：%ld单",[_model.tech_num integerValue]];
    
}


- (void)awakeFromNib {
    // Initialization code
}



@end

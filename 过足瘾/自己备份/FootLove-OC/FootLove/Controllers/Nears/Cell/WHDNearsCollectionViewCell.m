//
//  WHDNearsCollectionViewCell.m
//  FootLove
//
//  Created by HUN on 16/6/28.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDNearsCollectionViewCell.h"
#import "WHDJSModel.h"
@interface WHDNearsCollectionViewCell ()
#pragma mark 技师头像
@property (weak, nonatomic) IBOutlet UIImageView *js_img;
#pragma mark 技师名称
@property (weak, nonatomic) IBOutlet UILabel *js_name;
#pragma mark 店铺名称
@property (weak, nonatomic) IBOutlet UILabel *shop_name;
#pragma mark 店铺标签
@property (weak, nonatomic) IBOutlet UILabel *shop_tap;
#pragma mark 店铺举例
@property (weak, nonatomic) IBOutlet UILabel *shop_distance;

@end
@implementation WHDNearsCollectionViewCell

-(void)setModel:(WHDJSModel *)model
{
    _model=model;
    //设置头像
    [_js_img sd_setImageWithURL:[NSURL URLWithString:_model.image_path] placeholderImage:[UIImage imageNamed:@"8我的欢乐购-分享_QQ"] ];
    
    //设置名称
    _js_name.text = _model.member_name;
    
    //设置店铺名称
    _shop_name.text = _model.shop_name;
    
    //店铺标签
    _shop_tap.text = _model.skill;
    
    //设置店铺距离
    CGFloat realDis = [_model.distance floatValue]/1000.0;
    _shop_distance.text = realDis < 1 ? @"<100M" :[NSString stringWithFormat:@"%.1lfKM",realDis];
}

- (void)awakeFromNib {
    // Initialization code
}

@end

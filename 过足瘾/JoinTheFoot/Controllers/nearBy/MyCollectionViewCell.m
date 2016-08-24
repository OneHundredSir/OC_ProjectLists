//
//  MyCollectionViewCell.m
//  JoinTheFoot
//
//  Created by skd on 16/6/27.
//  Copyright © 2016年 lzm. All rights reserved.
//

#import "MyCollectionViewCell.h"

@interface MyCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIView *fullBgView;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *priseBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLa;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *lables;
@property (weak, nonatomic) IBOutlet UILabel *destance;

@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@end

@implementation MyCollectionViewCell

- (void)awakeFromNib {

    _photoImage.clipsToBounds = YES;
    
}
- (void)setJsModel:(JSModel *)jsModel
{
    _jsModel = jsModel;
    
    [_likeBtn setTitle:[NSString stringWithFormat:@"%@",jsModel.fans_num] forState:UIControlStateNormal];
    [_priseBtn setTitle:[NSString stringWithFormat:@"%@",jsModel.focus_num] forState:UIControlStateNormal];
    [_photoImage sd_setImageWithURL:[NSURL URLWithString:jsModel.image_path] placeholderImage:nil];
    _shopName.text = [NSString stringWithFormat:@"%@",jsModel.shop_name];

    NSString *tips = [NSString stringWithFormat:@"%@",jsModel.skill];
    _lables.text = [tips isEqualToString:@""]?@"无标签":tips;
    _nameLa.text = [NSString stringWithFormat:@"%@",jsModel.member_name];
    
    CGFloat dis = [jsModel.distance floatValue] / 1000.0;
    BOOL ret = dis - 1 < 0.1;
    _destance.text =ret?@"<100m": [NSString stringWithFormat:@"%.1lfkm",dis];
    


}
@end

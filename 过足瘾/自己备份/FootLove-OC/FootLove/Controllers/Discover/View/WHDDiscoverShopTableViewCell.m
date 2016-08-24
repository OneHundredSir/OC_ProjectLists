//
//  WHDDiscoverShopTableViewCell.m
//  FootLove
//
//  Created by HUN on 16/7/2.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDDiscoverShopTableViewCell.h"
#import "WHDDiscoverShopModel.h"
@interface WHDDiscoverShopTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgV;

@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;
@property (weak, nonatomic) IBOutlet UILabel *saleNum;

@end


@implementation WHDDiscoverShopTableViewCell

-(void)setModel:(WHDDiscoverShopModel *)model
{
    _model = model;
    [_imgV sd_setImageWithURL:[NSURL URLWithString:_model.image_path]];
    _titleLB.text = [NSString stringWithFormat:@"%@",model.gift_name];
    _priceLB.text = [NSString stringWithFormat:@"%@",model.gift_price];
    _saleNum.text = [NSString stringWithFormat:@"%@ 件",model.count];
    
}


- (void)awakeFromNib {
    // Initialization code
}


@end

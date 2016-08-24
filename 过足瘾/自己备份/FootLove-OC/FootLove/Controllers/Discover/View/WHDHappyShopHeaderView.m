//
//  WHDHappyShopHeaderView.m
//  FootLove
//
//  Created by HUN on 16/6/30.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDHappyShopHeaderView.h"

@interface WHDHappyShopHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *mainImg;

@property (weak, nonatomic) IBOutlet UIImageView *userImmg;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *userCity;

@property (weak, nonatomic) IBOutlet UILabel *joinCountLb;

@property (weak, nonatomic) IBOutlet UILabel *showtimeLB;

@property (weak, nonatomic) IBOutlet UILabel *happyshopTime;


@property (weak, nonatomic) IBOutlet UILabel *luckNumLB;


@end

@implementation WHDHappyShopHeaderView

-(void)setModel:(id)model
{
    _model = model;
    
//    [_mainImg sd_setImageWithURL:[NSURL URLWithString:nil]];
//    [_userImmg sd_setImageWithURL:[NSURL URLWithString:nil]];
//    _userName.text = nil;
//    _userCity.text = nil ;
//    _joinCountLb.text = nil;
//    _showtimeLB.text = [NSString stringWithFormat:@"揭晓时间：%@",nil];
//    _happyshopTime.text =[NSString stringWithFormat:@"欢乐购时间：%@",nil];
//    _luckNumLB.text =[NSString stringWithFormat:@"幸运号码：%d",nil];
    
}

-(void)awakeFromNib
{
    
}

@end

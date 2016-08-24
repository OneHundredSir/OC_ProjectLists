//
//  DetailHeaderView.m
//  JoinTheFoot
//
//  Created by skd on 16/6/30.
//  Copyright © 2016年 lzm. All rights reserved.
//

#import "DetailHeaderView.h"

@interface DetailHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *giftImage;
@property (weak, nonatomic) IBOutlet UILabel *giftName;
@property (weak, nonatomic) IBOutlet UILabel *giftPrice;
@property (weak, nonatomic) IBOutlet UILabel *buyCount;
@property (weak, nonatomic) IBOutlet UISegmentedControl *chooseCount;
@property (weak, nonatomic) IBOutlet UITextField *currentCountTF;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalPrice_W;

@end

@implementation DetailHeaderView

- (void)awakeFromNib
{

    _totalPrice_W.constant = W_width - 135 - 15 - 10;

}

- (void)setGiftModel:(WHDDiscoverShopModel *)giftModel
{
    _giftModel = giftModel;
    [_giftImage sd_setImageWithURL:[NSURL URLWithString:giftModel.image_path] placeholderImage:nil];
    _giftName.text = [NSString stringWithFormat:@"%@",giftModel.gift_name];
    
    NSString *price = [NSString stringWithFormat:@"价值: %@元",giftModel.gift_price];
    NSString *turePrice = [giftModel.gift_price stringValue];
    NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc]initWithString:price];
    [mStr addAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:(NSRange){price.length - turePrice.length - 1,turePrice.length}];
    [_giftPrice setAttributedText:mStr];
    _buyCount.text = [NSString stringWithFormat:@"已购买： %@件",giftModel.count];
    [self _setTotalPrice];
   
}


- (void)_setTotalPrice
{
    NSString *turePrice = [_giftModel.gift_price stringValue];
    NSString *total = [NSString stringWithFormat:@"总需支付金额： ¥ %.2f",turePrice.integerValue  * [_currentCountTF.text floatValue]];
    NSMutableAttributedString *mstr_total = [[NSMutableAttributedString alloc]initWithString:total];
    [mstr_total addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} range:(NSRange){0,total.length}];
    [mstr_total addAttributes:@{NSForegroundColorAttributeName : [UIColor orangeColor]} range:(NSRange){8,total.length - 8}];
    [_totalPrice setAttributedText:mstr_total];

}

- (IBAction)addAction:(UIButton *)sender {
    
    
    if (sender.tag == 20) {
        NSInteger curentIndex = _currentCountTF.text.integerValue;
        curentIndex ++;
        _currentCountTF.text = [NSString stringWithFormat:@"%ld",curentIndex];
    }else
    {
        NSInteger curentIndex = _currentCountTF.text.integerValue;
        if (curentIndex != 0) {
            curentIndex --;
        }
        
        _currentCountTF.text = [NSString stringWithFormat:@"%ld",curentIndex];
        
    }
    
    [self _setTotalPrice];

    
}



@end

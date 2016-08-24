//
//  WHDHappyShopTableViewCell.m
//  FootLove
//
//  Created by HUN on 16/6/30.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDHappyShopTableViewCell.h"

@interface WHDHappyShopTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodImg;

@property (weak, nonatomic) IBOutlet UILabel *goodNameLB;

@property (weak, nonatomic) IBOutlet UILabel *goodPriceLB;

@property (weak, nonatomic) IBOutlet UILabel *showTimeLB;
//总线长
@property (weak, nonatomic) IBOutlet UIView *totalView;
//显示出来的线长
@property (weak, nonatomic) IBOutlet UIView *progressView;

@property (weak, nonatomic) IBOutlet UILabel *joinNum;

@property (weak, nonatomic) IBOutlet UILabel *totalNeedNum;

@property (weak, nonatomic) IBOutlet UILabel *leftNum;

@end

@implementation WHDHappyShopTableViewCell

-(void)setModel:(id)model
{
    _model = model;
    
    [_goodImg sd_setImageWithURL:[NSURL URLWithString:nil]];
    //设置商品的名称
    _goodNameLB.text = nil;
    
    _goodPriceLB.text = [NSString  stringWithFormat:@"价值:%@",nil];
    _showTimeLB.text = [NSString stringWithFormat:@"第%d期",1];
    //已经参加人数
    _joinNum.text = [NSString stringWithFormat:@"%d",1];
    //总参加人数
    _totalNeedNum.text = [NSString stringWithFormat:@"%d",1];
    //剩下参加人数
    _leftNum.text = [NSString stringWithFormat:@"%d",1];
    
    CGRect rect = _totalView.frame;
    CGFloat rate = 0.2;
    rect.size.width = rect.size.width * rate;
    _progressView.frame = rect;
    
    
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

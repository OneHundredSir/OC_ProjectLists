//
//  BtabCell.m
//  Flower
//
//  Created by maShaiLi on 16/7/11.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "BtabCell.h"

@interface BtabCell ()

@property (weak, nonatomic) IBOutlet UILabel *ENG;

@property (weak, nonatomic) IBOutlet UILabel *SUB;

@end

@implementation BtabCell


- (void)setModel:(SCmodel *)model
{
    _model = model;
    self.ENG.text = model.fnDesc;
    self.SUB.text = model.fnName;
    for (int i = 0; i < model.childrenList.count; i++) {
        //~~~~~~~~~~~~~~~~~~~~~~
        //图片
        UIImageView *imgView = [self viewWithTag:80 + i];
        Childrenlist *list = model.childrenList[i];
        Pgoods *pgood = list.pGoods;
        NSString *str = pgood.fnAttachment;
        [imgView sd_setImageWithURL:[NSURL URLWithString:str]];
        //文字
            UILabel *lbl1 = [self viewWithTag:91 + i * 3];
            UILabel *lbl2 = [self viewWithTag:92 + i * 3];
            UILabel *lbl3 = [self viewWithTag:93 + i * 3];
            NSString *name = pgood.fnKeyWords;
            NSString *english = pgood.fnEnName;
            NSString *price = [NSString stringWithFormat:@"￥%ld",pgood.fnMarketPrice];
            lbl1.text = english;
            lbl2.text = name;
            lbl3.text = price;

        
        
    }

}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

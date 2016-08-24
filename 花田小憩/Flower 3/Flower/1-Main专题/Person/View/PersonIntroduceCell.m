//
//  PersonIntroduceCell.m
//  Flower
//
//  Created by HUN on 16/7/13.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "PersonIntroduceCell.h"

@interface PersonIntroduceCell ()

@property (weak, nonatomic) IBOutlet UILabel *introduceLB;

@property (weak, nonatomic) IBOutlet UILabel *detailLB;

@end


@implementation PersonIntroduceCell

-(void)setModel:(id)model
{
    _model = model;
    _introduceLB.text = _model.contentFirst;
    _detailLB.text = _model.contentSecond;
}

-(CGFloat)personIntroduceHeight
{
    CGSize titleH = [_introduceLB.text sizeWithFont:font(16) constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGSize detailH = [_introduceLB.text sizeWithFont:font(16) constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat magin = 10;
    return (magin + titleH.height + detailH.height);
}
@end

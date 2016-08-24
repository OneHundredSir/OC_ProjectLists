//
//  WHDExCell.m
//  xiaorizi
//
//  Created by HUN on 16/6/1.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDExCell.h"
#import "WHDExModel.h"


@interface WHDExCell ()
@property (weak, nonatomic) IBOutlet UIImageView *EXimage;
@property (weak, nonatomic) IBOutlet UILabel *EXlabel;


@end


@implementation WHDExCell

-(void)setModel:(WHDExModel *)model
{
    _model=model;
    [self.EXimage sd_setImageWithURL:[NSURL URLWithString:_model.imgs[0]] placeholderImage:[UIImage imageNamed:@"mebackground"]];
    self.EXlabel.text=_model.title;
}

-(void)setFrame:(CGRect)frame
{
    //提前拦截数据
    CGFloat magin=10.0;
    frame.origin.x +=magin;
    frame.size.width -=magin*2;
    frame.size.height-=magin*2;
    //
    [super setFrame:frame];
}

@end

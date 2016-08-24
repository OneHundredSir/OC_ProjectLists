//
//  WHDCollectionCell.m
//  xiaorizi
//
//  Created by HUN on 16/6/5.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDCollectionCell.h"
#import "WHDShowModel.h"
@interface WHDCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

@end

@implementation WHDCollectionCell

-(void)setModel:(WHDShowModel *)model
{
    _model=model;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_model.img]];
    _lbTitle.text=_model.name;
    
}

//-(void)setFrame:(CGRect)frame
//{
//    CGFloat magin=100;
//    frame.origin.x+=magin;
//    frame.size.width-=magin*2;
//    frame.size.height-=magin;
//    [super setFrame:frame];
//}

- (void)awakeFromNib {
    // Initialization code
}

@end

//
//  GoodCell2.m
//  Flower
//
//  Created by HUN on 16/7/12.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "GoodCell2.h"
#import "ArticleModel.h"


@interface GoodCell2 ()
@property (weak, nonatomic) IBOutlet UIImageView *mainIcon;

@property (weak, nonatomic) IBOutlet UIView *rightView;

@property (weak, nonatomic) IBOutlet UILabel *articletitelLB;

@property (weak, nonatomic) IBOutlet UILabel *numLB;

@end

@implementation GoodCell2
-(void)setModel:(ArticleModel *)model
{
    _model = model;

    _rightView.layer.borderWidth = 1;
    _rightView.layer.borderColor = [UIColor blackColor].CGColor;
    
    //设置背景大图
    [_mainIcon sd_setImageWithURL:[NSURL URLWithString:_model.smallIcon]];
    
    /**
     *  文章头
     */
    _articletitelLB.text = _model.title;
    
    /**
     *  文章详情
     */
    _numLB.text =[ NSString stringWithFormat:@"%d" ,_model.index];
    
    
}

@end

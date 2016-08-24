//
//  GoodCell1.m
//  Flower
//
//  Created by HUN on 16/7/12.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "GoodCell1.h"
#import "ArticleModel.h"

@interface GoodCell1 ()

@property (weak, nonatomic) IBOutlet UIImageView *mainIcon;

@property (weak, nonatomic) IBOutlet UILabel *articletitelLB;

@property (weak, nonatomic) IBOutlet UILabel *numLB;
@end


@implementation GoodCell1

-(void)setModel:(ArticleModel *)model
{
    _model = model;
    //设置背景大图
    [_mainIcon sd_setImageWithURL:[NSURL URLWithString:_model.smallIcon]];

    /**
     *  文章头
     */
    _articletitelLB.text = _model.title;
    
//    NSLog(@"%@",_model.title);
    /**
     *  文章详情
     */
    _numLB.text =[ NSString stringWithFormat:@"TOP %d" ,_model.index];
    
    
}


@end

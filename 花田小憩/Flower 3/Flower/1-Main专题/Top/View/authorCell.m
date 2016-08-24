//
//  authorCell.m
//  Flower
//
//  Created by HUN on 16/7/12.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "authorCell.h"

#import "AuthorModel.h"

@interface authorCell ()
@property (weak, nonatomic) IBOutlet UIImageView *personIcon;

@property (weak, nonatomic) IBOutlet UIImageView *VIcon;

@property (weak, nonatomic) IBOutlet UILabel *titleLB;

@property (weak, nonatomic) IBOutlet UILabel *numLB;

@end


@implementation authorCell

-(void)setModel:(AuthorModel *)model
{
    _model = model;
    
    
    //设置自己的个人图片
    [_personIcon sd_setImageWithURL:[NSURL URLWithString:_model.headImg]];
    _personIcon.layer.cornerRadius = _personIcon.frame.size.width/2.0;
    _personIcon.layer.borderColor = [UIColor whiteColor].CGColor;
    _personIcon.layer.borderWidth = 1;
    _personIcon.clipsToBounds = YES;
    //设置点赞颜色,看下要不要判断
    NSString *imgStr = [_model.authnum integerValue]==1?@"黄色v.png":@"黑色v.png";
    _VIcon.image = [UIImage imageNamed:imgStr];
    /**
     *  主题
     */
    _titleLB.text = _model.userName;
    /**
     *  数目，暂定
     */
    _numLB.text = [NSString stringWithFormat:@"%d",_model.index];
    
    
    
}
@end

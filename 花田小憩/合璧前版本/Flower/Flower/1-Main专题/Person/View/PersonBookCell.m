//
//  PersonBookCell.m
//  Flower
//
//  Created by HUN on 16/7/13.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "PersonBookCell.h"
#import "PersonModel.h"


@interface PersonBookCell ()

@property (weak, nonatomic) IBOutlet UIImageView *titleIcon;

@property (weak, nonatomic) IBOutlet UILabel *userNameLB;

@end


@implementation PersonBookCell

-(void)setModel:(id)model
{
    _model = model;
    
    //设置自己的个人图片
    if (_model.headImg.length>0) {
        [_titleIcon sd_setImageWithURL:[NSURL URLWithString:_model.headImg]];
    }else
    {
        _titleIcon.image = [UIImage imageNamed:@"placehodlerX"];
    }
    _titleIcon.layer.cornerRadius = _titleIcon.frame.size.width/2.0;
    _titleIcon.layer.borderColor = [UIColor whiteColor].CGColor;
    _titleIcon.layer.borderWidth = 1;
    _titleIcon.clipsToBounds = YES;
    //设置点赞颜色,看下要不要判断

    /**
     *  作者名称
     */
    if (_model.userName.length>0) {
        _userNameLB.text = _model.userName;
    }else
    {
        _userNameLB.text = @"匿名用户";
    }
    
    
}

@end

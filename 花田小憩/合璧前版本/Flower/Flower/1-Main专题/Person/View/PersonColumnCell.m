//
//  PersonColumnCell.m
//  Flower
//
//  Created by HUN on 16/7/13.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "PersonColumnCell.h"
#import "ColumModel.h"
@interface PersonColumnCell ()
//大图
@property (weak, nonatomic) IBOutlet UIImageView *backImg;
//题目
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
//内容
@property (weak, nonatomic) IBOutlet UILabel *detailLB;
//喜欢次数
@property (weak, nonatomic) IBOutlet UILabel *likeLB;
//观看次数
@property (weak, nonatomic) IBOutlet UILabel *seeLB;



@end

@implementation PersonColumnCell

-(void)setModel:(ColumModel *)model
{
    _model = model;
    
    //设置自己的个人图片
    
    if (_model.smallIcon.length>0) {
        //设置背景大图
        [_backImg sd_setImageWithURL:[NSURL URLWithString:_model.smallIcon]];
    }else
    {
        _backImg.image = [UIImage imageNamed:@"placehodlerX"];
    }
//    _backImg.layer.cornerRadius = _backImg.frame.size.width/2.0;
    _backImg.layer.borderColor = [UIColor whiteColor].CGColor;
    _backImg.layer.borderWidth = 1;
    _backImg.clipsToBounds = YES;
    //设置点赞颜色,看下要不要判断
    
    /**
     *  主题
     */
    _titleLB.text = _model.title;
    /**
     *  主题描述
     */
    _detailLB.text = _model.desc;
    
    /**
     *  爱心数目
     */
    _likeLB.text = [NSString stringWithFormat:@"%d", _model.fnCommentNum];
    /**
     *  看的人数
     */
    _seeLB.text = [NSString stringWithFormat:@"%d",_model.read];
}

@end

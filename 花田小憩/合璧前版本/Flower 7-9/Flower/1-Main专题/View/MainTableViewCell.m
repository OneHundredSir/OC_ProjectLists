//
//  MainTableViewCell.m
//  Flower
//
//  Created by HUN on 16/7/9.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "MainTableViewCell.h"

@interface MainTableViewCell ()
/**
 *  背景
 */
@property (weak, nonatomic) IBOutlet UIImageView *mainIcon;
/**
 *  人头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *personIcon;

/**
 *  主题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
/**
 *  主题描述
 */
@property (weak, nonatomic) IBOutlet UILabel *detailLB;
/**
 *  属性
 */
@property (weak, nonatomic) IBOutlet UILabel *propertyLB;
/**
 *  文章头
 */
@property (weak, nonatomic) IBOutlet UILabel *articletitelLB;

/**
 *  文章详情
 */
@property (weak, nonatomic) IBOutlet UILabel *articleDetailtitleLB;
/**
 *  评论数目
 */
@property (weak, nonatomic) IBOutlet UILabel *discussNumLB;
/**
 *  爱心数目
 */
@property (weak, nonatomic) IBOutlet UILabel *likeNumLB;
/**
 *  看的人数
 */
@property (weak, nonatomic) IBOutlet UILabel *viewNumLB;

@end

@implementation MainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

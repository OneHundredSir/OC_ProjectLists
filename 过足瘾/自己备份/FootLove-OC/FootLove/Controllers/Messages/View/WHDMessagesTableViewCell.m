//
//  WHDMessagesTableViewCell.m
//  FootLove
//
//  Created by HUN on 16/7/1.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDMessagesTableViewCell.h"
#import "MessageModel.h"
@interface WHDMessagesTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *detail;

@property (weak, nonatomic) IBOutlet UILabel *messageNum;

@end
@implementation WHDMessagesTableViewCell

-(void)setModel:(MessageModel *)model
{
    _model = model;
    //设置图片
    [_userImg sd_setImageWithURL:[NSURL URLWithString:_model.imageUrl]];
    //设置name
    _name.text = _model.nameStr;
    //设置detail
    _detail.text = _model.lastMessage;
    //设置未读数目
    _messageNum.text = _model.totalUnReadCount;
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  ChatViewTableViewCell.m
//  FootLove
//
//  Created by HUN on 16/7/4.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "ChatViewTableViewCell.h"
@interface ChatViewTableViewCell ()
@property (weak, nonatomic) IBOutlet UITextField *timeLB;
@property (weak, nonatomic) IBOutlet UIImageView *titleImg;

@property (weak, nonatomic) IBOutlet UIButton *recordBtn;

//约束部分
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgConstaint_height;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *record_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *record_width;

@end
@implementation ChatViewTableViewCell

- (void)awakeFromNib {
    //设置多行
    self.recordBtn.titleLabel.numberOfLines =0 ;
    self.titleImg.layer.borderWidth = 1;
    self.titleImg.layer.cornerRadius = 2;
}



@end

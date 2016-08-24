//
//  WHDWHDGiftDetailTableViewCell.m
//  FootLove
//
//  Created by HUN on 16/7/5.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDWHDGiftDetailTableViewCell.h"


@interface WHDWHDGiftDetailTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *selectionLogo;

@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@end

@implementation WHDWHDGiftDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  WHDClassSeletedTableViewCell.m
//  xiaorizi
//
//  Created by HUN on 16/6/6.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "WHDClassSeletedTableViewCell.h"
#import "WHDClassSeletedModel.h"
@interface WHDClassSeletedTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *BacImg;
@property (weak, nonatomic) IBOutlet UILabel *detailLB;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property(nonatomic,copy)NSString *urlStr;
@end
@implementation WHDClassSeletedTableViewCell

-(void)setModel:(WHDClassSeletedModel *)model
{
    _model=model;
    [_BacImg sd_setImageWithURL:[NSURL URLWithString:_model.imgStr]];
    _detailLB.text=_model.detail;
    _titleLB.text=_model.title;
    _urlStr=_model.urlStr;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

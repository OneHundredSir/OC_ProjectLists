//
//  WHDFirCell.h
//  xiaorizi
//
//  Created by HUN on 16/6/1.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WHDFirModel.h"
@interface WHDFirCell : UITableViewCell
//上半部分
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (weak, nonatomic) IBOutlet UILabel *MonLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;


//下半部分
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

//背景
@property (weak, nonatomic) IBOutlet UIImageView *backImage;

@end

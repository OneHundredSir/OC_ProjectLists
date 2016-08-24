//
//  SKYinfoCell.h
//  LX-UI模板
//
//  Created by eims1 on 15/10/31.
//  Copyright (c) 2015年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKYinfoCell : UITableViewCell
@property (nonatomic,strong) UIImageView *cityImgView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UIWebView *contentWebView;
@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) UILabel *readNumLabel;

@property (nonatomic,copy) NSString *cityId;
//- (void)fillCellWithObject:(AdvertiseGallery *)object;
@end

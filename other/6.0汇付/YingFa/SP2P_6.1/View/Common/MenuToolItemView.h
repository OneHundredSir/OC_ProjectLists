//
//  MenuToolItemView.h
//  SP2P_6.1
//
//  Created by 李小斌 on 14-6-10.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kICON_WIDTH_HEIGH 24
#define kNAME_LABEL_HEIGH 15
#define kPADDING 10

@interface MenuToolItemView : UICollectionViewCell

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *name;


@end

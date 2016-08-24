//
//  MemberTableViewCell.h
//  SP2P_6.1
//
//  Created by kiu on 14-6-20.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberTableViewCell : UITableViewCell

@property (nonatomic , strong) id object;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *dateTime;
@property (nonatomic, strong) UILabel *youxiao;
@property (nonatomic, strong) UIButton *more;

/**
 *  填充cell的对象
 *
 */

- (void)fillCellWithObject:(id)object;

@end

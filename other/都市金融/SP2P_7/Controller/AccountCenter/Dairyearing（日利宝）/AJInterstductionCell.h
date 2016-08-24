//
//  AJInterstductionCell.h
//  SP2P_7
//
//  Created by Ajax on 16/1/21.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AJInterstductionCell : UITableViewCell
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *title;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

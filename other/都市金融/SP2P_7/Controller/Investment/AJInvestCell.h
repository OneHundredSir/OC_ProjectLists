//
//  AJInvestCell.h
//  SP2P_7
//
//  Created by Ajax on 16/1/16.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Investment;
@interface AJInvestCell : UITableViewCell
@property (nonatomic,strong) Investment *aInvestment;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

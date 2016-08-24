//
//  AJAddCell.h
//  SP2P_7
//
//  Created by Ajax on 16/1/19.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AJAddCellData;
@interface AJAddCell : UITableViewCell
@property (nonatomic,strong) AJAddCellData *aAJAddCellData;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

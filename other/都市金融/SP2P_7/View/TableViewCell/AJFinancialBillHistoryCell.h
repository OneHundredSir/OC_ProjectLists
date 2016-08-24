//
//  AJFinancialBillHistoryCell.h
//  SP2P_7
//
//  Created by Ajax on 16/1/29.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FinancialBills;
@interface AJFinancialBillHistoryCell : UITableViewCell
@property (nonatomic,strong) FinancialBills *aFinancialBills;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

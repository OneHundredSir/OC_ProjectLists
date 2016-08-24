//
//  InvestmentTableViewCell.h
//  SP2P_6.1
//
//  Created by 李小斌 on 14-6-18.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvestmentTableViewCell : UITableViewCell

@property (nonatomic , strong) UIButton *calculatorView;
/**
 *  填充cell的对象
 *
 */
- (void)fillCellWithObject:(id)object;

@end

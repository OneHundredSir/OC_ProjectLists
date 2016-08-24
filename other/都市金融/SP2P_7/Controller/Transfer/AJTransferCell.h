//
//  AJTransferCell.h
//  SP2P_7
//
//  Created by Ajax on 16/1/19.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CreditorTransfer;
@interface AJTransferCell : UITableViewCell
@property (nonatomic,strong) CreditorTransfer *aCreditorTransfer;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

//
//  AJBorrowerInfoCellModel.h
//  SP2P_7
//
//  Created by Ajax on 16/3/18.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AJBorrowerInfoCellModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) BOOL canEdit;
+ (instancetype)modleWithTitle:(NSString *)title content:(NSString *)content;
@end

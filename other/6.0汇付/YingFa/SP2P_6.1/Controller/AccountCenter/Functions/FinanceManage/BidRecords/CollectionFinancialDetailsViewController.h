//
//  CollectionFinancialDetailsViewController.h
//  SP2P_6.1
//
//  Created by Jerry on 14-8-1.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionFinancialDetailsViewController : UIViewController

@property (nonatomic,copy)NSString *titleString;
@property (nonatomic,copy)NSString *borrowID;
@property (nonatomic,assign)CGFloat progressnum;
@property (nonatomic, copy) NSString *timeString;
@property (nonatomic, assign) CGFloat rate;

@end

//
//  ConfirmedViewController.h
//  SP2P_7
//
//  Created by kiu on 14/12/16.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmedViewController : UIViewController

@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *signId;
@property (nonatomic, copy) NSString *bidName;  // 受人Name
@property (nonatomic, copy) NSString *receivedAmount;
@property (nonatomic, copy) NSString *maxOfferPrice;

@end

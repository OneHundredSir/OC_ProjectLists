//
//  DirectionalTransferViewController.h
//  SP2P_6.1
//
//  Created by Jerry on 14-8-2.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DirectionalTransferViewController : UIViewController

@property (nonatomic, copy) NSString *signId;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *bidName;  // 受人Name
@property (nonatomic, copy) NSString *receivedAmount;
@property (nonatomic, copy) NSString *maxOfferPrice;

@end

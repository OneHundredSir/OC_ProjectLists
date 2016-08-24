//
//  CityCommonVC.h
//  Flower
//
//  Created by HUN on 16/7/9.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import "BaseViewController.h"

@interface CityCommonVC : BaseViewController
@property(nonatomic,copy)void (^Seletedblock)(NSString *seletedCityName);
@end

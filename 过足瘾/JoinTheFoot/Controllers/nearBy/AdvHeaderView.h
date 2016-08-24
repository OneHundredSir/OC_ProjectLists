//
//  AdvHeaderView.h
//  JoinTheFoot
//
//  Created by skd on 16/6/28.
//  Copyright © 2016年 lzm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AdvModel.h"

@interface AdvHeaderView : UIView

//这个用来传值的block
@property (nonatomic , copy) void (^tapADV)(AdvModel *am);

- (void)setAdvertismentWithUrl:(NSString *)url pragram:(NSDictionary *)pragam;

@end

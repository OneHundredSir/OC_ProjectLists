//
//  JSDetailView.h
//  JoinTheFoot
//
//  Created by skd on 16/6/28.
//  Copyright © 2016年 lzm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSModel.h"
@interface JSDetailView : UIView

@property (nonatomic , copy) void (^getDataFinished)(void);
@property (nonatomic , strong) JSModel *jsModel;

@end

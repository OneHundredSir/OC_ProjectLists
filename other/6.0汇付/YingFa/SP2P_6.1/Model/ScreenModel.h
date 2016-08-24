//
//  ScreenModel.h
//  SP2P_6.1
//
//  Created by Jerry on 14-7-11.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScreenModel : NSObject

//标签
@property (nonatomic,assign) NSInteger Tag;
//选中状态
@property (nonatomic,assign) NSInteger Checked;
//名字
@property (nonatomic,assign) NSString *name;

@end

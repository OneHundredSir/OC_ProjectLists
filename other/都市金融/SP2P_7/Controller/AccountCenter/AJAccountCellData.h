//
//  AJAccountCellData.h
//  SP2P_7
//
//  Created by Ajax on 16/1/14.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AJAccountCellData : NSObject
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *className;// 跳转控制器
- (instancetype)initWithText:(NSString*)text Img:(NSString*)imgname desClass:(NSString*)className;
@end

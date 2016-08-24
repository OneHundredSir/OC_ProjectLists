//
//  AdvertiseGallery.h
//  SP2P_7
//
//  Created by 李小斌 on 14-6-20.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdvertiseGallery : NSObject

@property (nonatomic, copy)  NSString *title;
@property (nonatomic, copy)  NSString *image;
@property (nonatomic, assign)  NSInteger tag;
@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, copy) NSString *idStr;
@property (nonatomic, copy) NSString *isClick;  // 是否可点击


- (id)initWithTitle:(NSString *)title image:(NSString *)image tag:(NSInteger)tag url:(NSString *)urlStr id:(NSString *)idStr;

@end

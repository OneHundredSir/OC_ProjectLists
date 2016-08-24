//
//  MessageBox.h
//  SP2P_6.1
//
//  Created by kiu on 14-9-29.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//
//  站内信 -> 系统邮件（数据模型）

#import <Foundation/Foundation.h>

@interface MessageBox : NSObject

@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, copy) NSString *timeStr;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *selectall;
@property (nonatomic, copy) NSString *senderName;   // 发件人
@property (nonatomic, copy) NSString *detailTimes;  // 内页时间(格式不同);
@property (nonatomic) NSInteger messageId;          // 站内信ID
@property (nonatomic, assign) CGFloat contentHeight;
@end

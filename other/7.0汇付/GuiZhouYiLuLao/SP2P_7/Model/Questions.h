//
//  Questions.h
//  SP2P_6.1
//
//  Created by Jerry on 14-9-26.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Questions : NSObject

//问题
@property (nonatomic,copy) NSString *question;
//回答
@property (nonatomic,copy) NSString *answerStr;
//提问人
@property (nonatomic,copy) NSString *answerName;
//提问时间
@property (nonatomic,copy) NSString *answerTime;

@property (nonatomic,assign)CGFloat contentHeight;

@property (nonatomic,assign)CGFloat answerSize;

@end

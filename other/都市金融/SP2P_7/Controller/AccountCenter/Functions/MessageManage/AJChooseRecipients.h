//
//  AJChooseRecipients.h
//  SP2P_7
//
//  Created by Ajax on 16/1/30.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AJChooseRecipients : NSObject
@property (nonatomic, copy) NSString *attention_user_name;
@property (nonatomic, copy) NSString *attention_user_photo;
@property (nonatomic, copy) NSString *attentionID;

- (instancetype)initWithDict:(NSDictionary*)dic;
@end

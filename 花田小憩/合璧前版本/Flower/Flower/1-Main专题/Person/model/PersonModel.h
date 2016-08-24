//
//  PersonModel.h
//  Flower
//
//  Created by HUN on 16/7/14.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonModel : NSObject

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *terminal;

@property (nonatomic, assign) BOOL gag;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, assign) NSInteger integral;

@property (nonatomic, assign) NSInteger level;

@property (nonatomic, copy) NSString *imWeibo;

@property (nonatomic, copy) NSString *state;

@property (nonatomic, assign) BOOL championY;

@property (nonatomic, assign) NSInteger subscibeNum;

@property (nonatomic, copy) NSString *validDate_M;

@property (nonatomic, assign) NSInteger articleCount;

@property (nonatomic, assign) NSInteger attentionCount;

@property (nonatomic, copy) NSString *myAuth;//改过主要是判断符号的

@property (nonatomic, assign) BOOL attentioned;

@property (nonatomic, copy) NSString *gagBeginDate;

@property (nonatomic, copy) NSString *email;

@property (nonatomic, assign) BOOL championM;

@property (nonatomic, strong) NSArray *listContent;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *birthday;

@property (nonatomic, copy) NSString *imQQ;

@property (nonatomic, copy) NSString *validDate_Y;

@property (nonatomic, copy) NSString *realName;

@property (nonatomic, copy) NSString *j_PUSH_CODE;

@property (nonatomic, copy) NSString *countryCode;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *gagEndDate;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *occupation;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) BOOL championW;

@property (nonatomic, assign) NSInteger fansCount;

@property (nonatomic, copy) NSString *uplevelPercent;

@property (nonatomic, copy) NSString *password;//被修改过，但是回值都是""

@property (nonatomic, copy) NSString *auth;

@property (nonatomic, copy) NSString *validDate_W;

@property (nonatomic, copy) NSString *loginDate;

@property (nonatomic, assign) NSInteger occSelected;

@property (nonatomic, copy) NSString *token;

@property (nonatomic, assign) BOOL dingYue;

@property (nonatomic, copy) NSString *imWeixin;

@property (nonatomic, copy) NSString *identity;

@property (nonatomic, copy) NSString *password1;

@property (nonatomic, copy) NSString *market;

@property (nonatomic, copy) NSString *speciality;

@property (nonatomic, assign) NSInteger experience;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, assign) BOOL jian;

@end

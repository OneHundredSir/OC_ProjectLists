//
//  MainTableModel.h
//  Flower
//
//  Created by HUN on 16/7/10.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import <Foundation/Foundation.h>


@class Author,Category1;
@interface MainTableModel : NSObject

@property (nonatomic, assign) NSInteger fnDifficultyNum;

@property (nonatomic, strong) Author *author;

@property (nonatomic, copy) NSString *videoUrl;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *content2;

@property (nonatomic, strong) Category1 *category;

@property (nonatomic, copy) NSString *contentTitle2;

@property (nonatomic, assign) BOOL check;

@property (nonatomic, copy) NSString *descTitle;

@property (nonatomic, assign) NSInteger newFavo;

@property (nonatomic, assign) NSInteger newAppoint;

@property (nonatomic, assign) NSInteger fnCommentNum;

@property (nonatomic, assign) NSInteger appoint;

@property (nonatomic, assign) NSInteger fnCuringNum;

@property (nonatomic, assign) NSInteger favo;

@property (nonatomic, assign) NSInteger fnIsVph;

@property (nonatomic, copy) NSString *fnGoodsIds;

@property (nonatomic, assign) NSInteger pass;

@property (nonatomic, assign) NSInteger share;

@property (nonatomic, strong) NSArray *goodsList;

@property (nonatomic, copy) NSString *contentTitle3;

@property (nonatomic, copy) NSString *pushTime;

@property (nonatomic, assign) BOOL hasAddFavo;

@property (nonatomic, assign) BOOL top;

@property (nonatomic, copy) NSString *descIcon;

@property (nonatomic, assign) NSInteger newRead;

@property (nonatomic, assign) NSInteger fnHumidityNum;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, assign) BOOL hasAppoint;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *content3;

@property (nonatomic, copy) NSString *contentTitle1;

@property (nonatomic, assign) NSInteger fnVphReadNum;

@property (nonatomic, assign) NSInteger order;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *pageUrl;

@property (nonatomic, assign) NSInteger read;

@property (nonatomic, copy) NSString *sharePageUrl;

@property (nonatomic, assign) BOOL video;

@property (nonatomic, copy) NSString *keywords;

@property (nonatomic, copy) NSString *smallIcon;

@property (nonatomic, copy) NSString *title;


@end

@interface Author : NSObject

@property (nonatomic, assign) BOOL jian;

@property (nonatomic, copy) NSString *terminal;

@property (nonatomic, assign) BOOL gag;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, assign) NSInteger integral;

@property (nonatomic, assign) NSInteger level;

@property (nonatomic, copy) NSString *imWeibo;

@property (nonatomic, copy) NSString *state;

@property (nonatomic, assign) NSInteger newAuth;

@property (nonatomic, assign) BOOL championY;

@property (nonatomic, assign) NSInteger subscibeNum;

@property (nonatomic, copy) NSString *validDate_M;

@property (nonatomic, assign) NSInteger articleCount;

@property (nonatomic, assign) NSInteger attentionCount;

@property (nonatomic, copy) NSString *Auth;

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

@property (nonatomic, copy) NSString *Password;

@property (nonatomic, copy) NSString *auth;

@property (nonatomic, copy) NSString *validDate_W;

@property (nonatomic, copy) NSString *loginDate;

@property (nonatomic, assign) NSInteger occSelected;

@property (nonatomic, copy) NSString *token;

@property (nonatomic, assign) BOOL dingYue;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *imWeixin;

@property (nonatomic, copy) NSString *identity;

@property (nonatomic, copy) NSString *password;

@property (nonatomic, copy) NSString *market;

@property (nonatomic, copy) NSString *speciality;

@property (nonatomic, assign) NSInteger experience;

@property (nonatomic, copy) NSString *headImg;

@end

@interface Category1 : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, assign) NSInteger order;

@property (nonatomic, copy) NSString *name;

@end


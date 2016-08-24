//
//  ColumModel.h
//  Flower
//
//  Created by HUN on 16/7/15.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthorModel.h"
@class ArticleModel;
@interface ColumModel : NSObject

@property(nonatomic,strong)AuthorModel *authorModel;

@property (nonatomic, assign) NSInteger fnDifficultyNum;

@property (nonatomic, copy) NSString *videoUrl;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *content2;

@property (nonatomic, copy) NSString *category;

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

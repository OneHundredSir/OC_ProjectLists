//
//  WHDFirModel.h
//  xiaorizi
//
//  Created by HUN on 16/6/1.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@class List,Events,Cats,Sponsor,Price,shops,More,Price1,Themes;
@interface WHDFirModel : NSObject

@property (nonatomic, copy) NSString *date;

@property (nonatomic, strong) NSArray<Events *> *events;

@property (nonatomic, strong) NSArray<Themes *> *themes;

@end

@interface Events : NSObject

@property (nonatomic, copy) NSString *feeltitle;

@property (nonatomic, copy) NSString *position;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger feelnum;

@property (nonatomic, copy) NSString *telephone;

@property (nonatomic, copy) NSString *mobileURL;

@property (nonatomic, assign) NSInteger startdate;

@property (nonatomic, strong) NSArray *events;

@property (nonatomic, strong) NSArray<shops *> *allshops;

@property (nonatomic, copy) NSString *shareURL;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *tag;

@property (nonatomic, assign) NSInteger eventtype;

@property (nonatomic, assign) long long enddate;

@property (nonatomic, copy) NSString *feel;

@property (nonatomic, strong) NSArray<NSString *> *imgs;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, assign) NSInteger islongtime;

@property (nonatomic, copy) NSString *adurl;

@property (nonatomic, assign) NSInteger eid;

@property (nonatomic, strong) Cats *cat;

@property (nonatomic, copy) NSString *note;

@property (nonatomic, strong) Sponsor *sponsor;

@property (nonatomic, copy) NSString *questionURL;

@property (nonatomic, copy) NSString *detail;

@property (nonatomic, strong) NSArray<More *> *more;

@property (nonatomic, strong) Price *price;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *address;

@end

@interface Cats : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, copy) NSString *id;

@end

@interface Sponsor : NSObject

@end

@interface Price : NSObject

@property (nonatomic, copy) NSString *currency_token;

@property (nonatomic, strong) NSArray *list;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *price_currency;

@end

@interface shops : NSObject

@property (nonatomic, copy) NSString *position_gcj02;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *position;

@property (nonatomic, copy) NSString *address;

@end

@interface More : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSArray<NSString *> *imgs;

@property (nonatomic, strong) Price1 *price;

@property (nonatomic, copy) NSString *position;

@property (nonatomic, copy) NSString *address;

@end

@interface Price1 : NSObject

@property (nonatomic, copy) NSString *currency_token;

@property (nonatomic, strong) NSArray *list;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *price_currency;

@end

@interface Themes : NSObject

@property (nonatomic, assign) NSInteger hasweb;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, copy) NSString *themeurl;

@property (nonatomic, assign) NSInteger height;

@property (nonatomic, copy) NSString *keywords;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger width;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *begin_time;

@end


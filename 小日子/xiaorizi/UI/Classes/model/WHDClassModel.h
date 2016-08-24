//
//  WHDClassModel.h
//  xiaorizi
//
//  Created by HUN on 16/6/5.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Tags;
@interface WHDClassModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, strong) NSArray<Tags *> *tags;

@end
@interface Tags : NSObject

@property (nonatomic, assign) NSInteger ev_count;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, copy) NSString *name;

@end


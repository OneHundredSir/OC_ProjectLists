//
//  WHDClassSeletedModel.h
//  xiaorizi
//
//  Created by HUN on 16/6/6.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WHDClassSeletedModel : NSObject
@property(nonatomic,copy)NSString *urlStr;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *detail;
@property(nonatomic,copy)NSString *imgStr;

+(instancetype)makeUpModel:(NSDictionary *)dic;
@end


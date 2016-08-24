//
//  ShopDetailModel.h
//  FootLove
//
//  Created by HUN on 16/6/29.
//  Copyright © 2016年 hundred Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopDetailModel : NSObject
//头
@property(nonatomic,copy)NSString *titleStr;
//电话
@property(nonatomic,copy)NSString *telStr;
//地址
@property(nonatomic,copy)NSString *adrStr;

//技师数组
@property(nonatomic,strong)NSArray *JS_Arr;

//项目数组
@property(nonatomic,strong)NSArray *project_Arr;

@end

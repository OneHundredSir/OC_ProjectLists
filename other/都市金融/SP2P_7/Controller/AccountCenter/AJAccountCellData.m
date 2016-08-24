//
//  AJAccountCellData.m
//  SP2P_7
//
//  Created by Ajax on 16/1/14.
//  Copyright © 2016年 EIMS. All rights reserved.
//

#import "AJAccountCellData.h"

@implementation AJAccountCellData
- (instancetype)initWithText:(NSString *)text Img:(NSString *)imgname desClass:(NSString *)className
{
    if (self = [super init]) {
        self.text = text;
        self.img = imgname;
        self.className = className;
    }
    return self;
}
@end

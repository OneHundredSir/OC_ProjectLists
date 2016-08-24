//
//  NSString+encryptDES.h
//  SP2P_7
//
//  Created by Jerry on 14/11/27.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import "ConverUtil.h"

@interface NSString (encryptDES)

+ (NSString *)encrypt3DES:(NSString *)src key:(NSString *)key;
+ (NSString *)decrypt3DES:(NSString *)src key:(NSString *)key;

@end

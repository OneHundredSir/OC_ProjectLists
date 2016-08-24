//
//  NetWorkConfig.h
//  Shove
//
//  Created by 李小斌 on 14-9-22.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#ifndef Shove_NetWorkConfig_h
#define Shove_NetWorkConfig_h

#import "AFNetworking.h"
#import "ShoveGeneralRestGateway.h" 
#import "ColorTools.h"
#import <ShareSDK/ShareSDK.h>
#import "NSString+encryptDES.h"
#import "ReLogin.h"
#import "NSString+Date.h"

// 升级版本标识符
#define codeNum 1


// app端传输 key
#define MD5key  @"Lj3OeLYgKnfmQGtv"
// 加密 key
#define DESkey  @"0dlaKCar9jNB4exQ"
//
//#define Baseurl   @"http://192.168.8.98:9000"

//#define Baseurl   @"http://192.168.8.90:9000"//本地域名
#define Baseurl   @"http://p2p-3.test11.shovesoft.com"//测试站点

#endif

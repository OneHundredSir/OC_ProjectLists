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

// app端传输 key
#define MD5key  @"JA8h8NCPs5Oov7bq"
// 加密 key
#define DESkey  @"rMnhi0h7iTi25tPU"

// 升级版本标识符
#define codeNum 4

//#define Baseurl   @"http://www.niumail.com.cn"       // 公网站点
//#define Baseurl   @"http://192.168.8.101:9000"               // 本地站点
//#define Baseurl   @"http://121.201.104.219"       // 测试
#define Baseurl   @"http://www.sjjrp2p.com"

#endif

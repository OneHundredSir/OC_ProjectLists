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

// 升级版本标识符
#define codeNum 1


// app端传输 key
#define MD5key  @"DFGgrgkl45DGkj8g"
//#define MD5key  @"7dzag1ow9mQ6KMK6"
// 加密 key
#define DESkey  @"GDgLwwdK270Qj1w4"

#define Baseurl   @"http://www.niumail.com"
//#define Baseurl   @"http://business.p2p.eimslab.cn"
//#define Baseurl   @"http://192.168.8.81:9000"
//#define Baseurl   @"http://p2p-10.test9.shovesoft.com"
//#define Baseurl   @"http://www.hxqdw.cn"//正式站点
#endif

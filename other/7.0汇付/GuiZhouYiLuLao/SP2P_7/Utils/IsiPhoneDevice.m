//
//  IsiPhoneDevice.m
//  SP2P_7
//
//  Created by kiu on 15/3/9.
//  Copyright (c) 2015年 EIMS. All rights reserved.
//
//  识别iPhone设备

#import "IsiPhoneDevice.h"
#import <sys/utsname.h>

@implementation IsiPhoneDevice

+ (NSString*)deviceString
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4s";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    DLOG(@"NOTE: Unknown device type: %@", deviceString);
    return deviceString;
}

// iOS 设备型号对照表
//iPhone2,1 ( 3GS 产品型号：国行-A1325 ；国际版-A1303
//iPhone3,1(iPhone4 GSM 产品型号：A1332  )
//iPhone3,2  ( iPhone4 8G新制程版,目前新出的国行8G版均为此型号 型号同为: A1332)
//iPhone3,3 ( iPHONE4 CDMA 产品型号：A1349 )
//iPhone4,1 (iPhone4s 产品型号：A1387(电信版&国际版) ； A1431(联通专用型号) )
//iPhone5,1 ( iPhone5 产品型号: A1428 - 3G+4G+GSM )
//iPhone5,2 ( iPhone5 产品型号: A1429 ；中国电信定制版-A1442 - 3G+4G+GSM+CDMA )
//iPhone 5,3 (iPhone5c 产品型号: A1532 A1456 CDMA)
//iPhone 5,4 (iPhone5c 产品型号: A1526 A1529 A1507 GSM)
//iPhone 6,1 (iPhone5s 产品型号: A1533 A1453 CDMA)
//iPhone 6,2 (iPhone5s 产品型号: A1528 A1530 A1457 GSM)
//iPhone7,1(iPhone6 Plus)
//iPhone7,2(iPhone6)
//iPod4,1 ( iPod touch4 产品型号：A1367 )
//iPod5,1 ( iPod touch5 产品型号：A1421 )
//iPad2,1 ( 产品型号：A1395 iPad 2 Wi-Fi )
//iPad2,2 ( 产品型号：A1396 iPad 2 Wi-Fi+3G+GSM )
//iPad2,3 ( 产品型号：A1397 iPad 2 Wi-Fi+3G+GSM+CDMA )
//iPad2,4 ( 产品型号：? iPad 2 Wi-Fi rev_a 新制程版 )
//iPad3,1 ( 产品型号：A1416 牛排 - iPad 3 Wi-Fi )
//iPad3,2 ( 产品型号：A1403 牛排 - iPad 3 Wi-Fi+3G+GSM+CDMA )
//iPad3,3 ( 产品型号：A1430 牛排 - iPad 3 Wi-Fi+3G+GSM )
//iPad2,5 ( 产品型号:A1432 - iPad mini Wi-Fi )
//iPad2,6 ( 产品型号:A1454 - iPad mini Wi-Fi+3G+4G+GSM )
//iPad2,7 ( 产品型号:A1455 - iPad mini Wi-Fi+3G+4G+GSM+CDMA )
//iPad3,4 ( 产品型号:A1458 - iPad 4 Wi-Fi )
//iPad3,5 ( 产品型号:A1459 - iPad 4 Wi-Fi+3G+4G+GSM)
//iPad3,6 ( 产品型号:A1460 - iPad 4 Wi-Fi+3G+4G+GSM+CDMA )

@end

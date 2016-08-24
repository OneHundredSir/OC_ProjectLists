//
//  ColorTools.h
//  EnterpriseWeb
//
//  Created by 李小斌 on 14-5-28.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

//设置RGB颜色值
#define SETCOLOR(R,G,B,A)	[UIColor colorWithRed:(CGFloat)R/255 green:(CGFloat)G/255 blue:(CGFloat)B/255 alpha:A]

//#define KColor  SETCOLOR(58,164,249,1.0)

#define KColor  [ColorTools colorWithHexString:@"#6593c2"]
//棕色
#define BrownColor  [ColorTools colorWithHexString:@"#6593c2"]
// 每个View背景色值
#define KblackgroundColor  [ColorTools colorWithHexString:@"#f0f0f0"]
// 登录框 边框色值
#define KlayerBorder  [ColorTools colorWithHexString:@"#d9d9d9"]
//绿色颜色值
#define GreenColor [ColorTools colorWithHexString:@"#6593c2"]
//粉红颜色值
#define PinkColor  [ColorTools colorWithHexString:@"#e34f4f"]
//蓝色字体颜色值
#define BluewordColor  [ColorTools colorWithHexString:@"#436EEE"]

@interface ColorTools : NSObject

/** 颜色转换 IOS中十六进制的颜色转换为UIColor **/
+ (UIColor *) colorWithHexString: (NSString *)color;

@end

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

#define KColor  SETCOLOR(239,90,80,1.0)

//#define KColor  [ColorTools colorWithHexString:@"#195a9c"]

// 每个View背景色值
//#define KblackgroundColor  [ColorTools colorWithHexString:@"#cccccc"]
#define KblackgroundColor  SETCOLOR(240.f,240.f,240.f,1.f)
// 登录框 边框色值
#define KlayerBorder  [ColorTools colorWithHexString:@"#d9d9d9"]
//tabbar选中颜色值
#define GreenColor KColor
//粉红颜色值
#define PinkColor  [ColorTools colorWithHexString:@"#e34f4f"]
//蓝色字体颜色值
#define BluewordColor  [ColorTools colorWithHexString:@"#436EEE"]
//绿颜色值
#define kAttentionColor [ColorTools colorWithHexString:@"#18b15f"]

@interface ColorTools : NSObject

/** 颜色转换 IOS中十六进制的颜色转换为UIColor **/
+ (UIColor *) colorWithHexString: (NSString *)color;

@end
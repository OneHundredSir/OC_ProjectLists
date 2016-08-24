//
//  AppDefaultUtil.h
//  SP2P_6.1
//
//  Created by 李小斌 on 14-9-30.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppDefaultUtil : NSObject

/**
 单例模式，实例化对象
 */
+ (instancetype)sharedInstance;

// 设置是否记住密码
-(void) setRemeberUser:(BOOL)value;

// 获取用户是否记住密码
-(BOOL) isRemeberUser;

// 设置用户是否第一次登陆
-(void) setFirstLancher:(BOOL)value;

// 获取用户是第一次登录
-(BOOL) isFirstLancher;

// 保存最后一次用户登录的用户昵称
-(void) setDefaultUserName:(NSString *)value;

// 获取最后一次用户登录的用户昵称
-(NSString *) getDefaultUserName;

// 保存最后一次用户登录的用户账号
-(void) setDefaultAccount:(NSString *)value;

// 获取最后一次用户的登录账号
-(NSString *) getDefaultAccount;

// 保存最后一次登录的用户密码(des加密后)
-(void) setDefaultUserPassword:(NSString *)value;

// 获取最后一次登录的用户密码(des加密后)
-(NSString *) getDefaultUserPassword;

// 设置用户头像链接
-(void) setDefaultHeaderImageUrl:(NSString *)value;

// 获取某用户的头像链接
-(NSString *) getDefaultHeaderImageUrl;

// 设置某账户用户手势密码
-(void) setGesturesPasswordWithAccount:(NSString *) userAccount gesturesPassword:(NSString *) gestures;

// 移除某账户的手势密码
-(void) removeGesturesPasswordWithAccount:(NSString *) userAccount;

// 获取某账户的手势密码
-(NSString *) getGesturesPasswordWithAccount:(NSString *) userAccount;

// 保存设备型号
-(void) setdeviceType:(NSString *) deviceType;
// 获取设备型号
-(NSString *) getdeviceType;


// 保存最后一次密码(没加密)
//-(void) setDefaultUserNoPassword:(NSString *)value;
// 获取最后一次密码(没加密)
//-(NSString *) getDefaultUserNoPassword;

// 保存最后一次启动网络图片
-(void) setAppImage:(NSString *)value;
// 获取最后一次启动网络图片
-(NSString *) getAppImage;

@end

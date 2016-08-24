//
//  AppDefaultUtil.m
//  SP2P_7
//
//  Created by 李小斌 on 14-9-30.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "AppDefaultUtil.h"


#define KEY_FIRST_LANCHER @"FirstLancher" // 记录用户是否第一次登陆，YES为是，NO为否

#define KEY_USER_NAME @"UserName" // 用户昵称

#define KEY_ACCOUNT @"Account" // 账号

#define KEY_PASSWORD @"Password" // 密码

#define KEY_HEARD_IMAGE @"HeardImage" //头像

#define KEY_GESTURES_PASSWORD @"GesturesPassword" //手势密码

#define KEY_REMEBER_USER @"RemeberUser" //  记住用户

#define KEY_DEVICE_TYPE @"deviceType" //设备型号

#define KEY_appImage @"appImage" //启动网络图片

#define KEY_Name_List @"NameList" // 名字列表

@interface AppDefaultUtil()

@end

@implementation AppDefaultUtil

+ (instancetype)sharedInstance {
    
    static AppDefaultUtil *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedClient = [[AppDefaultUtil alloc] init];
        
    });
    
    return _sharedClient;
}

// 设置是否记住密码
-(void) setRemeberUser:(BOOL)value
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:value forKey:KEY_REMEBER_USER];
    [defaults synchronize];
}

-(BOOL) isRemeberUser
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:KEY_REMEBER_USER];
}

// 用户是否第一次登陆
-(void) setFirstLancher:(BOOL)value
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:value forKey:KEY_FIRST_LANCHER];
    [defaults synchronize];
}

-(BOOL) isFirstLancher
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:KEY_FIRST_LANCHER];
}

// 用户昵称
-(void) setDefaultUserName:(NSString *)value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:KEY_USER_NAME];
    [defaults synchronize];
}

-(NSString *) getDefaultUserName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:KEY_USER_NAME];
}

// 账号
-(void) setDefaultAccount:(NSString *)value
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:KEY_ACCOUNT];
    [defaults synchronize];
}

-(NSString *) getDefaultAccount
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:KEY_ACCOUNT];
}

// 密码 (des 加密后)
-(void) setDefaultUserPassword:(NSString *)value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:KEY_PASSWORD];
    [defaults synchronize];
}

-(NSString *) getDefaultUserPassword
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:KEY_PASSWORD];
}


// 用户头像
-(void) setDefaultHeaderImageUrl:(NSString *)value
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:KEY_HEARD_IMAGE];
    [defaults synchronize];
}

-(NSString *) getDefaultHeaderImageUrl
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:KEY_HEARD_IMAGE];
}

// 设置手势密码
-(void) setGesturesPasswordWithAccount:(NSString *) userAccount gesturesPassword:(NSString *) gestures
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
//    NSMutableDictionary *dics = [NSMutableDictionary dictionary];
    
//    dics = (NSMutableDictionary *)[self getGesturesPassword];
    
//    [dics setObject:gestures forKey:userAccount];
    
    [defaults setObject:gestures forKey:KEY_GESTURES_PASSWORD];
    
    [defaults synchronize];
}
//
// // 获取某账号的手势密码
//-(NSString *) getGesturesPasswordWithAccount:(NSString *) userAccount
//{
//    NSMutableDictionary *dics = [self getGesturesPassword];
//    return [dics objectForKey:userAccount];
//}


// 获取某账号的手势密码
-(NSString *) getGesturesPasswordWithAccount:(NSString *) userAccount
{
    NSString *results = [self getGesturesPassword];
    return results;
}

// 移除某账户的手势密码
-(void) removeGesturesPasswordWithAccount:(NSString *) userAccount
{
    
//    NSMutableDictionary *dics = [self getGesturesPassword];
    NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
    [defaults1 removeObjectForKey:KEY_GESTURES_PASSWORD];
    [defaults1 synchronize];
//     [dics removeObjectForKey:userAccount];
}
//
//// 获取手势密码的字典集合
//-(NSMutableDictionary *) getGesturesPassword
//{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSMutableDictionary *results = [defaults objectForKey:KEY_GESTURES_PASSWORD];
//    DLOG(@"手势密码存储的信息:%@",results);
//    if (results == nil) {
//        results = [[NSMutableDictionary alloc] init];
//    }
//    return results;
//}


// 获取手势密码的字典集合
-(NSString *) getGesturesPassword
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *results = [defaults objectForKey:KEY_GESTURES_PASSWORD];
    DLOG(@"手势密码存储的信息:%@",results);
//    if (results == nil) {
//        results = [[NSMutableDictionary alloc] init];
//    }
    return results;
}

-(void) setdeviceType:(NSString *) deviceType {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:deviceType forKey:KEY_DEVICE_TYPE];
    [defaults synchronize];
}

-(NSString *) getdeviceType
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:KEY_DEVICE_TYPE];
}

// 保存启动网络图片
-(void) setAppImage:(NSString *)value {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:KEY_appImage];
    [defaults synchronize];
}
// 获取启动网络图片
-(NSString *) getAppImage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:KEY_appImage];
}

//登录用户名列表
-(void) setDefaultNameList:(NSArray *)nameArr
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nameArr forKey:KEY_Name_List];
    [defaults synchronize];
}

-(NSArray *) getDefaultNameList
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *nameList = [defaults objectForKey:KEY_Name_List];
    if (nameList == nil) {
        nameList = [[NSArray alloc] init];
    }
    return nameList;
}


@end

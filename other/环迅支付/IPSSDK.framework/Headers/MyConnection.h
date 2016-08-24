
//  MyConnection.h
//  caomeixing
//
//  Created by ips on 12-6-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
@protocol headViewDelegate
-(void)clickUserInfo:(id)sender;
@end
#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>
@interface MyConnection : NSObject
<MBProgressHUDDelegate,NSXMLParserDelegate>
{
	MBProgressHUD *HUD;
    long long expectedLength;
	long long currentLength;
    NSInteger isShow;
    NSString *MydesIv;
    NSString *MydesKey;
    
@private
    NSMutableSet *mDelegates;
    NSMutableData *mData;
    NSString *postUrl;
    NSXMLParser *xmlParser;
    NSData *addData;//累加的data
    BOOL recordResults;
    NSString *HTTPType;
    id nav;
    NSMutableString *soapResults;
    NSURLConnection *postConnection;
    NSMutableDictionary *AgainDictionary;
    NSURLAuthenticationChallenge *Mychallenge;
    id<headViewDelegate> viewDelegate;
}
+(NSString *)getDataFunction;
+(NSString *) jsonStringWithObject:(id) object;
-(void)setHTTPType:(NSString *)sender;
+(NSInteger)ReachableStatus;
+(UIImage *)getAvatar:(NSString *)url;
//+(NSString *)getDataFunction;
+(UIFont *)getFont;
+(UIColor *)getColor;
+(NSString *)md5:(NSString *)inPutText;
+(NSString *) jsonStringWithArray:(NSArray *)array;
+(NSString *) jsonStringWithdictionary1:(NSDictionary *)dictionary;
+(NSString *) jsonStringWithdictionary:(NSDictionary *)dictionary;
//3DES加密
+ (NSString*)TripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation) encryptOrDecrypt key:(NSString*)key desIv:(NSString*)desIv;
+(NSString *)MD5getSign:(id )Content;
- (void) addDelegate:(id)delegate views:(UIView *)views;
- (void) addDelegate:(id)delegate views:(UIView *)views
        andDelegates:(id<headViewDelegate>)d;
- (void) removeDelegate:(id)delegate;
- (void) setViewShow:(int)is;
-(NSMutableURLRequest *) jsonGetData:(NSString *)str serverUrl:(NSString *)serverUrl;
-(void)postxml:data;
+(UIImage*)scaleToSize:(UIImage*)img size:(CGSize)size;
-(NSURLConnection *)startConnection:(NSString *)url data:(id)data;
//RSA加密解密
+(SecKeyRef) getPublicKey:(NSString*) publicKey;
+(NSData*) rsaEncryptString:(NSString*)Value Keystring:(NSString*)stringKey;
+(NSString *)getDES3:(NSString *)str keyst:keystr ivstr:ivstring;
+(NSString *)encodeToPercentEscapeString: (NSString *) input;
@end
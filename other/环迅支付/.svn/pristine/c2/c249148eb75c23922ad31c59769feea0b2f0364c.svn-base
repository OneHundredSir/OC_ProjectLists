//
//  NSString+encryptDES.m
//  SP2P_7
//
//  Created by Jerry on 14/11/27.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import "NSString+encryptDES.h"

@implementation NSString (encryptDES)
///*
// 
// 3DES加密
// 
// */
//
//+(NSString *) encryptUseDES:(NSString *)clearText key:(NSString *)key
//{
//    NSString *ciphertext = nil;
//    NSData *textData = [clearText dataUsingEncoding:NSUTF8StringEncoding];
//    NSUInteger dataLength = [clearText length];
//
//    unsigned char buffer[dataLength];
//    memset(buffer, 0, sizeof(char));
//    size_t numBytesEncrypted = 0;
//    
//    
//    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, //  加密
//                                          kCCAlgorithmDES, //  加密根据哪个标准
//                                          kCCOptionPKCS7Padding, //  选项分组密码算法(des:对每块分组加一次密  3DES：对每块分组加三个不同的密)
//                                          [key UTF8String], //密钥    加密和解密的密钥必须一致
//                                          kCCKeySizeDES, //   DES 密钥的大小（kCCKeySizeDES=8）
//                                          nil,    //  可选的初始矢量
//                                          [textData bytes], // 数据的存储单元
//                                          dataLength, // 数据的大小
//                                          buffer,// 用于返回数据
//                                          1024,
//                                          &numBytesEncrypted);
//    if (cryptStatus == kCCSuccess) {
//        DLOG(@"DES加密成功");
//        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
//        Byte* bb = (Byte*)[data bytes];
//        ciphertext = [ConverUtil parseByteArray2HexString:bb];
//    }else{
//        DLOG(@"DES加密失败");
//    }
//    DLOG(@"ciphertext Is 加密结果:%@",ciphertext);
//    return ciphertext;
//}

/*
 
 加密
 
 */
+ (NSString *)encrypt3DES:(NSString *)src key:(NSString *)key{
    const void *vplainText;
    size_t plainTextBufferSize;
    NSData* data = [src dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    plainTextBufferSize = [data length];
    vplainText = (const void *)[data bytes];
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    const void *vkey = (const void *)[key UTF8String];
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithmDES,
                       kCCOptionPKCS7Padding | kCCOptionECBMode,
                       vkey,
                       kCCKeySizeDES,
                       nil,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    return [ConverUtil NSDataToHexString:myData];
}


/*
 
 解密
 
*/
+ (NSString *)decrypt3DES:(NSString *)src key:(NSString *)key{
    const void *vplainText;
    size_t plainTextBufferSize;
    NSData *EncryptData = [ConverUtil hexStrToNSData:src];
    plainTextBufferSize = [EncryptData length];
    vplainText = [EncryptData bytes];
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    const void *vkey = (const void *)[key UTF8String];
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithmDES,
                       kCCOptionPKCS7Padding | kCCOptionECBMode,
                       vkey,
                       kCCKeySizeDES,
                       nil,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *dataBuf = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    return [[NSString alloc] initWithData:dataBuf
                                 encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)]
    ;
}

@end

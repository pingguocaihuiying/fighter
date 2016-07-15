//
//  PBEWithMD5AndDES.h
//  fighter
//
//  Created by kang on 16/7/7.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTEncoderAndDecoder : NSObject

+ (NSData *)encryptPBEWithMD5AndDESData:(NSData *)inData password:(NSString *)password iterations:(int)iterations;
+ (NSData *)decryptPBEWithMD5AndDESData:(NSData *)inData password:(NSString *)password iterations:(int)iterations;
+ (NSData *)encodePBEWithMD5AndDESData:(NSData *)inData password:(NSString *)password direction:(int)direction iterations:(int)iterations;


#pragma mark - decode
+ (NSString *) encodeWithPBE:(NSString *)message;

#pragma mark - encode
+ (NSString *) decodeWithPBE:(NSString *)message;


#pragma mark - AES加密
//将string转成带密码的data
+(NSString*)encryptAESData:(NSString*)string app_key:(NSString*)key;

#pragma mark - AES解密
//将带密码的data转成string
+(NSString*)decryptAESData:(NSData*)data  app_key:(NSString*)key;

#pragma mark - url转码
+ (NSString *)encodeToPercentEscapeString: (NSString *) input;
@end

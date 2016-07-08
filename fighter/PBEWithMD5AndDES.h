//
//  PBEWithMD5AndDES.h
//  fighter
//
//  Created by kang on 16/7/7.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBEWithMD5AndDES : NSObject

+ (NSData *)encryptPBEWithMD5AndDESData:(NSData *)inData password:(NSString *)password iterations:(int)iterations;
+ (NSData *)decryptPBEWithMD5AndDESData:(NSData *)inData password:(NSString *)password iterations:(int)iterations;
+ (NSData *)encodePBEWithMD5AndDESData:(NSData *)inData password:(NSString *)password direction:(int)direction iterations:(int)iterations;


#pragma mark - decode
+ (NSString *) encodeWithPBE:(NSString *)message;

#pragma mark - encode
+ (NSString *) decodeWithPBE:(NSString *)message;

@end

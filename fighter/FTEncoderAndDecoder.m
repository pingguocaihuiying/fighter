//
//  PBEWithMD5AndDES.m
//  fighter
//
//  Created by kang on 16/7/7.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTEncoderAndDecoder.h"
#include <openssl/ssl.h>
#include <openssl/sha.h>
#include <openssl/x509.h>
#include <openssl/evp.h>
#include <openssl/err.h>

#import "Base64-umbrella.h"
#import "GTMBase64-umbrella.h"
#import <objc/runtime.h>


#import <CommonCrypto/CommonCryptor.h>
#define gIv @"0102030405060708" //可以自行定义16位
@interface NSData (NSData_AES)

- (NSData *)AES128EncryptWithKey:(NSString *)key;   //加密
- (NSData *)AES128DecryptWithKey:(NSString *)key;   //解密

@end

@implementation NSData (NSData_AES)
//(key和iv向量这里是16位的) 这里是CBC加密模式，安全性更高

- (NSData *)AES128EncryptWithKey:(NSString *)key//加密
{
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCKeySizeAES128+1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [gIv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          ivPtr,
                                          [self bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}


- (NSData *)AES128DecryptWithKey:(NSString *)key//解密
{
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCKeySizeAES128+1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [gIv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          ivPtr,
                                          [self bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}

@end

#pragma mark - FTEncoderAndDecoder

@implementation FTEncoderAndDecoder

/*
 Usage
 
 NSString *password = @"1111";
 
 NSString *message = @"xxx";
 NSData *inData = [message dataUsingEncoding:NSUTF8StringEncoding];
 NSData *encData = [securityUtils encryptPBEWithMD5AndDESData:inData password:password];
 NSString *encString = [encData base64EncodedString];
 
 NSString *encString = @"LP+YKAUNy88=";
 NSData *decData = [securityUtils decryptPBEWithMD5AndDESData:[encString base64DecodedBytes] password:password];
 NSString *decodedString = [[[NSString alloc] initWithData:decData encoding:NSUTF8StringEncoding] autorelease];
 */

+ (NSData *)encryptPBEWithMD5AndDESData:(NSData *)inData password:(NSString *)password  iterations:(int)iterations{
    return [self encodePBEWithMD5AndDESData:inData password:password direction:1 iterations:iterations];
}

+ (NSData *)decryptPBEWithMD5AndDESData:(NSData *)inData password:(NSString *)password  iterations:(int)iterations {
    return [self encodePBEWithMD5AndDESData:inData password:password direction:0 iterations:iterations];
}

+ (NSData *)encodePBEWithMD5AndDESData:(NSData *)inData password:(NSString *)password direction:(int)direction iterations:(int)iterations
{
    
    // Change salt and number of iterations for your project !!!
    
    static const char gSalt[] =
    {
        
        (unsigned char) 0xaa, (unsigned char) 0xaa, (unsigned char) 0xce, (unsigned char) 0xce,
        (unsigned char) 0xaa, (unsigned char) 0xaa, (unsigned char) 0xce, (unsigned char) 0xce
    };
    
    unsigned char *salt = (unsigned char *)gSalt;
    int saltLen = strlen(gSalt);
    
    
    EVP_CIPHER_CTX cipherCtx;
    
    
    unsigned char *mResults;         // allocated storage of results
    int mResultsLen = 0;
    
    const char *cPassword = [password UTF8String];
    
    unsigned char *mData = (unsigned char *)[inData bytes];
    int mDataLen = [inData length];
    
    SSLeay_add_all_algorithms();
    X509_ALGOR *algorithm = PKCS5_pbe_set(NID_pbeWithMD5AndDES_CBC, iterations, salt, saltLen);
    
    
    
    
    memset(&cipherCtx, 0, sizeof(cipherCtx));
    
    if (algorithm != NULL)
    {
        EVP_CIPHER_CTX_init(&(cipherCtx));
        
        if (EVP_PBE_CipherInit(algorithm->algorithm, cPassword, strlen(cPassword),
                               algorithm->parameter, &(cipherCtx), direction))
        {
            
            EVP_CIPHER_CTX_set_padding(&cipherCtx, 1);
            
            int blockSize = EVP_CIPHER_CTX_block_size(&cipherCtx);
            int allocLen = mDataLen + blockSize + 1; // plus 1 for null terminator on decrypt
            mResults = (unsigned char *)OPENSSL_malloc(allocLen);
            
            
            unsigned char *in_bytes = mData;
            int inLen = mDataLen;
            unsigned char *out_bytes = mResults;
            int outLen = 0;
            
            
            
            int outLenPart1 = 0;
            if (EVP_CipherUpdate(&(cipherCtx), out_bytes, &outLenPart1, in_bytes, inLen))
            {
                out_bytes += outLenPart1;
                int outLenPart2 = 0;
                if (EVP_CipherFinal(&(cipherCtx), out_bytes, &outLenPart2))
                {
                    outLen += outLenPart1 + outLenPart2;
                    mResults[outLen] = 0;
                    mResultsLen = outLen;
                }
            } else {
                unsigned long err = ERR_get_error();
                ERR_load_crypto_strings();
                ERR_load_ERR_strings();
                char errbuff[256];
                errbuff[0] = 0;
                ERR_error_string_n(err, errbuff, sizeof(errbuff));
                NSLog(@"OpenSLL ERROR:\n\tlib:%s\n\tfunction:%s\n\treason:%s\n",
                      ERR_lib_error_string(err),
                      ERR_func_error_string(err),
                      ERR_reason_error_string(err));
                ERR_free_strings();
            }
            
            
            NSData *encryptedData = [NSData dataWithBytes:mResults length:mResultsLen]; 
            
            
            return encryptedData;
        }
    }
    return nil;
    
}



#pragma mark - decode
+ (NSString *) encodeWithPBE:(NSString *)message {
    
    NSString *password = @"mypassword01";
    
//    NSLog(@"************    PBEWithMD5AndDES encode   **************");
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encodeData = [self encryptPBEWithMD5AndDESData:data password:password iterations:20];
    NSString *encodeedSSString = [encodeData base64String];
    NSLog(@"encodeedSSString:%@",encodeedSSString);
    
    return encodeedSSString;
    
    
}
#pragma mark - encode
+ (NSString *) decodeWithPBE:(NSString *)message {
    
    NSString *password = @"mypassword01";
    
//    NSLog(@"************    PBEWithMD5AndDES decode   **************");
    NSData *decode_base64_data = [NSData dataWithBase64String:message];
    NSData *decData = [self decryptPBEWithMD5AndDESData:decode_base64_data password:password iterations:20];
    NSString *decodedString = [[NSString alloc] initWithData:decData encoding:NSUTF8StringEncoding];
    NSLog(@"decodeString:%@",decodedString);
    
    return decodedString;
}

#pragma mark - test Base64 

- (void) testBase64 {

    //test base64
    NSString *message = @"testPEBWithMd5AndDES";
    NSLog(@"************    GTMBase64   **************");
    NSLog(@"encodeString:%@",[self encodeBase64String:message]);
    NSLog(@"decodeString:%@",[self decodeBase64String:message]);


    NSLog(@"************    Base64   **************");
    NSLog(@"encodeStr:%@",[message base64String]);
    NSLog(@"decodeStr:%@",[NSString stringFromBase64String:[message base64String]]);
    

}

#pragma mark -------- base64加密解密
//base64加密
- (NSString*)encodeBase64String:(NSString* )input {
    
    //    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    data = [GTMBase64 encodeData:data];
    NSString *base64String =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

//base64解密
- (NSString*)decodeBase64String:(NSString* )input {
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    //    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 decodeData:data];
    NSString *base64String = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] ;
    return base64String;
}



#pragma mark - AES加密
//将string转成带密码的data
+(NSString*)encryptAESData:(NSString*)string app_key:(NSString*)key
{
    //将nsstring转化为nsdata
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    //使用密码对nsdata进行加密
    NSData *encryptedData = [data AES128EncryptWithKey:key];
    NSLog(@"加密后的字符串 :%@",[encryptedData base64String]);
    
    return [encryptedData base64String];
}

#pragma mark - AES解密
//将带密码的data转成string
+(NSString*)decryptAESData:(NSData*)data  app_key:(NSString*)key
{
    //使用密码对data进行解密
    NSData *decryData = [data AES128DecryptWithKey:key];
    //将解了密码的nsdata转化为nsstring
    NSString *str = [[NSString alloc] initWithData:decryData encoding:NSUTF8StringEncoding];
    NSLog(@"解密后的字符串 :%@",str);
    return str;
}

#pragma mark - url转码
+ (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)input,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return outputStr;
}


@end

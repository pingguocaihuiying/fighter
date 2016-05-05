//
//  NetWorking.h
//  fighter
//
//  Created by Liyz on 4/13/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorking : NSObject

//获取短信验证码
- (void) getCheckCodeWithPhoneNumber:(NSString *)phonenum option:(void (^)(NSDictionary *dict))option;

//手机号注册用户
- (void) registUserWithPhoneNumber:(NSString *)phoneNum
                          password:(NSString *)password
                         checkCode:(NSString *)checkCode
                            option:(void (^)(NSDictionary *dict))option;


//手机号登录
- (void) loginWithPhoneNumber:(NSString *)phoneNum
                     password:(NSString *)password
                       option:(void (^)(NSDictionary *dict))option;


@end

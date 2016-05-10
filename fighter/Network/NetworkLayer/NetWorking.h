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

//修改用户数据  --post
- (void) updateUserWithValue:(NSString *)value
                         Key:(NSString *)key
                      option:(void (^)(NSDictionary *dict))option;

//修改用户头像
- (void) updateUserHeaderWithLocallUrl:(NSURL *)localUrl
                                   Key:(NSString *)key
                                option:(void (^)(NSDictionary *dict))option;

//修改用户数据  ---get
- (void) updateUserByGet:(NSString *)value
                     Key:(NSString *)key
                  option:(void (^)(NSDictionary *dict))option;

//检查用户是否绑定手机
- (void) isBindingPhoneNum:(void (^)(NSDictionary *dict))option;

//绑定手机号码
- (void) bindingPhoneNumber:(NSString *)phoneNum
                  checkCode:(NSString *)checkcode
                     option:(void (^)(NSDictionary *dict))option;


- (void) updatePassword:(NSString *) oldpass
            newPassword:(NSString *) newPass
                 option:(void (^)(NSDictionary *dict))option;
//用户退出登录
- (void) loginOut:(void (^)(NSDictionary *dict))option ;

//微信登录请求
- (void) weixinRequest;
@end

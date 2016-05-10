//
//  NetWorking.h
//  fighter
//
//  Created by Liyz on 4/13/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorking : NSObject


//get请求
- (void) getRequestWithUrl:(NSString *)urlString
                parameters:(NSDictionary *)dic
                    option:(void (^)(NSDictionary *dict))option;

//post请求
- (void) postRequestWithUrl:(NSString *)urlString
                 parameters:(NSDictionary *)dic
                     option:(void (^)(NSDictionary *dict))option;

//post请求上传二进制数据
- (void) postUploadDataWithURL:(NSString *)urlString
                    parameters:(NSDictionary *)dic
              appendParameters:(NSDictionary *)appendDic
                        option:(void (^)(NSDictionary *dict))option;


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

//请求微信的token和openId
- (void) requestWeixinTokenAdnOpenId:(NSString *)code
                              option:(void (^)(NSDictionary *dict))option;

//获取微信用户信息
- (void) requestWeixinUserInfoWithToken:(NSString *)token
                                 openId:(NSString *)openId
                                 option:(void(^)(NSDictionary *dict)) option;

//向服务器注册微信用户，或者登录微信用户
- (void) requestWeixinUser:(NSDictionary *)wxInfoDic
                    option:(void (^)(NSDictionary *dict))option;

@end

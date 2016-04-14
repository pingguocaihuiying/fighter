//
//  RZNetConfig.h
//  rzzNetwork
//
//  Created by liushuai on 16/3/24.
//  Copyright © 2016年 Liuonion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTNetConfig : NSObject
+ (NSString *)to:(NSString *)path;
+ (NSString *)host:(NSString *)host path:(NSString *)path;
@end

#pragma mark - 拳讯接口
extern NSString * const Domain;

//获取资讯
extern NSString * const GetNewsURL;

#pragma mark - 用户接口
extern NSString * const UserInterfaceHost;

// 1.注册用户获取手机验证码【返回用户id】
extern NSString * const GetPhoneCodeURL;
// 2.注册用户
extern NSString * const RegisterUserURL;
// 3.用户登陆
extern NSString * const UserLoginURL;
// 4.微信用户登录
extern NSString * const UserWXLoginURL;
// 6.更新用户信息
extern NSString * const UpdateUserURL;
// 7.更新用户头像
extern NSString * const UpdateUserHeadPicURL;
// 8.找回密码 发送验证码
extern NSString * const SendSMSFindPwsURL;
// 9.找回密码-发送新密码
extern NSString * const SendSMSNewPwdURL;
// 10.获取支付账户信息
extern NSString * const GetPayAccountInfoURL;
// 11.更新支付账户
extern NSString * const UpdatePayAccountInfoURL;
// 12.发送短信接口 type:支付宝 alipay,微信 wxpay 绑定手机 bindphone
extern NSString * const SendSMSByTypeURL;
// 13.获取群信息
extern NSString * const GetQunListURL;
// 14.获取成就信息
extern NSString * const GetAchievementInfo;
// 15.保存用户信息
extern NSString * const SaveUserAppsURL;
// 18.绑定手机号-用户是否绑定手机
extern NSString * const IsUserBindPhoneURL;

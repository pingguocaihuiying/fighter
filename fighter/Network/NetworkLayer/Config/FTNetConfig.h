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
+ (NSString *)showType;
+ (void)changePreviewVersion;
@end

#pragma mark - 拳讯接口
extern NSString * const Domain;

//获取资讯
extern NSString * const GetNewsURL;
//评论接口
extern NSString *const CommentURL;
//获取（点赞、关注等）状态
extern NSString *const GetStateURL;

//增加点赞接口
extern NSString *const AddVoteURL;
//删除点赞接口
extern NSString *const DeleteVoteURL;
//获取视频接口地址: 域名/api/news/getVideos.do
extern NSString *const GetVideoURL;

//增加观看数的接口: 域名/api/videos/upVideoViewN.do
extern NSString *const AddViewCountURL;

//增加收藏的接口地址: 域名/api/base/save$Base.do
extern NSString *const AddStarURL;
//删除收藏的接口地址:域名/api/ base/ delete$Base.do
extern NSString *const DeleteStarURL;

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
// 19.用户退出登录
extern NSString * const UserLogoutURL;
// 20.绑定手机号
extern NSString * const BindingPhoneURL;
// 21.检查用户是否绑定手机
extern NSString * const ISBindingPhoneURL;
// 22.修改密码
extern NSString * const UpdatePassWordURL;
//23.绑定手机验证码
extern NSString * const BindingPhoneCheckCodeURL;



//获取评论、点赞等状态
extern NSString * const GetStatusCheckKey;

extern NSString * const AddVoteCheckKey;

extern NSString * const DeleteVoteCheckKey;
//增加视频观看数
extern NSString * const UpVideoViewNCheckKey;
//收藏
extern NSString * const AddStarCheckKey;
//取消收藏
extern NSString * const DeleteStarCheckKey;



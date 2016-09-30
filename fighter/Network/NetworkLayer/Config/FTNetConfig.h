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

//增加关注接口
extern NSString *const AddFollowURL;
//删除关注接口    接口地址: 域名
extern NSString *const DeleteFollowURL;

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

//查询类别类型接口地址: 域名/api/category/ findCategoryByName.do
extern NSString *const GetCategoryURL;
//获取格斗场内容list 
extern NSString *const GetArenaListURL;
//格斗场发新帖
extern NSString *const NewPostURL;


//接口地址:    域名/api/qiniu/get$QiNiuToken.do七牛获取token接口地址
extern NSString *const GetQiniuToken;

//接口地址:    获取七牛图片上传token
extern NSString *const GetQiniuVideoToken;




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
// 5.更新用户信息
extern NSString * const UpdateUserURL;
// 6.上传用户身份证照片
extern NSString * const UploadUserIdCardURL;
// 7.更新用户头像
extern NSString * const UpdateUserHeadPicURL;
// 8.找回密码、更换手机 发送验证码
extern NSString * const SendSMSExistURL;
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

//23.验证绑定手机验证码,绑定手机
//extern NSString * const BindingPhoneCheckCodeURL;

//24.获取新手机手机验证码
extern NSString * const SendSMSNewURL;
//25.验证已经绑定手机验证码
extern NSString * const IsValidatePhone;


//排行榜
extern NSString * const GetRankListURL;

extern NSString * const GetRankSearchItemURL;


//获取评论、点赞等状态
extern NSString * const GetStatusCheckKey;

extern NSString * const AddVoteCheckKey;

extern NSString * const DeleteVoteCheckKey;
//增加视频观看数
extern NSString * const UpVideoViewNCheckKey;
//获取观看数

//关注
extern NSString *const FollowCheckKey;
//取消关注
extern NSString *const CancelFollowCheckKey;

extern NSString *const GetObjViewCountURL;
//xx数
extern NSString *const GetObjVoteCountURL;
//增加格斗场帖子阅读数
extern NSString *const AddArenaViewCountCountURL;
//获取个人主页用户信息
extern NSString *const GetHomepageUserInfo;


//收藏
extern NSString * const AddStarCheckKey;
//取消收藏
extern NSString * const DeleteStarCheckKey;
//发新帖 gedoujia1gdshjjgfkd52261225550
extern NSString * const NewPostCheckKey;

//增加关注
extern NSString * const AddFollowCheckKey;
//取消关注
extern NSString * const CancelFollowCheckKey;

//获取评论
extern NSString * const GetCommentsURL;

//获取拳手赛事信息
extern NSString * const GetBoxerRaceInfoURL;

// 获取单个拳讯信息
extern NSString * const GetNewsByIdURL;

// 获取单个视频信息
extern NSString * const GetVideoByIdURL;



#pragma mark - 学拳
// coach 教练
extern NSString * const GetCoachListURL;
extern NSString * const GetCoachByIdURL;
extern NSString * const ValidCheckCode ;

// gym 拳馆
extern NSString * const GetGymListURL;
extern NSString * const GetGymListForArenaURL;
extern NSString * const GetGymByIdURL;
extern NSString * const GetGymPhotosByUsers;//获取用户拍摄的拳馆照片
extern NSString * const BecomeGymMenberShipURL;

#pragma mark - 新格斗场
extern NSString *const SaveCourseBookCheckSign;//约课
extern NSString *const DeleteCourseBookCheckSign;//取消约课
//获取拳馆vip信息
extern NSString *const GetGymVIPInfoURL;
//约课
extern NSString * const OrderCourseURL;//
//取消约课
extern NSString * const DeleteOrderCourseURL;
//获取拳馆固定的时间段
extern NSString * const GetGymTimeSlotsByIdURL;
//获取拳馆的场地信息
extern NSString * const GetGymPlacesByIdURL;
//获取拳馆的场地使用信息
extern NSString * const GetGymPlacesUsingInfoByIdURL;
//获取拳馆的课程占用信息
extern NSString * const GetGymSourceInfoByIdURL;
//获取拳馆的基本信息
extern NSString * const GetGymInfoByIdURL;
//获取拳手列表
extern NSString *const GetBoxerListURL;///api/boxer/list.do
//添加赛事
extern NSString *const AddMatchURL;//api/match/save$Match.do
//查询赛事列表
extern NSString *const GetMatchListURL;
//迎战or拒战
extern NSString *const ResponseToMatchURL;
//微信支付
extern NSString *const WXPayURL;
//微信支付结果查询
extern NSString *const GetWXPayStatus;
//拳馆详细信息
extern NSString *const GetGymDetailURL;

//关注
extern NSString *const FollowURL;
//取消关注
extern NSString *const CancelFollowURL;

#pragma mark - 充值、购买、积分
// 查询余额接口
extern NSString * const QueryMoneyURL;
// 推广任务接口
extern NSString * const ExtensionTaskURL;
// 是否已经购买视频查询接口
extern NSString * const IsBuyVideoDoneURL;
// 购买视频接口
extern NSString * const BuyVideoURL;
// 获取视频URL接口
extern NSString * const GetBuyVideoURL ;
// app内购验证付款接口
extern NSString * const CheckIAPURL;
// app内购预下单接口
extern NSString * const RechargeIAPURL;

#pragma mark -  兑吧

// 获取兑吧功能配置
extern NSString * const DuiBaConfigURL;

// 请求兑吧地址
extern NSString * const DuiBaURL;

// 兑吧扣除积分接口
extern NSString * const DuiBaChargeURL ;

// 兑吧确定扣除积分接口
extern NSString * const DuiBaCheckCharegeURL ;

// 商城首页
extern NSString * const ShopURL;
// 订单页
extern NSString * const ShopOrderURL;


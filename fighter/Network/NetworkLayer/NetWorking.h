//
//  NetWorking.h
//  fighter
//
//  Created by Liyz on 4/13/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorking : NSObject

#pragma mark - 封装请求  成员方法
/*****************************      封装请求      ********************************/

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

#pragma mark - 封装请求  类方法
//post请求
+ (void) postRequestWithUrl:(NSString *)urlString
                 parameters:(NSDictionary *)dic
                     option:(void (^)(NSDictionary *dict))option;



//post  请求上传二进制数据
+ (void) postUploadDataWithURL:(NSString *)urlString
                    parameters:(NSDictionary *)dic
              appendParameters:(NSDictionary *)appendDic
                        option:(void (^)(NSDictionary *dict))option;

//get请求
+ (void) getRequestWithUrl:(NSString *)urlString
                parameters:(NSDictionary *)dic
                    option:(void (^)(NSDictionary *dict))option;



#pragma mark - 获取短信验证码
/*****************************    获取短信验证码   ********************************/

//获取短信验证码
- (void) getCheckCodeWithPhoneNumber:(NSString *)phonenum
                              option:(void (^)(NSDictionary *dict))option;


//绑定手机时获取验证码
- (void) getCheckCodeForNewBindingPhone:(NSString *)phoneNum
                                 option:(void (^)(NSDictionary *dict))option;

//更换手机时获取旧手机号验证码
- (void) getCheckCodeForExistPhone:(NSString *)phoneNum
                                type:(NSString *)type
                              option:(void (^)(NSDictionary *dict))option;

//更换手机时获取新手机号验证码
- (void) getCheckCodeForNewPhone:(NSString *)phoneNum
                            type:(NSString *)type
                          option:(void (^)(NSDictionary *dict))option;

#pragma mark - 注册登录
/*****************************    注册登录   ***********************************/
//手机号注册用户
- (void) registUserWithPhoneNumber:(NSString *)phoneNum
                          password:(NSString *)password
                         checkCode:(NSString *)checkCode
                            option:(void (^)(NSDictionary *dict))option;


//手机号登录
- (void) loginWithPhoneNumber:(NSString *)phoneNum
                     password:(NSString *)password
                       option:(void (^)(NSDictionary *dict))option;


//用户退出登录
- (void) loginOut:(void (^)(NSDictionary *dict))option ;


#pragma mark -  更新用户
/*****************************    更新用户   *********************************/

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



#pragma mark -  微信
/*****************************    微信   ******************************/
//绑定微信号
- (void) bindingWeixin:(NSString *)openId
//                  checkCode:(NSString *)checkcode
                     option:(void (^)(NSDictionary *dict))option;


- (void) updatePassword:(NSString *) oldpass
            newPassword:(NSString *) newPass
                 option:(void (^)(NSDictionary *dict))option;


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

#pragma mark -  binding phone
/***************************     binding phone    ********************************/

//绑定手机号码
- (void) bindingPhoneNumber:(NSString *)phoneNum
                  checkCode:(NSString *)checkcode
                     option:(void (^)(NSDictionary *dict))option;
//验证旧手机验证码
- (void) checkCodeForExistPhone:(NSString *)phoneNum
                    checkCode:(NSString *)checkcode
                       option:(void (^)(NSDictionary *dict))option;

//修改绑定手机
- (void) changgeBindingPhone:(NSString *)phoneNum
                   checkCode:(NSString *)checkcode
                      option:(void (^)(NSDictionary *dict))option;



#pragma mark - 排行榜
/***************************     排行榜     ***********************************/
//获取排行榜列表信息
- (void) getRankListWithLabel:(NSString *)label
                         race:(NSString *)race
                FeatherWeight:(NSString *)featherWeight
                      pageNum:(NSInteger)pagenum
                       option:(void (^)(NSDictionary *dict))option;

//获取排行榜标签
- (void) getRankLabels:(void (^)(NSDictionary *dict))option;

#pragma mark - 视频
//获取排行榜标签
- (void) getVideos:(NSString *) urlString  option:(void (^)(NSDictionary *dict))option;

//获取个人主页用户资料
+ (void)getHomepageUserInfoWithUserOldid:(NSString *)userOldid andBoxerId:(NSString *)boxerId andCoachId:(NSString *)coachId andCallbackOption:(void (^)(FTUserBean *userBean))userBeanOption;

//获取评论
+ (void)getCommentsWithObjId:(NSString *)objId andTableName:(NSString *)tableName andOption:(void (^) (NSArray *array))option;

//获取拳手赛事信息
+ (void)getBoxerRaceInfoWithBoxerId:(NSString *)boxerId andOption:(void (^)(NSArray *array))option;

//获取单个拳讯信息
+ (void)getNewsById:(NSString *)newsId andOption:(void (^)(NSArray *array))option;

//获取单个视频信息
+ (void)getVideoById:(NSString *)videoId andOption:(void (^)(NSArray *array))option;


#pragma mark - 学拳
// Get Coach List
+ (void) getCoachsByDic:(NSDictionary *)dic option:(void (^)(NSDictionary *dict))option;

// Get Gym List
+ (void) getGymsByDic:(NSDictionary *)dic option:(void (^)(NSDictionary *dict))option;

#pragma mark - 新格斗场
//获取拳馆固定的时间段
+ (void)getGymTimeSlotsById:(NSString *) gymId andOption:(void (^)(NSArray *array))option;

//获取场地配置
+ (void)getGymPlaceInfoById:(NSString *)gymId andOption:(void (^)(NSArray *array))option;

//获取场地的使用信息
+ (void)getGymPlaceUsingInfoById:(NSString *)gymId andTimestamp:(NSString *)timestamp andOption:(void (^)(NSArray *array))option;

//获取拳馆信息
+ (void)getGymInfoById:(NSString *)gymId andOption:(void (^)(NSDictionary *dic))option;

//获取拳手信息
+ (void)getBoxerListByWeight:(NSString *)weight andOverWeightLevel: (NSString *) overWeightLevel andOption:(void (^)(NSArray *array))option;


#pragma mark - 充值购买
// 查询余额
+ (void) queryMoneyWithOption:(void (^)(NSDictionary *dict))option;

// 分享后回调添加积分
+ (void) getPointByShareWithPlatform:(NSString *)platform option:(void (^)(NSDictionary *dict))option;

// 是否已经购买视频接口
+ (void) checkBuyVideoById:(NSString *)videoId option:(void (^)(NSDictionary *dict))option;

// 购买视频接口
+ (void) buyVideoById:(NSString *)videoId option:(void (^)(NSDictionary *dict))option;

// 获取视频Url接口
+ (void) getVideoUrlById:(NSString *)videoId buyToken:(NSString *)buyToken option:(void(^)(NSDictionary *dict))option;

// app内购预支付接口
+ (void) rechargeIAPByGoods:(FTGoodsBean *)goodsBean  option:(void(^)(NSDictionary *dict))option;

// 验证app内购接口
+ (void) checkIAPByOrderNO:(NSString *)orderNO receipt:(NSString *) receipt transactionId:(NSString*)transactionId option:(void(^)(NSDictionary *dict))option;

#pragma mark - 获取标签
// 获取教学视频标签
+ (void) getTeachLabelsWithOption:(void(^)(NSDictionary *dict))option;

@end

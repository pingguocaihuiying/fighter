//
//  NetWorking.h
//  fighter
//
//  Created by Liyz on 4/13/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTMatchDetailBean.h"
#import "FTMatchBean.h"
#import "FTModuleBean.h"
#import "FTGymBean.h"

@interface NetWorking : NSObject

#pragma mark - 封装请求  成员方法
/*****************************      封装请求      ********************************/

////get请求
//+ (void) getRequestWithUrl:(NSString *)urlString
//                parameters:(NSDictionary *)dic
//                    option:(void (^)(NSDictionary *dict))option;
//
////post请求
//+ (void) postRequestWithUrl:(NSString *)urlString
//                 parameters:(NSDictionary *)dic
//                     option:(void (^)(NSDictionary *dict))option;
//
//
////post请求上传二进制数据
//+ (void) postUploadDataWithURL:(NSString *)urlString
//                    parameters:(NSDictionary *)dic
//              appendParameters:(NSDictionary *)appendDic
//                        option:(void (^)(NSDictionary *dict))option;

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
+ (void) getCheckCodeWithPhoneNumber:(NSString *)phonenum
                              option:(void (^)(NSDictionary *dict))option;


//绑定手机时获取验证码
+ (void) getCheckCodeForNewBindingPhone:(NSString *)phoneNum
                                 option:(void (^)(NSDictionary *dict))option;
//绑定手机时获取验证码(可以修改type类型的)
+ (void) getCheckCodeForNewBindingPhone:(NSString *)phoneNum withType:(NSString *)type
                                 option:(void (^)(NSDictionary *dict))option;
//更换手机时获取旧手机号验证码
+ (void) getCheckCodeForExistPhone:(NSString *)phoneNum
                                type:(NSString *)type
                              option:(void (^)(NSDictionary *dict))option;

//更换手机时获取新手机号验证码
+ (void) getCheckCodeForNewPhone:(NSString *)phoneNum
                            type:(NSString *)type
                          option:(void (^)(NSDictionary *dict))option;

#pragma mark - 注册登录
/*****************************    注册登录   ***********************************/
//手机号注册用户
+ (void) registUserWithPhoneNumber:(NSString *)phoneNum
                          password:(NSString *)password
                         checkCode:(NSString *)checkCode
                            option:(void (^)(NSDictionary *dict))option;


//手机号登录
+ (void) loginWithPhoneNumber:(NSString *)phoneNum
                     password:(NSString *)password
                       option:(void (^)(NSDictionary *dict))option;


//用户退出登录
+ (void) loginOut:(void (^)(NSDictionary *dict))option ;


#pragma mark -  更新用户
/*****************************    更新用户   *********************************/

//修改用户数据  --post
+ (void) updateUserWithValue:(NSString *)value
                         Key:(NSString *)key
                      option:(void (^)(NSDictionary *dict))option;

//修改用户头像
+ (void) updateUserHeaderWithLocallUrl:(NSURL *)localUrl
                                   Key:(NSString *)key
                                option:(void (^)(NSDictionary *dict))option;

// 上传用户身份证照片
+ (void) uploadUserIdcard:(NSURL *)localUrl
                      Key:(NSString *)key  option:(void (^)(NSDictionary *dict))option;

//修改用户数据  ---get
+ (void) updateUserByGet:(NSString *)value
                     Key:(NSString *)key
                  option:(void (^)(NSDictionary *dict))option;

//检查用户是否绑定手机
+ (void) isBindingPhoneNum:(void (^)(NSDictionary *dict))option;



#pragma mark -  微信
/*****************************    微信   ******************************/
//绑定微信号
+ (void) bindingWeixin:(NSString *)openId
//                  checkCode:(NSString *)checkcode
                     option:(void (^)(NSDictionary *dict))option;


+ (void) updatePassword:(NSString *) oldpass
            newPassword:(NSString *) newPass
                 option:(void (^)(NSDictionary *dict))option;


//微信登录请求
+ (void) weixinRequest;

//请求微信的token和openId
+ (void) requestWeixinTokenAdnOpenId:(NSString *)code
                              option:(void (^)(NSDictionary *dict))option;

//获取微信用户信息
+ (void) requestWeixinUserInfoWithToken:(NSString *)token
                                 openId:(NSString *)openId
                                 option:(void(^)(NSDictionary *dict)) option;

//向服务器注册微信用户，或者登录微信用户
+ (void) requestWeixinUser:(NSDictionary *)wxInfoDic
                    option:(void (^)(NSDictionary *dict))option;

#pragma mark -  binding phone
/***************************     binding phone    ********************************/

//绑定手机号码
+ (void) bindingPhoneNumber:(NSString *)phoneNum
                  checkCode:(NSString *)checkcode
                     option:(void (^)(NSDictionary *dict))option;
//验证旧手机验证码
+ (void) checkCodeForExistPhone:(NSString *)phoneNum
                    checkCode:(NSString *)checkcode
                       option:(void (^)(NSDictionary *dict))option;

//修改绑定手机
+ (void) changgeBindingPhone:(NSString *)phoneNum
                   checkCode:(NSString *)checkcode
                      option:(void (^)(NSDictionary *dict))option;



#pragma mark - 排行榜
/***************************     排行榜     ***********************************/
//获取排行榜列表信息
+ (void) getRankListWithLabel:(NSString *)label
                         race:(NSString *)race
                FeatherWeight:(NSString *)featherWeight
                      pageNum:(NSInteger)pagenum
                       option:(void (^)(NSDictionary *dict))option;

//获取排行榜标签
+ (void) getRankLabels:(void (^)(NSDictionary *dict))option;

#pragma mark - 个人主页
//获取排行榜标签
+ (void) getVideos:(NSString *) urlString  option:(void (^)(NSDictionary *dict))option;

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

/**
 评价教练
 */
+ (void) commentCoachByParamDic:(NSDictionary *) params option:(void (^)(NSDictionary *dict))option;

/**
 查看教练是否已经被评价
 */
+ (void) checkIsCommentCoachByCoachUserId:(NSString *) coachUserId  courseOnceId:(NSString *) courseOnceId option:(void (^)(NSDictionary *dict))option ;

#pragma mark - 学拳
// Get Coach List
+ (void) getCoachsByDic:(NSDictionary *)dic option:(void (^)(NSDictionary *dict))option;

// get coach detail by id
+ (void) getCoachById:(NSString *)coachId option:(void (^)(NSDictionary *dict))block;

// Get Gym List
+ (void) getGymsByDic:(NSDictionary *)dic option:(void (^)(NSDictionary *dict))option;

// Get Member Gym List
+ (void) getMemberGymsByDic:(NSDictionary *)dic option:(void (^)(NSDictionary *dict))option;

// Get Gym Comment List
+ (void) getGymComments:(NSString *)objectId option:(void (^)(NSDictionary *dict))option;

// Add Gym Comment
+ (void) addGymCommentWithPramDic:(NSDictionary*)pramDic option:(void (^)(NSDictionary *dict))option;

// Get Comment for gym Comment List 获取拳馆二级评论
+ (void) getGymReplyComments:(NSString *)objectId option:(void (^)(NSDictionary *dict))option;

// 添加拳馆二级评论
+ (void) addCommentForGymComment:(NSDictionary*)pramDic option:(void (^)(NSDictionary *dict))option;

//验证验证码是否正确（请求加入会员部分）
+ (void)validCheckCodeWithPhoneNum:(NSString *) phoneNum andCheckCode:(NSString *)checkCode andOption:(void (^)(NSDictionary *dic))option;

//请求加入会员
+ (void)requestToBeVIPWithCorporationid:(NSString *)corporationid andPhoneNum:(NSString *) phoneNum andCheckCode:(NSString *)checkCode andOption:(void (^)(NSDictionary *dic))option;

//获取教练的星级
+ (void)getCoachRatingByID:(NSString *)coachId withBlock:(void (^) (NSDictionary *dic)) block;
//获取教练的照片
+ (void)getCoachPhotosByID:(NSString *)coachId andGymId:(NSString *) gymId withBlock:(void (^) (NSDictionary *dic)) block;
//获取学员对教练的评论
+ (void)getCoachCommentsByUserPhotosByID:(NSString *)coachId andPageNum:(NSString *) pageNum withBlock:(void (^) (NSDictionary *dic)) block;
/**
 查看教练授课记录
 
 @param corporationid 拳馆id
 @param option  +记录json字典
 */
+ (void) getCoachTeachRecordWithCorporationid:(NSString*)corporationid andCourseType:(NSString *)courseType option:(void (^)(NSDictionary *dict))option;



#pragma mark - 训练
/**
 查看教练授课记录
 
 @param corporationid 拳馆id
 @param option  授课记录json字典
 @param courseType  课程类型，0：团课 2:私教
 */
+ (void) getTraineeListWith:(NSDictionary *)dict  option:(void (^)(NSDictionary *dict))option;


/**
 获取教练评论的内容，以及技能点信息

 @param version 课程版本
 @param option block
 */
+ (void)getCourseCommentWithVersion:(NSString *)version andOption:(void (^)(NSDictionary *dic)) option;

/**
 获取学员上课的历史记录

 @param option 返回的json字典
 */
+ (void)getUserCourseHistoryWithOption:(void (^)(NSDictionary *dic)) option;


/**
 根据评论的版本号获取教练对用户的评分（及评论）
 
 @param version 评论版本
 @param option block
 */
+ (void)getUserSkillsByVersion:(NSString *)version andOption:(void (^)(NSDictionary *dic)) option;


/**
 个人主页 或 教练给学员评分 用到的
 获取用户技能属性的接口

 @param corporationid 拳馆id
 @param memberUserId 要获取的用户的id（oldUserId)
 @param version 选填：技能版本
 @param parent 选填：技能的parentid
 @param option block
 */

+ (void)getUserSkillsWithCorporationid:(NSString *)corporationid andMemberUserId:(NSString *)memberUserId andVersion:(NSString *)version andParent:(NSString *)parent andOption:(void (^)(NSDictionary *dic)) option;


/**
 获取拳馆评分项子项最大数目限制
 
 @param corporationId 拳馆id
 @param option        返参数block
 */
+ (void) getShouldEditSkillNumber:(NSString *)corporationId option:(void (^)(NSDictionary *dic)) option;


/**
 上课评分
 
 @param paramDic 评分参数
 @param option   返参数block
 */
+ (void) saveSkillVersion:(NSDictionary *)paramDic option:(void (^)(NSDictionary *dic)) option;

#pragma mark - 约课
//约课
+ (void)orderCourseWithParamsDic:(NSMutableDictionary *)dic andOption:(void (^)(NSDictionary *dic))option;

#pragma mark - 教练更改可约不可约状态
/**
 教练更改可约不可约状态
 
 @param dic    入参
 @param option block回掉
 */
+ (void)changeCourseStatusWithParamsDic:(NSMutableDictionary *)dic andOption:(void (^)(NSDictionary *dic))option;

#pragma mark - 新格斗场
//获取拳馆固定的时间段
// Get Gym List for arena
+ (void) getGymsForArenaByDic:(NSDictionary *)dic option:(void (^)(NSDictionary *dict))option;

+ (void)getGymTimeSlotsById:(NSString *) gymId andOption:(void (^)(NSArray *array))option;

//获取场地配置
+ (void)getGymPlaceInfoById:(NSString *)gymId andOption:(void (^)(NSArray *array))option;

//获取场地的使用信息
+ (void)getGymPlaceUsingInfoById:(NSString *)gymId andTimestamp:(NSString *)timestamp andOption:(void (^)(NSArray *array))option;
//获取拳馆课程预约信息
+ (void)getGymSourceInfoById:(NSString *)gymId andTimestamp:(NSString *)timestamp andOption:(void (^)(NSArray *array))option;
//获取教练课程信息
+ (void)getCoachCourceInfoByCoachId:(NSString *)coachId andGymId:(NSString *)gymId andOption:(void (^)(NSArray *array))option;
//获取拳馆信息(比赛模块)
+ (void)getGymInfoById:(NSString *)gymId andOption:(void (^)(NSDictionary *dic))option;

//获取拳馆详细信息（学拳模块的拳馆 ）
+ (void)getGymForGymDetailWithGymBean:(FTGymBean *)gymBean andOption:(void (^)(NSDictionary *dic))option;

//根据拳馆id获取拳馆的所有教练(拳馆模块)
+ (void)getCoachesWithCorporationid:(NSString *)corporationid andOption:(void (^)(NSArray *array))option;
//根据拳馆id获取拳馆的所有照片（用户上传的）
+ (void)getPhotosByUsersWithCorporationid:(NSString *)corporationid andOption:(void (^)(NSArray *array))option;

//获取拳手信息
+ (void)getBoxerListByWeight:(NSString *)weight andOverWeightLevel: (NSString *) overWeightLevel andPageSize:(NSString *)pageSize andPageNum:(int)pageNum  andOption:(void (^)(NSArray *array))option;

//添加赛事
+ (void)addMatchWithParams:(NSDictionary *)dic andOption:(void (^)(BOOL result))option;

//获取比赛列表
+ (void)getMatchListWithPageNum:(int)pageNum andPageSize:(NSString *)pageSize andStatus:(NSString *)status andPayStatus:(NSString *)payStatus andLabel:(NSString *)label andAgainstId:(NSString *)againstId andWeight:(NSString *)weight andUserId:(NSString *)userId andOption:(void(^) (NSArray *array))option;

//迎战、拒绝比赛
+ (void)responseToMatchWithParamDic:(NSDictionary *)dic andOption:(void (^)(BOOL result))option;
//获取拳馆详细信息
+ (void)getGymDetailWithGymId:(NSString *)gymId andOption:(void (^)(NSArray *array))option;
//格斗场 - 微信支付（下注）
+ (void)WXpayWithParamDic:(NSDictionary *)dic andOption:(void (^)(NSDictionary *dic))option;
/**
 *  增加观看数
 *
 *  @param objId     objId
 *  @param tableName 表名（根据不同类型的对象有不同的表名）
 *  @param option    bool
 */
+ (void)addViewCountWithObjid:(NSString *)objId andTableName:(NSString *)tableName andOption:(void (^)(BOOL result))option;
/**
 *  获取观看数
 *
 *  @param objId     objId
 *  @param tableName tableName 表名（根据不同类型的对象有不同的表名）
 *  @param option    观看数
 */
+ (void)getViewCountWithObjid:(NSString *)objId andTableName:(NSString *)tableName andOption:(void (^)(NSString *viewCount))option;
//点赞
+ (void)addVoteWithObjid:(NSString *)objId isAdd:(BOOL)isAdd andTableName:(NSString *)tableName andOption:(void (^)(BOOL result))option;
//获取点赞状态
+ (void)getVoteStatusWithObjid:(NSString *)objId andTableName:(NSString *)tableName andOption:(void (^)(BOOL result))option;
//获取点赞数
+ (void)getCountWithObjid:(NSString *)objId andTableName:(NSString *)tableName andOption:(void (^)(NSString *viewCount))option;
//下注
+ (void)betWithMatchBean:(FTMatchBean *)_matchBean andIsPlayer1Win:(BOOL )isPlayer1Win andBetValue:(int )betValue andOption:(void (^)(BOOL result))option;
//关注、取消关注
+ (void)followObjWithObjId:(NSString *)objId anIsFollow:(BOOL)isFollow andTableName:(NSString *)tableName  andOption:(void (^)(BOOL result))option;

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


#pragma mark - 微信支付
// 微信支付
+ (void)wxPayWithParamDic:(NSDictionary *)dic andOption:(void (^)(NSDictionary *dic))option ;
// 微信支付结果查询
+ (void)wxPayStatusWithOrderNO:(NSString *)orederNO andOption:(void (^)(NSDictionary *dic))option ;


#pragma mark - 获取标签
// 获取教学视频标签
+ (void) getTeachLabelsWithOption:(void(^)(NSDictionary *dict))option;

#pragma mark - 兑吧

//  获取兑吧地址
+(void) getDuibaUrl:(void (^)(NSDictionary *dict))option;

//  获取兑吧地址
+ (void) GetDuiBaConfig:(void (^)(NSDictionary *dict))option;

//查询当前用户是否是指定拳馆的会员
+ (void)getVIPInfoWithGymId:(NSString *) corporationID andOption:(void (^)(NSDictionary *dic))option;

#pragma mark - 拳吧
/**
 获取模块信息
 
 @param option 回调的字典
 */
+ (void)getBoxingBarSectionsWithOption:(void (^)(NSDictionary *dic)) option;


/**
 关注、取消关注版块

 @param moduleBean 版块bean
 @param option 回调block
 @param isFollow 关注（yes）、取消（no）
 */
+ (void)changeModuleFollowStatusWithModuleBean:(FTModuleBean *)moduleBean andBlock:(void (^)(NSDictionary *dic))block andIsFollow:(BOOL) isFollow  andFollowId:(NSString *)followId;

/**
 用户是否关注版块

 @param moduleBean 版块
 @param block block
 */
+ (void)userWhetherFollowModule:(FTModuleBean *)moduleBean withBlock:(void (^)(NSDictionary *dic)) block;
@end

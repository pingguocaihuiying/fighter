//
//  RZNetConfig.m
//  rzzNetwork
//
//  Created by liushuai on 16/3/24.
//  Copyright © 2016年 Liuonion. All rights reserved.
//

#import "FTNetConfig.h"

@implementation FTNetConfig
+ (NSString *)to:(NSString *)path
{
    return [NSString stringWithFormat:@"%@%@",@"",path];
}
+(NSString *)host:(NSString *)host path:(NSString *)path
{
    return [NSString stringWithFormat:@"%@%@",host,path];
}

+ (NSString *)showType{
    
    NSString *showType = [[NSUserDefaults standardUserDefaults]objectForKey:SHOWTYPE];
    if ([showType isEqualToString:@"1"]) {
        showType = @"1";
    }else{
        showType = @"0";
    }
    return showType;
}


+ (void)changePreviewVersion{
    
    NSString *showType = [FTNetConfig showType];
    if ([showType isEqualToString:@"0"]) {
        showType = @"1";
    }else if ([showType isEqualToString:@"1"]){
        showType = @"0";
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:showType forKey:SHOWTYPE];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSLog(@"已切换版本，当前showType:%@", [FTNetConfig showType]);
}

/** 可用的后台地址 **/
//NSString * const Domain = @"http://www.gogogofight.com/pugilist_admin";//生产环境
NSString * const Domain = @"http://www.gogogofight.com/pugilist_admin_test";//测试环境
//NSString * const Domain = @"http://192.168.85.45/pugilist_admin";//内网测试环境

//NSString * const Domain = @"http://10.11.1.117/pugilist_admin";//何后台开发环境
//NSString * const Domain = @"http://10.11.1.49/pugilist_admin";//余彧后台开发环境
//获取新闻192.168.85.45
NSString * const GetNewsURL = @"/api/news/getNews.do";

//评论接口地址: 
NSString * const CommentURL = @"/api/comment/add$UserComment.do";

//获取（点赞、关注等）的状态
NSString *const GetStateURL = @"/api/status/get$Status.do";

//增加点赞接口
NSString *const AddVoteURL = @"/api/comment/add$Vote.do";
//删除点赞接口
NSString *const DeleteVoteURL = @"/api/comment/delete$Vote.do";

//增加关注接口
NSString *const AddFollowURL = @"/api/follow/add$Follow.do";
//删除关注接口    接口地址: 域名
NSString *const DeleteFollowURL = @"/api/follow/delete$Follow.do";

//获取视频接口地址: 域名/api/news/getVideos.do
NSString *const GetVideoURL = @"/api/videos/getVideos.do";
//观看数
NSString *const GetObjViewCountURL = @"/api/view/countView.do";
//统计评论数
NSString *const GetObjCommentCountURL = @"/api/ comment/ countComment.do";
//统计点赞数
NSString *const GetObjVoteCountURL = @"/api/comment/countVote.do";

//增加视频观看数接口 域名/api/videos/upVideoViewN.do
NSString *const AddViewCountURL = @"/api/view/addView.do";

//增加格斗场帖子阅读数
NSString *const AddArenaViewCountCountURL = @"/api/view/addView.do";

//增加收藏的接口地址: 域名/api/base/save$Base.do
NSString *const AddStarURL = @"/api/base/save$Base.do";

//关注
NSString *const FollowURL = @"/api/follow/add$Follow.do";
//取消关注
NSString *const CancelFollowURL = @"/api/follow/delete$Follow.do";

//删除收藏的接口地址:域名/api/base/delete$Base.do
NSString *const DeleteStarURL = @"/api/base/delete$Base.do";

//获取类别接口地址: 域名/api/category/ findCategoryByName.do
NSString *const GetCategoryURL = @"/api/category/findCategoryByName.do";

//获取格斗场内容list
NSString *const GetArenaListURL = @"/api/damblog/list.do";
//NSString *const GetArenaListURL = @"/api/base/listBase.do";
//http://www.gogogofight.com/pugilist_admin/api/base/listBase.do?tableName=damageblog&query=list-dam-blog-1

//格斗场发新帖//接口地址: 域名/api/base/save$Base.do
NSString *const NewPostURL = @"/api/base/save$Base.do";

//接口地址:    获取七牛图片上传token
NSString *const GetQiniuToken = @"/api/qiniu/get$QiNiuToken.do";
//接口地址:    获取七牛图片上传token        
NSString *const GetQiniuVideoToken = @"/api/qiniu/get$QiNiuVideoToken.do";

//关注
NSString *const FollowCheckKey = @"gedoujia11fdsafsag21254";
//取消关注
NSString *const CancelFollowCheckKey = @"gedoujia11fgfdghdfrdsafsag21254";

//NSString * const UserInterfaceHost = @"http://121.42.44.216/integral_adminTest";
NSString * const UserInterfaceHost = @"http://192.168.85.45/integral_adminTest";  //测试注册用，不能用于微信登录、微信支付

//
NSString * const GetPhoneCodeURL = @"/api/newuser/getPhoneCode.do";

NSString * const RegisterUserURL = @"/api/newuser/registerUser.do";

NSString * const UserLoginURL = @"/api/newuser/userLogin.do";

NSString * const UserLogoutURL = @"/api/newuser/userLogout.do";

NSString * const UserWXLoginURL = @"/api/newuser/userWXLogin.do";

#pragma mark  - 更新用户
NSString * const UpdateUserURL = @"/api/newuser/updateUser.do";
//NSString * const UpdateUserURL = @"/api/newuser/updateUser2.do";

NSString * const UploadUserIdCardURL = @"/api/newuser/updateUserCardpic.do";

NSString * const UpdateUserHeadPicURL = @"/api/newuser/updateUserHeadpic.do";

#pragma mark  - 发送验证码

NSString * const SendSMSExistURL = @"/api/newuser/sendSMS_Old.do";//给已绑定的手机发送验证码

NSString * const SendSMSNewPwdURL = @"/api/newuser/findpassword.do";

NSString * const GetPayAccountInfoURL = @"/api/newuser/getPayAccountInfo.do";

NSString * const UpdatePayAccountInfoURL = @"/api/newuser/updatePayAccountInfo.do";

NSString * const SendSMSByTypeURL = @"/api/newuser/sendSMS.do";

NSString * const GetQunListURL = @"/api/newuser/getQunList.do";

NSString * const GetAchievementInfo = @"/api/newuser/getAchievementInfo.do";

NSString * const SaveUserAppsURL = @"/api/newuser/saveUserApps.do";

NSString * const IsUserBindPhoneURL = @"/api/newuser/isUserBindPhone.do";

NSString * const BindingPhoneURL = @"/api/app/binding.do";

NSString * const ISBindingPhoneURL = @"/api/newuser/isUserBindPhone.do";

NSString * const UpdatePassWordURL = @"/api/newuser/updatePassword.do";

//NSString * const BindingPhoneCheckCodeURL = @"/api/newuser/updatePassword.do";

NSString * const SendSMSNewURL = @"/api/newuser/sendSMS_New.do";

NSString * const IsValidatePhone =  @"/api/newuser/validatePhone.do";



//排行榜
NSString * const GetRankListURL = @"/api/ranking/list.do";//排行榜
NSString * const GetRankSearchItemURL = @"/api/ranking/getRankSearchItems.do";//排行帅选项
NSString * const GetHomepageUserInfo = @"/api/user/read.do";
NSString *const GetUserSkillsByVersion = @"/api/skillversions/getUserSkillVersions.do";

//获取评论
NSString * const GetCommentsURL =  @"/api/comment/listComment.do";

//获取拳手赛事信息  
NSString * const GetBoxerRaceInfoURL =  @"/api/boxer/getBoxerRaceDynamic.do";

// 获取单个拳讯信息
NSString * const GetNewsByIdURL =  @"/api/news/getNewsById.do";

// 获取单个视频信息
NSString * const GetVideoByIdURL =  @"/api/videos/getVideosById.do";

//校验码
NSString * const GetStatusCheckKey =  @"gedoujia25fdsgfd55fdsafsag21254";
    //增加投票
 NSString * const AddVoteCheckKey =    @"gedoujia1255525522255521254";
    //删除投票
 NSString * const DeleteVoteCheckKey = @"gedoujia125ggrfdsgfd5521254";

//增加关注
NSString * const AddFollowCheckKey =    @"gedoujia11fdsafsag21254";

//增加视频观看数
NSString * const UpVideoViewNCheckKey =  @"quanjijia222222";
    //收藏
NSString * const AddStarCheckKey =  @"gedoujia1gdshjjgfkd52261225550";
    //取消收藏
NSString * const DeleteStarCheckKey =  @"gedoujia1ggghfdjskfgl1250";

//发新帖 gedoujia1gdshjjgfkd52261225550
NSString * const NewPostCheckKey =  @"gedoujia1gdshjjgfkd52261225550";

#pragma mark - 学拳

NSString *const GetUserCourseHistoryURL = @"/api/skillversions/getUserCourseRecord.do";
NSString *const GetUserSkillsURL = @"/api/gradedetail/get$Versions.do";
NSString *const GetUserSkillsCheckSign = @"gedoujihtgfsyh543";
// coach
NSString * const GetCoachListURL = @"/api/coach/list.do";
NSString * const GetCoachByIdURL = @"/api/coach/{id}.do";
NSString * const ValidCheckCode = @"/api/user/save$checkPhoneCode.do";

// gym 拳馆
NSString * const GetGymListURL = @"/api/gym/getGym.do";
NSString * const GetMemberGymURL = @"/api/gym/getGymByMember.do"; // 获取会员拳馆
NSString * const GetGymListForArenaURL = @"/api/match/getGyms.do";
NSString * const GetGymByIdURL = @"/api/gym/getVideosById.do";
NSString * const GetGymPhotosByUsers = @"/api/gym/commentAttach.do";//获取用户拍摄的拳馆照片
NSString * const BecomeGymMenberShipURL = @"/api/gymmenbership/save$GymMenberShip.do";

NSString * const GetCoachTeachRecord = @"/api/coursebook/get$CourseHistory.do";

#pragma mark - 训练
NSString * const GetTraineeListURL = @"/api/coursebook/findCourseMember.do"; //获取课程学员列表
NSString * const GetTraineeGradeVersionURL = @"/api/gradedetail/get$Versions.do"; //获取学员技能点最新版本
NSString * const GetTraineeShouldGradeNumberURL = @"/api/base/readField.do";//获取当前课程可评价子项数目
NSString * const SaveSkillVersionURL = @"/api/skillversions/save$SkillVersions.do";// 上课评分
#pragma mark - 新格斗场
NSString * const GetGymTimeSlotsByIdURL = @"/api/place/listTime.do";
NSString *const GetGymVIPInfoURL = @"/api/gymmenbership/find.do";//
NSString * const OrderCourseURL = @"/api/coursebook/save$CourseBook.do";
NSString * const ChangeCourseStatusURL = @"/api/coursebook/save$bookAble.do";
NSString * const DeleteOrderCourseURL = @"/api/coursebook/delete$CourseBook.do";
NSString * const GetGymPlacesByIdURL = @"/api/place/listPlace.do";
NSString * const GetGymPlacesUsingInfoByIdURL = @"/api/place/list.do";//GetGymInfoByIdURL
NSString * const GetGymSourceInfoByIdURL = @"/api/place/listCource.do";
NSString * const GetCoachCourceInfoByIdURL = @"/api/coursebook/listCoachSyllabus.do";
NSString * const GetGymInfoByIdURL = @"/api/match/listms.do";
NSString *const GetBoxerListURL = @"/api/boxer/list.do";
NSString *const AddMatchURL = @"/api/match/save$Match.do";
NSString *const GetMatchListURL = @"/api/match/list.do";

NSString *const SaveCourseBookCheckSign = @"gedoujiaghdrfskflges2gfd";
NSString *const ChangeCourseStatusCheckSign = @"gedoujiajhgfdsh5826fds";
NSString *const DeleteCourseBookCheckSign = @"gedoujiajhjgfdlh25gfd";


//迎战or拒战
NSString *const ResponseToMatchURL = @"/api/match/save$mc.do";
//微信支付
NSString *const WXPayURL = @"/api/pl/add$pl.do";
//微信支付结果查询
NSString *const GetWXPayStatus = @"/api/pl/get$WxPaySta.do";
//拳馆详细信息
NSString *const GetGymDetailURL = @"/api/match/%@.do";

#pragma mark - 个人主页
// 个人主页评价教练接口
NSString *const CommentCoachURL = @"api/coacheval/save$CoachEval.do";
// 查看教练是否评价接口
NSString *const CheckIsCommentCoachURL = @"/api/coacheval/find.do";

#pragma mark - 充值、购买、积分
// 查询余额接口
NSString * const QueryMoneyURL = @"/api/cumulation/queryMoney.do";
// 推广任务接口
NSString * const ExtensionTaskURL = @"/api/cumulation/extensionTask.do";
// 是否已经购买视频查询接口
NSString * const IsBuyVideoDoneURL = @"/api/cumulation/hasBuyVideoDone.do";
// 购买视频接口
NSString * const BuyVideoURL = @"/api/cumulation/buyVideo.do";
// 获取视频URL接口
NSString * const GetBuyVideoURL = @"/api/cumulation/getBuyVideoUrl.do";

// app内购预下单接口
NSString * const RechargeIAPURL = @"/api/cumulation/appleRecharge.do";
// app内购验证付款接口
NSString * const CheckIAPURL = @"/api/cumulation/appleOrderquery.do";

#pragma mark - 兑吧

// 获取兑吧功能配置
NSString * const DuiBaConfigURL = @"/api/config/getConfig.do";
// 请求兑吧地址
NSString * const DuiBaURL = @"/api/duiba/getShopList.do";

// 兑吧扣除积分接口
NSString * const DuiBaChargeURL = @"/api/duiba/exchangeShop.do";

// 兑吧确定扣除积分接口
NSString * const DuiBaCheckCharegeURL = @"/api/duiba/exchangeShopStates.do";

NSString * const ShopURL = @"/shop/index.html";
NSString * const ShopNewURL = @"/shopNew/index.html";
NSString * const ShopOrderURL = @"/shop/order.html";

#pragma mark 拳吧
// URL
NSString *const BoxingBarSectionURL = @"/api/damageplate/list.do";
NSString *const UserWhetherFollowModuleURL = @"/api/damageplatefollow/find.do";
NSString *const FollowModuleURL = @"/api/damageplatefollow/save$DamagePlateFollow.do";
NSString *const UnFollowModuleURL = @"/api/damageplatefollow/delete$DamagePlateFollow.do";

//校验码
NSString *const FollowModuleCheckSign = @"gedoujihgf226g66";
NSString *const UnFollowModuleCheckSign = @"gedoujihghdtfsh254";

@end


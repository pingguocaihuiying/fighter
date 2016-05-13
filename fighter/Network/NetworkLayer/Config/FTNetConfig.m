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
@end

//NSString * const Domain = @"http://www.loufang.studio/pugilist_adminTest";//测试环境
//NSString * const Domain = @"http://10.11.1.49/pugilist_admin";//测试环境--余彧电脑
NSString * const Domain = @"http://www.loufang.studio/pugilist_admin";//生产环境

//获取新闻
NSString * const GetNewsURL = @"/api/news/getNews.do";

//评论接口地址: 
NSString * const CommentURL = @"/api/comment/add$UserComment.do";

//获取（点赞、关注等）的状态
NSString *const GetStateURL = @"/api/status/get$Status.do";

//增加点赞接口
NSString *const AddVoteURL = @"/api/comment/add$Vote.do";
//删除点赞接口
NSString *const DeleteVoteURL = @"/api/comment/delete$Vote.do";

//获取视频接口地址: 域名/api/news/getVideos.do
NSString *const GetVideoURL = @"/api/videos/getVideos.do";

//收藏的接口: 域名/api/videos/upVideoViewN.do
NSString *const AddViewCountURL = @"/api/videos/upVideoViewN.do";

//增加收藏的接口地址: 域名/api/base/save$Base.do
NSString *const AddStarURL = @"/api/base/save$Base.do";
//删除收藏的接口地址:域名/api/base/delete$Base.do
NSString *const DeleteStarURL = @"/api/base/delete$Base.do";


//NSString * const UserInterfaceHost = @"http://121.42.44.216/integral_adminTest";
NSString * const UserInterfaceHost = @"http://192.168.85.45/integral_adminTest";  //测试注册用，不能用于微信登录、微信支付

//
NSString * const GetPhoneCodeURL = @"/api/newuser/getPhoneCode.do";

NSString * const RegisterUserURL = @"/api/newuser/registerUser.do";

NSString * const UserLoginURL = @"/api/newuser/userLogin.do";

NSString * const UserLogoutURL = @"/api/newuser/userLogout.do";

NSString * const UserWXLoginURL = @"/api/newuser/userWXLogin.do";

NSString * const UpdateUserURL = @"/api/newuser/updateUser.do";

NSString * const UpdateUserHeadPicURL = @"/api/newuser/updateUserHeadpic.do";

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



//校验码
NSString * const GetStatusCheckKey =  @"gedoujia25fdsgfd55fdsafsag21254";
    //增加投票
 NSString * const AddVoteCheckKey =    @"gedoujia1255525522255521254";
    //删除投票
 NSString * const DeleteVoteCheckKey = @"gedoujia125ggrfdsgfd5521254";

//增加视频观看数
NSString * const UpVideoViewNCheckKey =  @"quanjijia222222";
    //收藏
NSString * const AddStarCheckKey =  @"gedoujia1gdshjjgfkd52261225550";
    //取消收藏
NSString * const DeleteStarCheckKey =  @"gedoujia1ggghfdjskfgl1250";
                                         

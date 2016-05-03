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
@end

//NSString * const Domain = @"http://www.loufang.studio/pugilist_adminTest";//测试环境
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

//NSString * const UserInterfaceHost = @"http://121.42.44.216/integral_adminTest";
NSString * const UserInterfaceHost = @"http://192.168.85.45/integral_adminTest";  //测试注册用，不能用于微信登录、微信支付

NSString * const GetPhoneCodeURL = @"/api/newuser/getPhoneCode.do";

NSString * const RegisterUserURL = @"/api/newuser/registerUser.do";

NSString * const UserLoginURL = @"/api/newuser/userLogin.do";

NSString * const UserWXLoginURL = @"/api/newuser/userWXLogin.do";

NSString * const UpdateUserURL = @"/api/newuser/updateUser.do";

NSString * const UpdateUserHeadPicURL = @"/api/newuser/updateUserHeadpic.do";

NSString * const SendSMSFindPwsURL = @"/api/newuser/sendSMS_Old.do";

NSString * const SendSMSNewPwdURL = @"/api/newuser/findpassword.do";

NSString * const GetPayAccountInfoURL = @"/api/newuser/getPayAccountInfo.do";

NSString * const UpdatePayAccountInfoURL = @"/api/newuser/updatePayAccountInfo.do";

NSString * const SendSMSByTypeURL = @"/api/newuser/sendSMS.do";

NSString * const GetQunListURL = @"/api/newuser/getQunList.do";

NSString * const GetAchievementInfo = @"/api/newuser/getAchievementInfo.do";

NSString * const SaveUserAppsURL = @"/api/newuser/saveUserApps.do";

NSString * const IsUserBindPhoneURL = @"/api/newuser/isUserBindPhone.do";




//获取状态的校验码
NSString * const GetStatusCheckKey =  @"gedoujia25fdsgfd55fdsafsag21254";

 NSString * const AddVoteCheckKey =    @"gedoujia1255525522255521254";

 NSString * const DeleteVoteCheckKey = @"gedoujia125ggrfdsgfd5521254";


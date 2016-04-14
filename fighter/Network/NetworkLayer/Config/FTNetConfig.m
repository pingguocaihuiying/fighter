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



NSString * const Domain = @"http://www.loufang.studio/pugilist_adminTest";//测试环境
//NSString * const Domain = @"http://www.loufang.studio/pugilist_admin";//生产环境

NSString * const GetNewsURL = @"/api/news/getNews.do";





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
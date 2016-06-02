//
//  NetWorking.m
//  fighter
//
//  Created by Liyz on 4/13/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "NetWorking.h"
#import "UUID.h"
#import "FTUserBean.h"
#import "WXApi.h"
#import "UIWindow+MBProgressHUD.h"

@implementation NetWorking


#pragma mark - 验证码
//获取短信验证码
- (void) getCheckCodeWithPhoneNumber:(NSString *)phoneNum option:(void (^)(NSDictionary *dict))option{
    
    NSString *urlString = [FTNetConfig host:Domain path:GetPhoneCodeURL];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:phoneNum forKey:@"phone"];
    
    [self postRequestWithUrl:urlString parameters:dic option:option];
    
}


//绑定手机时获取验证码
- (void) getCheckCodeForNewBindingPhone:(NSString *)phoneNum
                                 option:(void (^)(NSDictionary *dict))option{
    
    NSString *urlString = [FTNetConfig host:Domain path:SendSMSByTypeURL];
    
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:localUser.olduserid forKey:@"userId"];
    [dic setObject:phoneNum forKey:@"phone"];
    [dic setObject:@"bindphone" forKey:@"type"];
    
    [self postRequestWithUrl:urlString parameters:dic option:option];
    
}


//更换手机时获取 旧手机号 验证码
- (void) getCheckCodeForExistPhone:(NSString *)phoneNum
                                type:(NSString *)type
                              option:(void (^)(NSDictionary *dict))option{
    
    NSString *urlString = [FTNetConfig host:Domain path:SendSMSExistURL];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:phoneNum forKey:@"phone"];
    [dic setObject:type forKey:@"type"];
    [dic setObject:[self userId] forKey:@"userId"];
    NSLog(@"dic:%@",dic);
    [self postRequestWithUrl:urlString parameters:dic option:option];
}


//更换手机时获取 新手机号 验证码
- (void) getCheckCodeForNewPhone:(NSString *)phoneNum
                            type:(NSString *)type
                          option:(void (^)(NSDictionary *dict))option {

    NSString *urlString = [FTNetConfig host:Domain path:SendSMSNewURL];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:phoneNum forKey:@"phone"];
    [dic setObject:type forKey:@"type"];
    [dic setObject:[self userId] forKey:@"userId"];
     NSLog(@"dic:%@",dic);
    [self postRequestWithUrl:urlString parameters:dic option:option];
}




#pragma mark - 注册，登录，退出登录
//手机号注册用户
- (void) registUserWithPhoneNumber:(NSString *)phoneNum
                          password:(NSString *)password
                         checkCode:(NSString *)checkcode
                            option:(void (^)(NSDictionary *dict))option{

    
    NSString *registURLString = [FTNetConfig host:Domain path:RegisterUserURL];
    NSLog(@"完成注册按钮clicked");
   
    NSString *username = phoneNum;
    NSString *checkCode = checkcode;
    NSString *imei= [UUID getUUID];
//    NSString *password = password;
//    NSString *checkCode = checkCode;
    
    NSString *appendedPassword = [NSString stringWithFormat:@"%@%@", password, @"**#qwe"];
    NSString *md5String = [MD5 md5:appendedPassword];

    NSDictionary *dic = @{@"userId" : username,
                      @"imei" : imei,
                      @"sequenceId" : imei,
                      @"password" : md5String,
                      @"checkCode" : checkCode,
                      @"city" : @"-1",
                      @"recommCode" : @"-1",
                      @"stemfrom":@"iOS"
                      };
    NSLog(@"dic : %@", dic);
    [self postRequestWithUrl:registURLString parameters:dic option:option];
    
}

//手机号登录
- (void) loginWithPhoneNumber:(NSString *)phoneNum
                          password:(NSString *)password
                            option:(void (^)(NSDictionary *dict))option{
    
    
    
    
    
    NSString *loginURLString = [FTNetConfig host:Domain path:UserLoginURL];
    
    NSString *username = phoneNum;
    NSString *appendedPassword = [NSString stringWithFormat:@"%@%@", password, @"**#qwe"];
    NSString *md5String = [MD5 md5:appendedPassword];
    
    NSDictionary *dic = @{@"phone" : username,
                          @"password" : md5String,
                          @"city" : @"-1",
                          };
    
    [self postRequestWithUrl:loginURLString parameters:dic option:option];
    
}


//退出登录
- (void) loginOut:(void (^)(NSDictionary *dict))option {
    
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    NSString *token = localUser.token;
    NSLog(@"token:%@",token);
    NSString *olduserid = localUser.olduserid;
    
    //必选字段
    [dic setObject:token forKey:@"token"];
    [dic setObject:olduserid forKey:@"userId" ];
    
    NSString *loginOutURLString = [FTNetConfig host:Domain path:UserLogoutURL];
    NSLog(@"loginOutURLString url:%@", loginOutURLString);
    
    [self postRequestWithUrl:loginOutURLString parameters:dic option:option];
    
}

#pragma mark - 修改用户数据

//修改用户数据  -get
- (void) updateUserByGet:(NSString *)value
                       Key:(NSString *)key
                    option:(void (^)(NSDictionary *dict))option{
    
    NSDictionary *dic = [self setJsonDataWithKey:key value:value];
    NSLog(@"dic:%@", dic);
    
    NSString *updateURLString = [FTNetConfig host:Domain path:UpdateUserURL];
    NSLog(@"updateURLString url : %@", updateURLString);

    [self getRequestWithUrl:updateURLString parameters:dic option:option];
    
}


//修改用户数据  --post
- (void) updateUserWithValue:(NSString *)value
                         Key:(NSString *)key
                      option:(void (^)(NSDictionary *dict))option {
    
    NSDictionary *dic = [self setJsonDataWithKey:key value:value];
    NSLog(@"dic:%@", dic);
    NSString *updateURLString = [FTNetConfig host:Domain path:UpdateUserURL];
   
    NSLog(@"updateURLString url : %@", updateURLString);
    
    [self postRequestWithUrl:updateURLString parameters:dic option:option];

}



//修改用户头像
- (void) updateUserHeaderWithLocallUrl:(NSURL *)localUrl
                         Key:(NSString *)key
                      option:(void (^)(NSDictionary *dict))option{
    
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:localUser.olduserid forKey:@"userid" ];
    [dic setObject:@"user/upload/icon" forKey:key];
    
    NSDictionary *appendDic = @{
                                key : localUrl,
                          
                                };

    NSString *updateHeaderURLString = [FTNetConfig host:Domain path:UpdateUserHeadPicURL];
    NSLog(@"updateURLString url : %@", updateHeaderURLString);
    
    [self postUploadDataWithURL:updateHeaderURLString
                     parameters:dic
               appendParameters:appendDic
                         option:option];
    
    
}


//接口地址: 域名/api/newuser/updatePassword.do
//修改用户密码
- (void) updatePassword:(NSString *) oldpass
            newPassword:(NSString *) newPass
                 option:(void (^)(NSDictionary *dict))option{
    
    NSString *updatePaasswordURL = [FTNetConfig host:Domain path:UpdatePassWordURL];

    NSLog(@"oldpass:%@",oldpass);
    NSString *oldpassword = [NSString stringWithFormat:@"%@%@", oldpass, @"**#qwe"];
    NSString *newpossword = [NSString stringWithFormat:@"%@%@", newPass, @"**#qwe"];
    
    NSString *passOld =  [MD5 md5:oldpassword];
    NSString *passNew=  [MD5 md5:newpossword];
    
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    
    NSDictionary *dic = @{@"oldpassword" : passOld,
                          @"newpossword" : passNew,
                          @"userid"  :localUser.olduserid
                          };
    NSLog(@"dic%@",dic);
    [self postRequestWithUrl:updatePaasswordURL parameters:dic option:option];

}



#pragma mark - 绑定手机、微信

//检查用户是否绑定手机
- (void) isBindingPhoneNum:(void (^)(NSDictionary *dict))option {

    NSString *isBindingURLString = [FTNetConfig host:Domain path:ISBindingPhoneURL];
    
    
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    NSString *olduserid = localUser.olduserid;
    
    //必选字段
    [dic setObject:olduserid forKey:@"userid" ];
    NSLog(@"dic%@",dic);
    [self postRequestWithUrl:isBindingURLString parameters:dic option:option];
}



//绑定手机号码
- (void) bindingPhoneNumber:(NSString *)phoneNum
                  checkCode:(NSString *)checkcode
                     option:(void (^)(NSDictionary *dict))option{
    
    
//    NSString *bindingURLString = [FTNetConfig host:Domain path:BindingPhoneURL];
    //暂时用更新用户接口
    NSString *bindingURLString = [FTNetConfig host:Domain path:UpdateUserURL];
    
    
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    NSString *olduserid = localUser.olduserid;
    NSString *token = localUser.token;
    
    //必选字段
    [dic setObject:olduserid forKey:@"userid" ];
    [dic setObject:token forKey:@"token"];
    [dic setObject:@"bindphone" forKey:@"type"];//phone
    [dic setObject:phoneNum forKey:@"phone"];
    [dic setObject:checkcode forKey:@"checkCode"];
    
//    NSString *imei= [UUID getUUID];
//    [dic setObject:imei forKey:@"imei"];
//    [dic setObject:imei forKey:@"sequenceId"];
    
    NSLog(@"dic:%@",dic);
    
    [self postRequestWithUrl:bindingURLString parameters:dic option:option];
    
}


//验证 旧手机 验证码
- (void) checkCodeForExistPhone:(NSString *)phoneNum
                  checkCode:(NSString *)checkcode
                     option:(void (^)(NSDictionary *dict))option{
    
    
    //    NSString *bindingURLString = [FTNetConfig host:Domain path:BindingPhoneURL];
    //暂时用更新用户接口
    NSString *bindingURLString = [FTNetConfig host:Domain path:IsValidatePhone];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:@"2" forKey:@"type"];//phone
    [dic setObject:phoneNum forKey:@"phone"];
    [dic setObject:checkcode forKey:@"checkCode"];
    [dic setObject:[self userId] forKey:@"userId"];
    //    NSString *imei= [UUID getUUID];
    //    [dic setObject:imei forKey:@"imei"];
    //    [dic setObject:imei forKey:@"sequenceId"];
    
    NSLog(@"dic:%@",dic);
    
    [self postRequestWithUrl:bindingURLString parameters:dic option:option];
    
}


//修改绑定手机
- (void) changgeBindingPhone:(NSString *)phoneNum
                    checkCode:(NSString *)checkcode
                       option:(void (^)(NSDictionary *dict))option{
    
    
    //    NSString *bindingURLString = [FTNetConfig host:Domain path:BindingPhoneURL];
    //暂时用更新用户接口
    NSString *bindingURLString = [FTNetConfig host:Domain path:UpdateUserURL];
    
    
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    NSString *olduserid = localUser.olduserid;
    NSString *token = localUser.token;
    
    //必选字段
    [dic setObject:olduserid forKey:@"userid" ];
    [dic setObject:token forKey:@"token"];
    [dic setObject:@"changephone" forKey:@"type"];//phone
    [dic setObject:phoneNum forKey:@"phone"];
    [dic setObject:checkcode forKey:@"checkCode"];
    
    //    NSString *imei= [UUID getUUID];
    //    [dic setObject:imei forKey:@"imei"];
    //    [dic setObject:imei forKey:@"sequenceId"];
    
    NSLog(@"dic:%@",dic);
    
    [self postRequestWithUrl:bindingURLString parameters:dic option:option];
    
}



//绑定微信号
- (void) bindingWeixin:(NSString *)openId
//                  checkCode:(NSString *)checkcode
                option:(void (^)(NSDictionary *dict))option {

    //暂时用更新用户接口
    NSString *bindingURLString = [FTNetConfig host:Domain path:UpdateUserURL];
    
    
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    NSString *olduserid = localUser.olduserid;
    NSString *token = localUser.token;
    NSString *unionId = localUser.unionId;
    //必选字段
    [dic setObject:token forKey:@"token"];
    [dic setObject:olduserid forKey:@"userid" ];
    [dic setObject:unionId forKey:@"unionId" ];
    [dic setObject:openId forKey:@"openId" ];
    
    NSLog(@"dic%@",dic);
    
    [self postRequestWithUrl:bindingURLString parameters:dic option:option];
    
}



#pragma mark - 微信相关

//向微信请求数据
- (void) weixinRequest {

    if ([WXApi isWXAppInstalled] ) {
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"fighter";
        [WXApi sendReq:req];
        
    }else{
        NSLog(@"目前只支持微信登录，请安装微信");
        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"未安装微信！"];
    }

}


//请求微信的token和openId
- (void) requestWeixinTokenAdnOpenId:(NSString *)code
                              option:(void (^)(NSDictionary *dict))option {

    NSString *accessUrlStr = [NSString stringWithFormat:@"%@/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", WX_BASE_URL, WX_App_ID, WX_App_Secret, code];
    
    [self getRequestWithUrl:accessUrlStr parameters:nil option:option];
}


//获取微信用户信息
- (void) requestWeixinUserInfoWithToken:(NSString *)token
                                 openId:(NSString *)openId
                                 option:(void(^)(NSDictionary *dict)) option {
    NSString *userinfoURL = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", token, openId];

    [self getRequestWithUrl:userinfoURL parameters:nil option:option];
}



//向服务器注册微信用户，或者登录微信用户
- (void) requestWeixinUser:(NSDictionary *)wxInfoDic
                    option:(void (^)(NSDictionary *dict))option{
    
    for(NSString *key in [wxInfoDic allKeys]){
        NSLog(@"key:%@", key);
    }
    
    NSString *openId = wxInfoDic[@"openid"];
    NSString *unionId = wxInfoDic[@"unionid"];
    NSString *timestampString = [NSString stringWithFormat:@"%.0lf",[[NSDate date] timeIntervalSince1970]];
    NSString *imei = [UUID getUUID];
    NSString *username = wxInfoDic[@"nickname"];
    NSString *keyToken = [NSString stringWithFormat:@"%@%@", WXLoginSecret_Key, timestampString];
    NSString *keyTokenMD5 = [MD5 md5:keyToken];
    NSString *province = wxInfoDic[@"province"];
    NSString *headpic = wxInfoDic[@"headimgurl"];
    headpic = [self encodeToPercentEscapeString:headpic];
    NSString *stemfrom = @"iOS";
    username = [username stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *wxLoginURLString = [FTNetConfig host:Domain path:UserWXLoginURL];
    wxLoginURLString = [NSString stringWithFormat:@"%@?openId=%@&unionId=%@&timestamp=%@&imei=%@&username=%@&keyToken=%@&city=%@&headpic=%@&stemfrom=%@", wxLoginURLString, openId, unionId, timestampString, imei, username, keyTokenMD5, province, headpic, stemfrom];

    
    [self getRequestWithUrl:wxLoginURLString parameters:nil option:option];
}

- (NSString *) userId {
    
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    
    return localUser.olduserid;
}
//url转码
- (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)input,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return outputStr;
}

#pragma mark - 排行榜

//获取排行榜列表信息
- (void) getRankListWithLabel:(NSString *)label
                         race:(NSString *)race
                FeatherWeight:(NSString *)featherWeight
                      pageNum:(NSInteger)pagenum
                       option:(void (^)(NSDictionary *dict))option {
    
    
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    //必选字段
    [dic setObject:label forKey:@"label"];
    
    
    if (race != nil && ![race isEqualToString:@"全部"]) {
       [dic setObject:race forKey:@"race" ];
    }
    
    if (featherWeight != nil && ![featherWeight isEqualToString:@"全部"]) {
       [dic setObject:featherWeight forKey:@"featherWeight" ];
    }
    
    if(pagenum > 0){
      [dic setObject:[NSString stringWithFormat:@"%ld",pagenum] forKey:@"pageNum" ];
    }
    
    NSLog(@"dic:%@",dic);
    NSString *rankListUrl = [FTNetConfig host:Domain path:GetRankListURL];
    
    [self postRequestWithUrl:rankListUrl parameters:dic option:option];
}


//获取排行榜标签
- (void) getRankLabels:(void (^)(NSDictionary *dict))option {

    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    //必选字段
    [dic setObject:@"rankitem" forKey:@"tableName"];
    NSString *rankListUrl = [FTNetConfig host:Domain path:GetRankSearchItemURL];
    NSLog(@"Url:%@",rankListUrl);
    [self getRequestWithUrl:rankListUrl parameters:dic option:option];
}


#pragma mark - 视频
//获取排行榜标签
- (void) getVideos:(NSString *) urlString  option:(void (^)(NSDictionary *dict))option {
    
    [self getRequestWithUrl:urlString parameters:nil option:option];
}

#pragma mark - news 


#pragma mark - 封装请求
//post请求
- (void) postRequestWithUrl:(NSString *)urlString
                 parameters:(NSDictionary *)dic
                     option:(void (^)(NSDictionary *dict))option {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    NSLog(@"RegisterUserURL url : %@", urlString);
    [manager POST:urlString
       parameters:dic
          success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
              NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
              NSLog(@"responsedic:%@",responseDic);
              
              if (option) {
                  option(responseDic);
              }
          }
          failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
              NSLog(@"error:%@",error);
              if (option) {
                  option(nil);
              }
              
          }];
}



//post  请求上传二进制数据
- (void) postUploadDataWithURL:(NSString *)urlString
                    parameters:(NSDictionary *)dic
              appendParameters:(NSDictionary *)appendDic
                        option:(void (^)(NSDictionary *dict))option {
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:urlString
       parameters:dic
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    
    for (NSString *key in [appendDic allKeys] ) {
        
        [formData appendPartWithFileURL:appendDic[key] name:key error:nil];
    }
    
}
          success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
              
              NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
              NSLog(@"responsedic:%@",responseDic);
              
              if (option) {
                  option(responseDic);
              }
              
              
          }
          failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
              
              if (option) {
                  option(nil);
              }
          }];
    
    
}


//get请求
- (void) getRequestWithUrl:(NSString *)urlString
                parameters:(NSDictionary *)dic
                    option:(void (^)(NSDictionary *dict))option {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    NSLog(@"RegisterUserURL url : %@", urlString);
    [manager GET:urlString
      parameters:dic
         success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
             NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//             NSLog(@"responsedic:%@",responseDic);
             
             if (option) {
                 option(responseDic);
             }
         }
         failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
             NSLog(@"error:%@",error);
             if (option) {
                 option(nil);
             }
         }];
}



- (NSDictionary *) setJsonDataWithKey:(NSString*)key   value:(NSString *)value {
    
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    NSString *token = localUser.token;
    NSString *olduserid = localUser.olduserid;
    //必选字段
    [dic setObject:token forKey:@"token"];
    [dic setObject:olduserid forKey:@"userid" ];
    
    //添加修改字段
    [dic setObject:value forKey:key];
    
    return dic;
}



@end

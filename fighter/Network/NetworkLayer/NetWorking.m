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
#import "FTUserBean.h"
#import "FTEncoderAndDecoder.h"
#import "FTMatchDetailBean.h"

@implementation NetWorking


#pragma mark - 验证码
//获取短信验证码
+ (void) getCheckCodeWithPhoneNumber:(NSString *)phoneNum option:(void (^)(NSDictionary *dict))option{
    
    NSString *urlString = [FTNetConfig host:Domain path:GetPhoneCodeURL];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:phoneNum forKey:@"phone"];
    
    [self postRequestWithUrl:urlString parameters:dic option:option];
    
}


//绑定手机时获取验证码
+ (void) getCheckCodeForNewBindingPhone:(NSString *)phoneNum
                                 option:(void (^)(NSDictionary *dict))option{
    
    NSString *urlString = [FTNetConfig host:Domain path:SendSMSByTypeURL];
    
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:localUser.olduserid forKey:@"userId"];
    [dic setObject:phoneNum forKey:@"phone"];
    [dic setObject:@"gymmenbership" forKey:@"type"];
    
    [self postRequestWithUrl:urlString parameters:dic option:option];
    
}

//绑定手机时获取验证码(可以修改type类型的)
+ (void) getCheckCodeForNewBindingPhone:(NSString *)phoneNum withType:(NSString *)type
                                 option:(void (^)(NSDictionary *dict))option{
    
    NSString *urlString = [FTNetConfig host:Domain path:SendSMSByTypeURL];
    
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:localUser.olduserid forKey:@"userId"];
    [dic setObject:phoneNum forKey:@"phone"];
    [dic setObject:@"bindphone" forKey:@"type"];
    if (type) {
        [dic setObject:type forKey:@"type"];
    }
    
    [self postRequestWithUrl:urlString parameters:dic option:option];
}


//更换手机时获取 旧手机号 验证码
+ (void) getCheckCodeForExistPhone:(NSString *)phoneNum
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
+ (void) getCheckCodeForNewPhone:(NSString *)phoneNum
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
+ (void) registUserWithPhoneNumber:(NSString *)phoneNum
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
+ (void) loginWithPhoneNumber:(NSString *)phoneNum
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
+ (void) loginOut:(void (^)(NSDictionary *dict))option {
    
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
+ (void) updateUserByGet:(NSString *)value
                       Key:(NSString *)key
                    option:(void (^)(NSDictionary *dict))option{
    
    NSDictionary *dic = [self setJsonDataWithKey:key value:value];
    NSLog(@"dic:%@", dic);
    
    NSString *updateURLString = [FTNetConfig host:Domain path:UpdateUserURL];
    NSLog(@"updateURLString url : %@", updateURLString);

    [self getRequestWithUrl:updateURLString parameters:dic option:option];
//    [self getRequestWithUrl:updateURLString parameters:dic option:option];
    
}


//修改用户数据  --post
+ (void) updateUserWithValue:(NSString *)value
                         Key:(NSString *)key
                      option:(void (^)(NSDictionary *dict))option {
    
    NSDictionary *dic = [self setJsonDataWithKey:key value:value];
    NSLog(@"dic:%@", dic);
    NSString *updateURLString = [FTNetConfig host:Domain path:UpdateUserURL];
   
    NSLog(@"updateURLString url : %@", updateURLString);
    
    [self postRequestWithUrl:updateURLString parameters:dic option:option];

}



//修改用户头像
+ (void) updateUserHeaderWithLocallUrl:(NSURL *)localUrl
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

// 上传用户身份证照片
+ (void) uploadUserIdcard:(NSURL *)localUrl
                      Key:(NSString *)key  option:(void (^)(NSDictionary *dict))option {

    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:localUser.olduserid forKey:@"userid" ];
    [dic setObject:@"user/upload/icon" forKey:key];
    
    NSDictionary *appendDic = @{
                                key : localUrl,
                                
                                };
    
    NSString *updateHeaderURLString = [FTNetConfig host:Domain path:UploadUserIdCardURL];
    NSLog(@"updateURLString url : %@", updateHeaderURLString);
    
    [self postUploadDataWithURL:updateHeaderURLString
                     parameters:dic
               appendParameters:appendDic
                         option:option];

}

//接口地址: 域名/api/newuser/updatePassword.do
//修改用户密码
+ (void) updatePassword:(NSString *) oldpass
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
+ (void) isBindingPhoneNum:(void (^)(NSDictionary *dict))option {

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
+ (void) bindingPhoneNumber:(NSString *)phoneNum
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
+ (void) checkCodeForExistPhone:(NSString *)phoneNum
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
+ (void) changgeBindingPhone:(NSString *)phoneNum
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
+ (void) bindingWeixin:(NSString *)openId
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
+ (void) weixinRequest {

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
+ (void) requestWeixinTokenAdnOpenId:(NSString *)code
                              option:(void (^)(NSDictionary *dict))option {

    NSString *accessUrlStr = [NSString stringWithFormat:@"%@/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", WX_BASE_URL, WX_App_ID, WX_App_Secret, code];
    
    [self getRequestWithUrl:accessUrlStr parameters:nil option:option];
}


//获取微信用户信息
+ (void) requestWeixinUserInfoWithToken:(NSString *)token
                                 openId:(NSString *)openId
                                 option:(void(^)(NSDictionary *dict)) option {
    NSString *userinfoURL = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", token, openId];

    [self getRequestWithUrl:userinfoURL parameters:nil option:option];
}



//向服务器注册微信用户，或者登录微信用户
+ (void) requestWeixinUser:(NSDictionary *)wxInfoDic
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
    headpic = [FTEncoderAndDecoder encodeToPercentEscapeString:headpic];
    NSString *stemfrom = @"weixin";
    username = [username stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *wxLoginURLString = [FTNetConfig host:Domain path:UserWXLoginURL];
    wxLoginURLString = [NSString stringWithFormat:@"%@?openId=%@&unionId=%@&timestamp=%@&imei=%@&username=%@&keyToken=%@&city=%@&headpic=%@&stemfrom=%@", wxLoginURLString, openId, unionId, timestampString, imei, username, keyTokenMD5, province, headpic, stemfrom];

    
    [self getRequestWithUrl:wxLoginURLString parameters:nil option:option];
}




#pragma mark - 排行榜

//获取排行榜列表信息
+ (void) getRankListWithLabel:(NSString *)label
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
+ (void) getRankLabels:(void (^)(NSDictionary *dict))option {

    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    //必选字段
    [dic setObject:@"rankitem" forKey:@"tableName"];
    NSString *rankListUrl = [FTNetConfig host:Domain path:GetRankSearchItemURL];
    NSLog(@"Url:%@",rankListUrl);
    [self getRequestWithUrl:rankListUrl parameters:dic option:option];
}


#pragma mark - 视频
//获取排行榜标签
+ (void) getVideos:(NSString *) urlString  option:(void (^)(NSDictionary *dict))option {
    
    [self getRequestWithUrl:urlString parameters:nil option:option];
}

#pragma mark - 分装用户登录参数

+ (NSString *) userId {
    
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    
    return localUser.olduserid;
}


+ (NSDictionary *) setJsonDataWithKey:(NSString*)key   value:(NSString *)value {
    
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

#pragma mark - 封装请求---类方法
//post请求
+ (void) postRequestWithUrl:(NSString *)urlString
                 parameters:(NSDictionary *)dic
                     option:(void (^)(NSDictionary *dict))option {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    NSLog(@"RegisterUserURL url : %@", urlString);
    [manager POST:urlString
       parameters:dic
         progress:nil
          success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
              NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
              //              NSLog(@"responsedic:%@",responseDic);
              
              if (option) {
                  option(responseDic);
              }
          }
          failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"error:%@",error);
              if (option) {
                  option(nil);
              }
              
          }];
}



//post  请求上传二进制数据
+ (void) postUploadDataWithURL:(NSString *)urlString
                    parameters:(NSDictionary *)dic
              appendParameters:(NSDictionary *)appendDic
                        option:(void (^)(NSDictionary *dict))option {
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:urlString
       parameters:dic
       constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
                for (NSString *key in [appendDic allKeys] ) {
                    
                    [formData appendPartWithFileURL:appendDic[key] name:key error:nil];
                }
                
            }
         progress:nil
          success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
              
              NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
              //              NSLog(@"responsedic:%@",responseDic);
              
              if (option) {
                  option(responseDic);
              }
          }
          failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
              
              if (option) {
                  option(nil);
              }
          }];
}


//get请求
+ (void) getRequestWithUrl:(NSString *)urlString
                parameters:(NSDictionary *)dic
                    option:(void (^)(NSDictionary *dict))option {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    NSLog(@"RegisterUserURL url : %@", urlString);
    [manager GET:urlString
      parameters:dic
        progress:nil
         success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
             NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
             //             NSLog(@"responsedic:%@",responseDic);
             
             if (option) {
                 option(responseDic);
             }
         }
         failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"error:%@",error);
             if (option) {
                 option(nil);
             }
         }];
}



#pragma mark - 个人主页

+ (void)getHomepageUserInfoWithUserOldid:(NSString *)userOldid andBoxerId:(NSString *)boxerId andCoachId:(NSString *)coachId andCallbackOption:(void (^)(FTUserBean *userBean))userBeanOption{
    NSString *urlString = [FTNetConfig host:Domain path:GetHomepageUserInfo];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    assert(userOldid);
//    NSString *query = @"";
//    if (boxerId) {//如果boxerId和coachId都存在，
//        query = @"1";
//    }else if(coachId){
//        query = @"2";
//    }
//    
//    //如果有id为nil，则处理为@""，以便存入字典;
//    if (userOldid == nil) {
//        userOldid = @"";
//    }
//    if (boxerId == nil) {
//        boxerId = @"";
//    }
//    if (coachId == nil) {
//        coachId = @"";
//    }
//
    if (boxerId) {//如果有boxerId，查boxerId
        urlString = [NSString stringWithFormat:@"%@?boxerId=%@", urlString, boxerId];
    }else if(userOldid){
        urlString = [NSString stringWithFormat:@"%@?userId=%@", urlString, userOldid];
    }else if(coachId){
        urlString = [NSString stringWithFormat:@"%@?coachId=%@", urlString, coachId]; 
    }else{
        NSLog(@"没有id");
    }
    
    NSLog(@"urlString : %@", urlString);
    
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
//        [ZJModelTool createModelWithDictionary:responseObject modelName:nil];
                NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@", responseDic[@"data"]);
        NSString *result = responseDic[@"status"];
        if ([result isEqualToString:@"success"]) {
            NSDictionary *userDic = responseDic[@"data"];
            FTUserBean *userBean = [FTUserBean new];
            NSLog(@"user dic birthday : %@", userDic[@"birthday"]);
            [userBean setValuesForKeysWithDictionary:userDic];
            [userBean setValuesWithDic:userDic];
            userBean.boxerRaceInfos = userDic[@"boxerRaceInfos"];
            userBeanOption(userBean);
        } else {
            NSLog(@"error message: %@", responseDic[@"message"]);
            userBeanOption(nil);
        }
        
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error : %@", error);
        
    }];
}
#pragma mark 获取某节课教练的评价内容和
+ (void)getUserCourseHistoryWithOption:(void (^)(NSDictionary *dic)) option{
    NSString *urlString = [FTNetConfig host:Domain path:GetUserCourseHistoryURL];
    
    FTUserBean *loginedUser = [FTUserBean loginUser];
    if (!loginedUser) {
        [[[UIApplication sharedApplication] keyWindow] showHUDWithMessage:@"userId为空，请先登录"];
    }
    NSDictionary *dic = @{@"userId":loginedUser.olduserid};
    [NetWorking postRequestWithUrl:urlString parameters:dic option:option];
}

+ (void)getCommentsWithObjId:(NSString *)objId andTableName:(NSString *)tableName andOption:(void (^)(NSArray *))option{
    NSString *urlString = [FTNetConfig host:Domain path:GetCommentsURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    assert(objId);
    urlString = [NSString stringWithFormat:@"%@?objId=%@&tableName=%@", urlString, objId, tableName];
    //    NSLog(@"urlString : %@", urlString);
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        //        [ZJModelTool createModelWithDictionary:responseObject modelName:nil];
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"message : %@", responseDic[@"message"]);
        NSArray *array = responseDic[@"data"];
        
        if (array && array != (id)[NSNull null]) {
            option(array);
        }
        
    } failure:^(NSURLSessionTask * _Nullable tasK, NSError * _Nonnull error) {
        option(nil);
    }];
}
+ (void)getBoxerRaceInfoWithBoxerId:(NSString *)boxerId andOption:(void (^)(NSArray *array))option{
    NSString *urlString = [FTNetConfig host:Domain path:GetBoxerRaceInfoURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    assert(boxerId);
    urlString = [NSString stringWithFormat:@"%@?boxerId=%@", urlString, boxerId];
    //    NSLog(@"urlString : %@", urlString);
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        //        [ZJModelTool createModelWithDictionary:responseObject modelName:nil];
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"message : %@", responseDic[@"message"]);
        NSArray *array = responseDic[@"data"];
        
        if (array && array != (id)[NSNull null]) {
            option(array);
        }
        
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        option(nil);
    }];
}
//获取单个拳讯信息
+ (void)getNewsById:(NSString *)newsId andOption:(void (^)(NSArray *array))option{
    NSString *urlString = [FTNetConfig host:Domain path:GetNewsByIdURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    assert(newsId);
    
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@", newsId, ts, @"quanjijia222222"]];
    urlString = [NSString stringWithFormat:@"%@?newsId=%@&ts=%@&checkSign=%@", urlString, newsId, ts, checkSign];
        NSLog(@"get news by id urlString : %@", urlString);
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        //        [ZJModelTool createModelWithDictionary:responseObject modelName:nil];
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"message : %@", responseDic[@"message"]);
        NSArray *array = responseDic[@"data"];
        if (array && array != (id)[NSNull null]) {
            option(array);
        }
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        option(nil);
    }];
}

//获取单个视频信息
+ (void)getVideoById:(NSString *)videoId andOption:(void (^)(NSArray *array))option{
    NSString *urlString = [FTNetConfig host:Domain path:GetVideoByIdURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    assert(videoId);
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@", videoId, ts, @"quanjijia222222"]];
    urlString = [NSString stringWithFormat:@"%@?videosId=%@&ts=%@&checkSign=%@", urlString, videoId, ts, checkSign];
        NSLog(@"get video by id urlString : %@", urlString);
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        //        [ZJModelTool createModelWithDictionary:responseObject modelName:nil];
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"message : %@", responseDic[@"message"]);
        NSArray *array = responseDic[@"data"];
        
        if (array && array != (id)[NSNull null]) {
            option(array);
        }
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        option(nil);
    }];
}


#pragma mark - 学拳
// Get Coach List
+ (void) getCoachsByDic:(NSDictionary *)dic option:(void (^)(NSDictionary *dict))option  {
    
    NSString *urlString = [FTNetConfig host:Domain path:GetCoachListURL];
    NSLog(@"dic:%@",dic);
    NSLog(@"urlString:%@",urlString);
    [self postRequestWithUrl:urlString parameters:dic option:option];
}

// Get Gym List
+ (void) getGymsByDic:(NSDictionary *)dic option:(void (^)(NSDictionary *dict))option  {
    
    NSString *urlString = [FTNetConfig host:Domain path:GetGymListURL];
    NSLog(@"urlString=%@",urlString);
    NSLog(@"dic = %@",dic);
    [self getRequestWithUrl:urlString parameters:dic option:option];
}

+ (void) getGymsForArenaByDic:(NSDictionary *)dic option:(void (^)(NSDictionary *dict))option  {
    
    NSString *urlString = [FTNetConfig host:Domain path:GetGymListForArenaURL];
    NSLog(@"urlString=%@",urlString);
    NSLog(@"dic = %@",dic);
    [self getRequestWithUrl:urlString parameters:dic option:option];
}

// Get Gym Comment List
+ (void) getGymComments:(NSString *)objectId option:(void (^)(NSDictionary *dict))option  {
    
    NSString *urlString = [FTNetConfig host:Domain path:GetCommentsURL];
    NSLog(@"urlString=%@",urlString);
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:objectId forKey:@"objId"];
    [dic setObject:@"c-gym" forKey:@"tableName"];
    [self getRequestWithUrl:urlString parameters:dic option:option];
}

// Get Comment for gym Comment List
+ (void) getGymReplyComments:(NSString *)objectId option:(void (^)(NSDictionary *dict))option  {
    
    NSString *urlString = [FTNetConfig host:Domain path:GetCommentsURL];
    NSLog(@"urlString=%@",urlString);
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:objectId forKey:@"objId"];
    [dic setObject:@"c-cgym" forKey:@"tableName"];
    [self getRequestWithUrl:urlString parameters:dic option:option];
}


// Add Gym Comment
+ (void) addGymCommentWithPramDic:(NSDictionary*)pramDic option:(void (^)(NSDictionary *dict))option  {
    
    NSString *urlString = [FTNetConfig host:Domain path:CommentURL];
     NSLog(@"urlString=%@",urlString);
    
    FTUserBean *loginuser = [FTUserBean loginUser];
    NSString *userId = loginuser.olduserid;
    NSString *token = loginuser.token;
    NSString *ts = [NSString stringWithFormat:@"%.0f",([[NSDate date] timeIntervalSince1970]*1000.0f)];// 时间戳
    
   
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//    [dic setObject:objectId forKey:@"objId"];
    [dic setObject:@"c-gym" forKey:@"tableName"];
    [dic setObject:userId forKey:@"userId"];
    [dic setObject:token forKey:@"loginToken"];
    [dic setObject:ts forKey:@"ts"];
    
    [dic addEntriesFromDictionary:pramDic];
    
    NSString *checkSign = [FTTools md5Dictionary:dic withCheckKey:@"gedoujia12555521254"];
    
    [dic setObject:checkSign forKey:@"checkSign"];
    
    NSLog(@"pram:%@",dic);
    
    [self getRequestWithUrl:urlString parameters:dic option:option];
}

// 添加拳馆二级评论
+ (void) addCommentForGymComment:(NSDictionary*)pramDic option:(void (^)(NSDictionary *dict))option  {
    
    NSString *urlString = [FTNetConfig host:Domain path:CommentURL];
    NSLog(@"urlString=%@",urlString);
    
    FTUserBean *loginuser = [FTUserBean loginUser];
    NSString *userId = loginuser.olduserid;
    NSString *token = loginuser.token;
    NSString *ts = [NSString stringWithFormat:@"%.0f",([[NSDate date] timeIntervalSince1970]*1000.0f)];// 时间戳
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:@"c-cgym" forKey:@"tableName"];
    [dic setObject:userId forKey:@"userId"];
    [dic setObject:token forKey:@"loginToken"];
    [dic setObject:ts forKey:@"ts"];
    
    [dic addEntriesFromDictionary:pramDic];
    
    NSString *checkSign = [FTTools md5Dictionary:dic withCheckKey:@"gedoujia12555521254"];
    
    [dic setObject:checkSign forKey:@"checkSign"];
    
    NSLog(@"pram:%@",dic);
    
    [self getRequestWithUrl:urlString parameters:dic option:option];
    
}


/**
 查看教练授课记录

 @param corporationid 拳馆id
 @param option  授课记录json字典
 @param courseType  课程类型，0：团课 2:私教
 */
+ (void) getCoachTeachRecordWithCorporationid:(NSString*)corporationid andCourseType:(NSString *)courseType option:(void (^)(NSDictionary *dict))option {

    NSString *urlString = [FTNetConfig host:Domain path:GetCoachTeachRecord];
    NSLog(@"urlString=%@",urlString);

    
    FTUserBean *loginuser = [FTUserBean loginUser];
    NSString *userId = loginuser.olduserid;
    NSString *token = loginuser.token;
    NSString *ts = [NSString stringWithFormat:@"%.0f",([[NSDate date] timeIntervalSince1970]*1000.0f)];// 时间戳
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:userId forKey:@"userId"];
    [dic setObject:token forKey:@"loginToken"];
    [dic setObject:ts forKey:@"ts"];
    [dic setObject:courseType forKey:@"type"];
    [dic setObject:corporationid forKey:@"corporationid"];
    
    NSString *checkSign = [FTTools md5Dictionary:dic withCheckKey:@"gedoujiahtdfh3gf24"];
    [dic setObject:checkSign forKey:@"checkSign"];

    
    [self postRequestWithUrl:urlString parameters:dic option:option];
}



#pragma mark - 训练
/**
 查看教练授课记录
 
 @param corporationid 拳馆id
 @param option  授课记录json字典
 @param courseType  课程类型，0：团课 2:私教
 */
+ (void) getTraineeListWith:(NSDictionary *)dict  option:(void (^)(NSDictionary *dict))option {
    
    NSString *urlString = [FTNetConfig host:Domain path:GetTraineeListURL];
    NSLog(@"urlString=%@",urlString);
    
    [self postRequestWithUrl:urlString parameters:dict option:option];
    
}


+ (void)getCourseCommentWithVersion:(NSString *)version andOption:(void (^)(NSDictionary *dic)) option{
    NSString *urlString = [FTNetConfig host:Domain path:GetUserCourseHistoryURL];
    
    FTUserBean *loginedUser = [FTUserBean loginUser];
    if (!loginedUser) {
        [[[UIApplication sharedApplication] keyWindow] showHUDWithMessage:@"userId为空，请先登录"];
    }
    NSDictionary *dic = @{@"userId":loginedUser.olduserid, @"versions":version};
    [NetWorking postRequestWithUrl:urlString parameters:dic option:option];
}


+ (void)getUserSkillsWithCorporationid:(NSString *)corporationid andMemberUserId:(NSString *)memberUserId andVersion:(NSString *)version andParent:(NSString *)parent andOption:(void (^)(NSDictionary *dic)) option{
    NSString *urlString = [FTNetConfig host:Domain path:GetUserSkillsURL];
    
    FTUserBean *loginedUser = [FTUserBean loginUser];
    if (!loginedUser) {
        [[[UIApplication sharedApplication] keyWindow] showHUDWithMessage:@"userId为空，请先登录"];
    }
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    //通用的字段
    [dic setValue:loginedUser.olduserid forKey:@"userId"];//当前用户的id
    [dic setValue:loginedUser.token forKey:@"loginToken"];
    [dic setValue:[self getTimeStamp13] forKey:@"ts"];
    
    
    //个性化字段
    [dic setValue:memberUserId forKey:@"memberUserId"];
    
    if (corporationid) {
        [dic setValue:corporationid forKey:@"corporationid"];
    }
    if (version) {
        [dic setValue:version forKey:@"versions"];
    }
    if (parent) {
        [dic setValue:corporationid forKey:@"parent"];
    }
    
    NSString *checkSign = [FTTools md5Dictionary:dic withCheckKey:GetUserSkillsCheckSign];
    
    [dic setValue:checkSign forKey:@"checkSign"];
    
    [NetWorking postRequestWithUrl:urlString parameters:dic option:option];
}


#pragma mark - 赛事
+ (void)getGymTimeSlotsById:(NSString *) corporationID andOption:(void (^)(NSArray *array))option{
    NSString *urlString = [FTNetConfig host:Domain path:GetGymTimeSlotsByIdURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    assert(corporationID);
    
    urlString = [NSString stringWithFormat:@"%@?corporationid=%@", urlString, corporationID];
    NSLog(@"getGymTimeSlotsById urlString : %@", urlString);
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        //        [ZJModelTool createModelWithDictionary:responseObject modelName:nil];
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"message : %@", responseDic[@"message"]);
        NSString *status = responseDic[@"status"];
        NSArray *array = responseDic[@"data"];
        if ([status isEqualToString:@"success"]) {
            if (array && array != (id)[NSNull null]) {
                option(array);
            }else{
                option(nil);
            }
        }else{
            option(nil);
        }
    } failure:^(NSURLSessionTask * _Nonnull task, NSError * _Nonnull error) {
        option(nil);
    }];
}
//获取场地配置
+ (void)getGymPlaceInfoById:(NSString *)gymId andOption:(void (^)(NSArray *array))option{
    NSString *urlString = [FTNetConfig host:Domain path:GetGymPlacesByIdURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    assert(gymId);
    
    urlString = [NSString stringWithFormat:@"%@?corporationid=%@", urlString, gymId];
    NSLog(@"get gym places by id : %@", urlString);
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        //        [ZJModelTool createModelWithDictionary:responseObject modelName:nil];
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"message : %@", responseDic[@"message"]);
        NSArray *array = responseDic[@"data"];
        if (array && array != (id)[NSNull null]) {
            option(array);
        }
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        option(nil);
    }];
}

//获取场地的使用信息
+ (void)getGymPlaceUsingInfoById:(NSString *)gymId andTimestamp:(NSString *)timestamp andOption:(void (^)(NSArray *array))option{
    NSString *urlString = [FTNetConfig host:Domain path:GetGymPlacesUsingInfoByIdURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    assert(gymId);
    
    urlString = [NSString stringWithFormat:@"%@?corporationid=%@&date=%@", urlString, gymId, timestamp];
    
    NSLog(@"getGymPlaceUsingInfoById %@", urlString);
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"message : %@", responseDic[@"message"]);
        NSArray *array = responseDic[@"data"];
        if (array && array != (id)[NSNull null]) {
            option(array);
        }
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        option(nil);
    }];
}
+ (void)getGymSourceInfoById:(NSString *)gymId andTimestamp:(NSString *)timestamp andOption:(void (^)(NSArray *array))option{
    NSString *urlString = [FTNetConfig host:Domain path:GetGymSourceInfoByIdURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    assert(gymId);
    FTUserBean *localUserBean = [FTUserTools getLocalUser];
    urlString = [NSString stringWithFormat:@"%@?corporationid=%@&userId=%@", urlString, gymId, localUserBean.olduserid];
    
    NSLog(@"getGymPlaceUsingInfoById %@", urlString);
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"message : %@", responseDic[@"message"]);
        NSArray *array = responseDic[@"data"];
        if (array && array != (id)[NSNull null]) {
            option(array);
        }else{
            option(nil);
        }
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        option(nil);
    }];
}

//获取教练课程信息
+ (void)getCoachCourceInfoByCoachId:(NSString *)coachId andGymId:(NSString *)gymId andOption:(void (^)(NSArray *array))option{
    NSString *urlString = [FTNetConfig host:Domain path:GetCoachCourceInfoByIdURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    assert(gymId);
    FTUserBean *localUserBean = [FTUserTools getLocalUser];
    urlString = [NSString stringWithFormat:@"%@?corporationid=%@&userId=%@&coachUserId=%@", urlString, gymId, localUserBean.olduserid, coachId];
    
    NSLog(@"getGymPlaceUsingInfoById %@", urlString);
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"message : %@", responseDic[@"message"]);
        NSArray *array = responseDic[@"data"];
        if (array && array != (id)[NSNull null]) {
            option(array);
        }
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        option(nil);
    }];
}

//获取拳馆信息
+ (void)getGymInfoById:(NSString *)corporationID andOption:(void (^)(NSDictionary *dic))option{
    NSString *urlString = [FTNetConfig host:Domain path:GetGymInfoByIdURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    assert(corporationID);
    urlString = [NSString stringWithFormat:@"%@?corporationid=%@", urlString, corporationID];
    
//    NSLog(@"getGymInfoById %@", urlString);
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"message : %@", responseDic[@"message"]);
        NSDictionary *dic = responseDic[@"data"];
        if (dic && dic != (id)[NSNull null]) {
            option(dic);
        }else{
            option(nil);
        }
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        option(nil);
    }];
}

//获取拳手列表
+ (void)getBoxerListByWeight:(NSString *)weight andOverWeightLevel: (NSString *) overWeightLevel andPageSize:(NSString *)pageSize andPageNum:(int)pageNum andOption:(void (^)(NSArray *array))option{
    NSString *urlString = [FTNetConfig host:Domain path:GetBoxerListURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    assert(weight);
    urlString = [NSString stringWithFormat:@"%@?weight=%@&weightLevel=%@&pageSize=%@&pageNum=%d", urlString, weight, overWeightLevel, pageSize, pageNum];
    
    //    NSLog(@"getGymInfoById %@", urlString);
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"message : %@", responseDic[@"message"]);
        NSArray *array = responseDic[@"data"];
        if (array && array != (id)[NSNull null]) {
            option(array);
        }
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        option(nil);
    }];
}

//添加赛事
+ (void)addMatchWithParams:(NSDictionary *)dic andOption:(void (^)(BOOL result))option{
    NSString *urlString = [FTNetConfig host:Domain path:AddMatchURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //    NSLog(@"getGymInfoById %@", urlString);
    [manager POST:urlString parameters:dic progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString *status = responseDic[@"status"];
        NSLog(@"message : %@", responseDic[@"message"]);
        if ([status isEqualToString:@"success"]) {
            option(true);
        }else{
            option(false);
        }
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        option(nil);
    }];
}

//添加赛事
+ (void)responseToMatchWithParamDic:(NSDictionary *)dic andOption:(void (^)(BOOL result))option{
    NSString *urlString = [FTNetConfig host:Domain path:ResponseToMatchURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //    NSLog(@"getGymInfoById %@", urlString);
    [manager POST:urlString parameters:dic progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString *status = responseDic[@"status"];
        NSLog(@"message : %@", responseDic[@"message"]);
        if ([status isEqualToString:@"success"]) {
            option(true);
        }else{
            option(false);
        }
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        option(nil);
    }];
}
//格斗场 - 微信支付（下注）
+ (void)WXpayWithParamDic:(NSDictionary *)dic andOption:(void (^)(NSDictionary *dic))option{
    NSString *urlString = [FTNetConfig host:Domain path:WXPayURL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //    NSLog(@"getGymInfoById %@", urlString);
    [manager POST:urlString parameters:dic progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString *status = responseDic[@"status"];
        NSLog(@"message : %@", responseDic[@"message"]);
        if ([status isEqualToString:@"success"]) {
            NSDictionary *dic = responseDic[@"data"];
            
            option(dic);
        }else{
            option(nil);
        }
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        option(nil);
    }];
}

+ (void)getMatchListWithPageNum:(int)pageNum andPageSize:(NSString *)pageSize andStatus:(NSString *)status andPayStatus:(NSString *)payStatus andLabel:(NSString *)label andAgainstId:(NSString *)againstId andWeight:(NSString *)weight andUserId:(NSString *)userId andOption:(void(^) (NSArray *array))option{
    NSString *urlString = [FTNetConfig host:Domain path:GetMatchListURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    urlString = [NSString stringWithFormat:@"%@?pageNum=%d&pageSize=%@&statu=%@&payStatu=%@&label=%@&againstId=%@&weight1=%@&currentUserId=%@", urlString, pageNum, pageSize, status, payStatus, label, againstId, weight, userId];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"message : %@", responseDic[@"message"]);
        NSArray *array = responseDic[@"data"];
        if (array && array != (id)[NSNull null]) {
            option(array);
        }else{
            option(nil);
        }
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        option(nil);
    }];
}
//获取拳馆详细信息(比赛模块用到的拳馆)
+ (void)getGymDetailWithGymId:(NSString *)gymId andOption:(void (^)(NSArray *array))option{
    NSString *urlString = [NSString stringWithFormat:@"%@/api/match/%@.do", Domain, gymId];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"message : %@", responseDic[@"message"]);
        NSString *status = responseDic[@"status"];
        if ([status isEqualToString:@"success"]) {
            NSArray *array = responseDic[@"data"];
            if (array && array != (id)[NSNull null]) {
                option(array);
            }
        } else {
            option(nil);
        }

    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        option(nil);
    }];
}
//获取拳馆详细信息（学拳模块的拳馆 ）
+ (void)getGymForGymDetailWithGymId:(NSString *)gymId andOption:(void (^)(NSDictionary *dic))option{
    NSString *urlString = [NSString stringWithFormat:@"%@/api/gym/%@.do", Domain, gymId];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"message : %@", responseDic[@"message"]);
        NSString *status = responseDic[@"status"];
        if ([status isEqualToString:@"success"]) {
            NSDictionary *dic = responseDic[@"data"];
            if (dic) {
                option(dic);
            }
        } else {
            option(nil);
        }
        
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        option(nil);
    }];
}

//根绝拳馆id获取拳馆的所有教练
+ (void)getCoachesWithCorporationid:(NSString *)corporationid andOption:(void (^)(NSArray *array))option{
    NSString *urlString = [FTNetConfig host:Domain path:GetCoachListURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    urlString = [NSString stringWithFormat:@"%@?corporationid=%@", urlString, corporationid];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"message : %@", responseDic[@"message"]);
        NSString *status = responseDic[@"status"];
        if ([status isEqualToString:@"success"]) {
            NSArray *array = responseDic[@"data"];
            if (array && array != (id)[NSNull null]) {
                option(array);
            }
        } else {
            option(nil);
        }
        
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        option(nil);
    }];
}
//验证验证码是否正确（请求加入会员部分）
+ (void)validCheckCodeWithPhoneNum:(NSString *) phoneNum andCheckCode:(NSString *)checkCode andOption:(void (^)(NSDictionary *dic))option{
    NSString *urlString = [FTNetConfig host:Domain path:ValidCheckCode];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    //获取当前登录用户的信息
    FTUserBean *userBean = [FTUserTools getLocalUser];
    NSString *userId = userBean.olduserid;//当前用户id
    NSString *loginToken = userBean.token;//当前用户的login token
    NSString *ts = [NSString stringWithFormat:@"%lf", [[NSDate date] timeIntervalSince1970]];
    
    //md5前的checkSign字典
    NSMutableDictionary *dicBeforeMD5 = [[NSMutableDictionary alloc]initWithDictionary:@{
                                                                                         @"userId":userId,
                                                                                         @"phone" : phoneNum,
                                                                                         @"checkCode" : checkCode,
                                                                                         @"type" : @"gymmenbership",
                                                                                         @"loginToken":loginToken,
                                                                                         @"ts":ts}];
    NSString *checkSign = [FTTools md5Dictionary:dicBeforeMD5 withCheckKey:@"gedoujiahghfkd25gfd"];
    [dicBeforeMD5 setValue:checkSign forKey:@"checkSign"];
    NSDictionary *parmamDic = dicBeforeMD5;
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:urlString parameters:parmamDic progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"message : %@", responseDic[@"message"]);
        if (responseDic) {
            option(responseDic);
        }
        
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        option(nil);
    }];
}
//请求加入会员
+ (void)requestToBeVIPWithCorporationid:(NSString *)corporationid andPhoneNum:(NSString *) phoneNum andCheckCode:(NSString *)checkCode andOption:(void (^)(NSDictionary *dic))option{
    NSString *urlString = [FTNetConfig host:Domain path:BecomeGymMenberShipURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    //获取当前登录用户的信息
    FTUserBean *userBean = [FTUserTools getLocalUser];
    NSString *userId = userBean.olduserid;//当前用户id
    NSString *loginToken = userBean.token;//当前用户的login token
    NSString *ts = [NSString stringWithFormat:@"%lf", [[NSDate date] timeIntervalSince1970]];
    
    //md5前的checkSign字典
    NSMutableDictionary *dicBeforeMD5 = [[NSMutableDictionary alloc]initWithDictionary:@{
                                                                                         @"corporationid":corporationid,
                                                                                         @"userId":userId,
                                                                                         @"loginToken":loginToken,
                                                                                         @"ts":ts}];
    NSString *checkSign = [FTTools md5Dictionary:dicBeforeMD5 withCheckKey:@"gedoujiahtfht2g2rd"];
    [dicBeforeMD5 setValue:checkSign forKey:@"checkSign"];
    NSDictionary *parmamDic = dicBeforeMD5;
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:urlString parameters:parmamDic progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"message : %@", responseDic[@"message"]);
        if (responseDic) {
            option(responseDic);
        }
        
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        option(nil);
    }];
}

//根绝拳馆id获取拳馆的所有照片（用户上传的）
+ (void)getPhotosByUsersWithCorporationid:(NSString *)corporationid andOption:(void (^)(NSArray *array))option{
    NSString *urlString = [FTNetConfig host:Domain path:GetGymPhotosByUsers];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    urlString = [NSString stringWithFormat:@"%@?objId=%@", urlString, corporationid];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"message : %@", responseDic[@"message"]);
        NSString *status = responseDic[@"status"];
        if ([status isEqualToString:@"success"]) {
            NSArray *array = responseDic[@"data"];
            if (array && array != (id)[NSNull null]) {
                option(array);
            }
        } else {
            option(nil);
        }
        
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        option(nil);
    }];
}

+ (void)addViewCountWithObjid:(NSString *)objId andTableName:(NSString *)tableName andOption:(void (^)(BOOL result))option{
    //获取网络请求地址url
    NSString *addViewCountUrlString = [FTNetConfig host:Domain path:AddViewCountURL];
    
    addViewCountUrlString = [NSString stringWithFormat:@"%@?&objId=%@&tableName=%@", addViewCountUrlString, objId, tableName];
    NSLog(@"addViewCountUrlString : %@", addViewCountUrlString);
    //创建AAFNetWorKing管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSLog(@"addViewCountUrlString : %@", addViewCountUrlString);
    [manager GET:addViewCountUrlString parameters:nil progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([responseDic[@"status"] isEqualToString:@"success"]) {
            option(YES);
        }else{
            option(NO);
        }
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        option(NO);
        NSLog(@"向服务器增加观看数失败，error：%@", error);
    }];
}
//获取点赞数
+ (void)getViewCountWithObjid:(NSString *)objId andTableName:(NSString *)tableName andOption:(void (^)(NSString *viewCount))option{
    //获取网络请求地址url
    NSString *getViewCountUrlString = [FTNetConfig host:Domain path:GetObjViewCountURL];
    
    getViewCountUrlString = [NSString stringWithFormat:@"%@?&objId=%@&tableName=%@", getViewCountUrlString, objId, tableName];
    NSLog(@"addViewCountUrlString : %@", getViewCountUrlString);
    //创建AAFNetWorKing管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSLog(@"addViewCountUrlString : %@", getViewCountUrlString);
    [manager GET:getViewCountUrlString parameters:nil progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([responseDic[@"status"] isEqualToString:@"success"]) {
            NSString *viewCount = responseDic[@"data"];
            option(viewCount);
        }else{
            option(nil);
        }
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        option(nil);
        NSLog(@"向服务器增加观看数失败，error：%@", error);
    }];
}
//获取点赞数
+ (void)getCountWithObjid:(NSString *)objId andTableName:(NSString *)tableName andOption:(void (^)(NSString *viewCount))option{
    //获取网络请求地址url
    NSString *getViewCountUrlString = [FTNetConfig host:Domain path:GetObjVoteCountURL];
    getViewCountUrlString = [NSString stringWithFormat:@"%@?objId=%@&tableName=%@", getViewCountUrlString, objId, tableName];
    NSLog(@"addViewCountUrlString : %@", getViewCountUrlString);
    //创建AAFNetWorKing管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSLog(@"addViewCountUrlString : %@", getViewCountUrlString);
    [manager GET:getViewCountUrlString parameters:nil progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([responseDic[@"status"] isEqualToString:@"success"]) {
            NSString *viewCount = responseDic[@"data"];
            option(viewCount);
        }else{
            option(nil);
        }
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        option(nil);
        NSLog(@"向服务器增加观看数失败，error：%@", error);
    }];
}
//点赞
+ (void)addVoteWithObjid:(NSString *)objId isAdd:(BOOL)isAdd andTableName:(NSString *)tableName andOption:(void (^)(BOOL result))option{
    
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *user = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    //获取网络请求地址url
    NSString *urlString = [FTNetConfig host:Domain path:isAdd ? AddVoteURL : DeleteVoteURL];
    
    NSString *userId = user.olduserid;

    NSString *loginToken = user.token;
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];

    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@%@", loginToken, objId, tableName, ts, userId, isAdd ? AddVoteCheckKey: DeleteVoteCheckKey]];
    
    
    urlString = [NSString stringWithFormat:@"%@?userId=%@&objId=%@&loginToken=%@&ts=%@&checkSign=%@&tableName=%@", urlString, userId, objId, loginToken, ts, checkSign, tableName];
    //    NSLog(@"%@ : %@", self.hasVote ? @"增加" : @"删除", urlString);
    //创建AAFNetWorKing管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"vote status : %@", responseDic[@"status"]);
        if ([responseDic[@"status"] isEqualToString:@"success"]) {//如果点赞信息更新成功后，处理本地的赞数，并更新webview
            option(true);
        }else{
            option(false);
        }
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        //failure
        NSLog(@"vote failure ：%@", error);
        option(nil);
    }];
}
//获取点赞状态
+ (void)getVoteStatusWithObjid:(NSString *)objId andTableName:(NSString *)tableName andOption:(void (^)(BOOL result))option{
    
    FTUserBean *user = [FTUserBean loginUser];
    //获取网络请求地址url
    NSString *urlString = [FTNetConfig host:Domain path:GetStateURL];
    
    NSString *userId = user.olduserid;
    
    NSString *loginToken = user.token;
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@%@", loginToken, objId, tableName, ts, userId, GetStatusCheckKey]];
    
    
    urlString = [NSString stringWithFormat:@"%@?userId=%@&objId=%@&loginToken=%@&ts=%@&checkSign=%@&tableName=%@", urlString, userId, objId, loginToken, ts, checkSign, tableName];
    //    NSLog(@"%@ : %@", self.hasVote ? @"增加" : @"删除", urlString);
    //创建AAFNetWorKing管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"vote status : %@", responseDic[@"status"]);
        if ([responseDic[@"message"] isEqualToString:@"true"]) {
            option(true);
        }else{
            option(false);
        }
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        //failure
        NSLog(@"vote failure ：%@", error);
        option(nil);
    }];
}
//下注
+ (void)betWithMatchBean:(FTMatchBean *)_matchBean andIsPlayer1Win:(BOOL )isPlayer1Win andBetValue:(int )betValue andOption:(void (^)(BOOL result))option{
    
    //获取当前登录用户的信息
    FTUserBean *userBean = [FTUserTools getLocalUser];
    NSString *userId = userBean.olduserid;//当前用户id
    NSString *objType = @"match";//类型
    NSString *objId = [NSString stringWithFormat:@"%@", _matchBean.matchId];//比赛id
    NSString *tableName = @"pl-bet";//表名：1. 下注为：pl-bet； 2. 购票为：pl-tic 3. 赛事成本支付相关：pl-mat
    NSString *type = isPlayer1Win ? @"0" : @"1";//1. 下注（0- 投注发起方，默认；1-投注迎战方）;
    NSString *isDelated = @"2";//0-无效记录；1-s支付；2-p支付;3-RMB元支付(默认为元)
    NSString *money_p = [NSString stringWithFormat:@"%d", betValue];
    NSString *payWay = @"0";//默认为0-积分支付； 值为1-微信支付
    NSString *loginToken = userBean.token;//当前用户的login token
    NSString *ts = [NSString stringWithFormat:@"%lf", [[NSDate date] timeIntervalSince1970]];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"];
    NSLog(@"deviceToken : %@", deviceToken);
    
    //md5前的checkSign字典
    NSMutableDictionary *dicBeforeMD5 = [[NSMutableDictionary alloc]initWithDictionary:@{
                                                                                         @"userId":userId,
                                                                                         @"isDelated" : isDelated,
                                                                                         @"objType":objType,
                                                                                         @"objId":objId,
                                                                                         @"tableName":tableName,
                                                                                         @"type":type,
                                                                                         @"money_p":money_p,
                                                                                         @"payWay":payWay,
                                                                                         @"loginToken":loginToken,
                                                                                         @"token":deviceToken,
                                                                                         @"ts":ts}];
    NSString *checkSign = [FTTools md5Dictionary:dicBeforeMD5 withCheckKey:@"gedoujiahdggrdearyhreayt251grd"];
    [dicBeforeMD5 setValue:checkSign forKey:@"checkSign"];
    NSDictionary *parmamDic = dicBeforeMD5;
    [NetWorking WXpayWithParamDic:parmamDic andOption:^(NSDictionary* dic) {
        if (dic) {
            option(YES);
        } else {
            option(NO);
        }
    }];

}
//关注
+ (void)followObjWithObjId:(NSString *)objId anIsFollow:(BOOL)isFollow andTableName:(NSString *)tableName andOption:(void (^)(BOOL result))option{
    
    
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *user = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    //获取网络请求地址url
    NSString *urlString = [FTNetConfig host:Domain path:isFollow ? FollowURL : CancelFollowURL];
    
    NSString *userId = user.olduserid;
    NSString *loginToken = user.token;
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"];

//    NSString *checkSign = [NSString stringWithFormat:@"%@%@%@%@%@%@%@", deviceToken, loginToken, objId, tableName, ts, userId, isFollow ? FollowCheckKey: CancelFollowCheckKey];
//    NSLog(@"check sign : %@", checkSign);
//    checkSign = [MD5 md5:checkSign];
    
    
    
    //md5前的checkSign字典
    NSMutableDictionary *dicBeforeMD5 = [[NSMutableDictionary alloc]initWithDictionary:@{
                                                                                         @"userId":userId,
                                                                                         @"objId":objId,
                                                                                         @"tableName":tableName,
                                                                                         @"loginToken":loginToken,
                                                                                         @"token":deviceToken,
                                                                                         @"ts":ts}];
    NSString *checkSign = [FTTools md5Dictionary:dicBeforeMD5 withCheckKey:isFollow ? FollowCheckKey: CancelFollowCheckKey];
    [dicBeforeMD5 setValue:checkSign forKey:@"checkSign"];
    NSDictionary *parmamDic = dicBeforeMD5;
    
//    urlString = [NSString stringWithFormat:@"%@?userId=%@&objId=%@&loginToken=%@&ts=%@&checkSign=%@&tableName=%@&token=%@", urlString, userId, objId, loginToken, ts, checkSign, tableName, deviceToken];
    //    NSLog(@"%@ : %@", self.hasVote ? @"增加" : @"删除", urlString);
    //创建AAFNetWorKing管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSLog(@"收藏url：%@", urlString);
    [manager POST:urlString parameters:parmamDic progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"收藏状态 status : %@, message : %@", responseDic[@"status"], responseDic[@"message"]);

        if ([responseDic[@"status"] isEqualToString:@"success"]) {//如果点赞信息更新成功后，处理本地的赞数，并更新webview
            option(YES);
        }else{
            option(NO);
        }
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        option(NO);
        NSLog(@"收藏 failure ：%@", error);
    }];
    

    
}

#pragma mark - 充值购买

// 查询余额
+ (void) queryMoneyWithOption:(void (^)(NSDictionary *dict))option  {
    
    NSString *urlString = [FTNetConfig host:Domain path:QueryMoneyURL];
    
    // 时间戳
    NSString *ts = [NSString stringWithFormat:@"%.0f",([[NSDate date] timeIntervalSince1970]*1000.0f)];;
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@",localUser.olduserid, localUser.token, ts,@"quanjijia222222"]];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:localUser.olduserid forKey:@"userId"];
    [dic setObject:localUser.token forKey:@"loginToken"];
    [dic setObject:ts forKey:@"ts"];
    [dic setObject:checkSign forKey:@"checkSign"];
    
    NSLog(@"dic:%@",dic);
    [self postRequestWithUrl:urlString
                  parameters:dic
                      option:option];
    
    
}
// 分享后回调赠送积分接口
+ (void) getPointByShareWithPlatform:(NSString *)platform option:(void (^)(NSDictionary *dict))option{
    NSString *urlString = [FTNetConfig host:Domain path:ExtensionTaskURL];
    
    // 时间戳
    NSString *ts = [NSString stringWithFormat:@"%.0f",([[NSDate date] timeIntervalSince1970]*1000.0f)];;
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@",localUser.olduserid, localUser.token,platform,ts,@"quanjijia222222"]];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:localUser.olduserid forKey:@"userId"];
    [dic setObject:localUser.token forKey:@"loginToken"];
    [dic setObject:ts forKey:@"ts"];
    [dic setObject:platform forKey:@"platform"];
    [dic setObject:checkSign forKey:@"checkSign"];
    
    [self postRequestWithUrl:urlString
                  parameters:dic
                      option:option];
}


// 是否已经购买视频接口
+ (void) checkBuyVideoById:(NSString *)videoId option:(void (^)(NSDictionary *dict))option {
    
    NSString *urlString = [FTNetConfig host:Domain path:IsBuyVideoDoneURL];
    
    // 时间戳
    NSString *ts = [NSString stringWithFormat:@"%.0f",([[NSDate date] timeIntervalSince1970]*1000.0f)];;
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@",localUser.olduserid, localUser.token,videoId,ts,@"quanjijia222222"]];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:localUser.olduserid forKey:@"userId"];
    [dic setObject:localUser.token forKey:@"loginToken"];
    [dic setObject:ts forKey:@"ts"];
    [dic setObject:videoId forKey:@"videoId"];
    [dic setObject:checkSign forKey:@"checkSign"];
    
    [self postRequestWithUrl:urlString
                  parameters:dic
                      option:option];
}

// 购买视频接口
+ (void) buyVideoById:(NSString *)videoId option:(void (^)(NSDictionary *dict))option {

    NSString *urlString = [FTNetConfig host:Domain path:BuyVideoURL];
    
    // 时间戳
    NSString *ts = [NSString stringWithFormat:@"%.0f",([[NSDate date] timeIntervalSince1970]*1000.0f)];;
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@",localUser.olduserid, localUser.token,videoId,ts,@"quanjijia222222"]];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:localUser.olduserid forKey:@"userId"];
    [dic setObject:localUser.token forKey:@"loginToken"];
    [dic setObject:ts forKey:@"ts"];
    [dic setObject:videoId forKey:@"videoId"];
    [dic setObject:checkSign forKey:@"checkSign"];
    
    [self postRequestWithUrl:urlString
                  parameters:dic
                      option:option];

}


// 获取视频Url接口
+ (void) getVideoUrlById:(NSString *)videoId buyToken:(NSString *)buyToken option:(void(^)(NSDictionary *dict))option {

    NSString *urlString = [FTNetConfig host:Domain path:GetBuyVideoURL];
    
    // 时间戳
    NSString *ts = [NSString stringWithFormat:@"%.0f",([[NSDate date] timeIntervalSince1970]*1000.0f)];;
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@",localUser.olduserid, localUser.token,videoId,ts,@"quanjijia222222"]];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:localUser.olduserid forKey:@"userId"];
    [dic setObject:localUser.token forKey:@"loginToken"];
    [dic setObject:ts forKey:@"ts"];
    [dic setObject:videoId forKey:@"videoId"];
    [dic setObject:buyToken forKey:@"buyToken"];
    [dic setObject:checkSign forKey:@"checkSign"];
    
    [self postRequestWithUrl:urlString
                  parameters:dic
                      option:option];
}


// 验证app内购接口
+ (void) checkIAPByOrderNO:(NSString *)orderNO receipt:(NSString *) receipt transactionId:(NSString*)transactionId option:(void(^)(NSDictionary *dict))option {
    
    
    
    NSString *urlString = [FTNetConfig host:Domain path:CheckIAPURL];
    NSLog(@"urlString:%@",urlString);
    
    // 时间戳
    NSString *ts = [NSString stringWithFormat:@"%.0f",([[NSDate date] timeIntervalSince1970]*1000.0f)];;
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@%@%@",localUser.olduserid, localUser.token,orderNO,transactionId,receipt,ts,@"quanjijia222222"]];
    
    NSString *urlEncodeReceipt = [FTEncoderAndDecoder encodeToPercentEscapeString:receipt];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:localUser.olduserid forKey:@"userId"];
    [dic setObject:localUser.token forKey:@"loginToken"];
    [dic setObject:orderNO forKey:@"orderNo"];
    [dic setObject:transactionId forKey:@"transaction_id"];
    [dic setObject:urlEncodeReceipt forKey:@"receiptData"];
    [dic setObject:ts forKey:@"ts"];
    [dic setObject:checkSign forKey:@"checkSign"];
    NSLog(@"dic:%@",dic);
    
    [self postRequestWithUrl:urlString
                  parameters:dic
                      option:option];
}

// app内购预支付接口
+ (void) rechargeIAPByGoods:(FTGoodsBean *)goodsBean  option:(void(^)(NSDictionary *dict))option {
    
    NSString *urlString = [FTNetConfig host:Domain path:RechargeIAPURL];
    NSLog(@"urlString:%@",urlString);
    
    // 时间戳
    NSString *ts = [NSString stringWithFormat:@"%.0f",([[NSDate date] timeIntervalSince1970]*1000.0f)];;
    // 生成一个UUID
    NSString *imei= [UUID getUUID];
    
    //商品信息
    NSString *goodsTag = goodsBean.goodsId;// 商品标签
    NSString * body = goodsBean.descriptions;// 商品简书，限制长度28
    NSString *detail = goodsBean.details;// 商品详细简述
//    NSDecimalNumber *fee = goodsBean.price; // 商品价格
    NSDecimalNumber *fee = goodsBean.power; // 商品对应Power币
    
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",localUser.olduserid, localUser.token,imei,body,detail,fee,goodsTag,ts,@"quanjijia222222"]];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:localUser.olduserid forKey:@"userId"];
    [dic setObject:localUser.token forKey:@"loginToken"];
    [dic setObject:imei forKey:@"device_info"];
    [dic setObject:body forKey:@"body"];
    [dic setObject:detail forKey:@"detail"];
    [dic setObject:fee forKey:@"total_fee"];
    [dic setObject:goodsTag forKey:@"goods_tag"];
    [dic setObject:ts forKey:@"ts"];
    [dic setObject:checkSign forKey:@"checkSign"];
    NSLog(@"dic:%@",dic);
    
    [self postRequestWithUrl:urlString
                  parameters:dic
                      option:option];
}


#pragma mark - 微信支付
// 微信支付
+ (void)wxPayWithParamDic:(NSDictionary *)dic andOption:(void (^)(NSDictionary *dic))option {
    NSString *urlString = [FTNetConfig host:Domain path:WXPayURL];//GetWXPayStatus
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //    NSLog(@"getGymInfoById %@", urlString);
    [manager POST:urlString parameters:dic progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString *status = responseDic[@"status"];
        NSLog(@"message : %@", responseDic[@"message"]);
        if ([status isEqualToString:@"success"]) {
            NSDictionary *dic = responseDic[@"data"];
            
            option(dic);
        }else{
            option(nil);
        }
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        option(nil);
    }];
    
    [self postRequestWithUrl:urlString parameters:dic option:option];
}

// 微信支付结果查询
+ (void)wxPayStatusWithOrderNO:(NSString *)orederNO andOption:(void (^)(NSDictionary *dic))option {
    
   
    FTUserBean *localUser = [FTUserBean loginUser];
    
    if (!localUser) {
        return;
    }
    
    NSString *urlString = [FTNetConfig host:Domain path:GetWXPayStatus];//
    
    NSString *orderNo = orederNO;
    NSString *userId = localUser.olduserid;
    NSString *token = localUser.token;
    // 时间戳
    NSString *ts = [NSString stringWithFormat:@"%.0f",([[NSDate date] timeIntervalSince1970]*1000.0f)];;
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@",token, orderNo,ts,userId,@"gedoujiagfdshgdfhlkgfkhgf526gfrd"]];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:orderNo forKey:@"out_trade_no"];
    [dic setObject:userId forKey:@"userId"];
    [dic setObject:token forKey:@"loginToken"];
    [dic setObject:ts forKey:@"ts"];
    [dic setObject:checkSign forKey:@"checkSign"];
    
    [self postRequestWithUrl:urlString parameters:dic option:option];
}

#pragma mark - 获取标签
// 获取教学视频标签
+ (void) getTeachLabelsWithOption:(void(^)(NSDictionary *dict))option {

    NSString *getCategoryUrlString = [FTNetConfig host:Domain path:GetCategoryURL];
    NSLog(@"getCategoryUrlString : %@", getCategoryUrlString);
    NSDictionary *dic = @{@"nameEn": @"teachVideo"};
    
    [self postRequestWithUrl:getCategoryUrlString parameters:dic option:option];

}

#pragma mark - 兑吧

//  获取兑吧地址
+ (void) getDuibaUrl:(void (^)(NSDictionary *dict))option {

    NSString *getDuiBaURLString = [FTNetConfig host:Domain path:DuiBaURL];
    
    // 时间戳
    NSString *ts = [NSString stringWithFormat:@"%.0f",([[NSDate date] timeIntervalSince1970]*1000.0f)];;
    
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    
    if (!localUser) {
        return;
    }
    
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@",localUser.olduserid, localUser.token,ts,@"gedoudongxi160805"]];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:localUser.olduserid forKey:@"userid"];
    [dic setObject:localUser.token forKey:@"loginToken"];
    [dic setObject:ts forKey:@"ts"];
    [dic setObject:checkSign forKey:@"checkSign"];
    
    NSLog(@"dic:%@",dic);
    [self getRequestWithUrl:getDuiBaURLString parameters:dic option:option];
}

//  获取兑吧地址
+ (void) GetDuiBaConfig:(void (^)(NSDictionary *dict))option {
    NSString *getDuiBaConfigString = [FTNetConfig host:Domain path:DuiBaConfigURL];
    NSString *configName = @"show_shop";
    // 时间戳
    NSString *ts = [NSString stringWithFormat:@"%.0f",([[NSDate date] timeIntervalSince1970]*1000.0f)];;
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@",ts,@"gedoudongxi125689"]];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:configName forKey:@"configName"];
    [dic setObject:ts forKey:@"ts"];
    [dic setObject:checkSign forKey:@"checkSign"];
    
    NSLog(@"dic:%@",dic);
    
    [self getRequestWithUrl:getDuiBaConfigString parameters:dic option:option];
}



+ (void)getVIPInfoWithGymId:(NSString *) corporationID andOption:(void (^)(NSDictionary *dic))option{
    NSString *urlString = [FTNetConfig host:Domain path:GetGymVIPInfoURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    urlString = [NSString stringWithFormat:@"%@?corporationid=%@&userId=%@&", urlString, corporationID, [FTUserTools getLocalUser].olduserid];
    NSLog(@"getGymTimeSlotsById urlString : %@", urlString);
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        //        [ZJModelTool createModelWithDictionary:responseObject modelName:nil];
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"message : %@", responseDic[@"message"]);
//        NSDictionary *dic = responseDic[@"data"];
        if (responseDic && responseDic != (id)[NSNull null]) {
            option(responseDic);
        }else{
            option(nil);
        }
    } failure:^(NSURLSessionTask * _Nonnull task, NSError * _Nonnull error) {
        option(nil);
    }];
}

+ (NSString *)getUserId{
    return [FTUserTools getLocalUser].olduserid;
}

+ (NSString *)getLoginToken{
    return [FTUserTools getLocalUser].token;
}

+ (NSString *)getTimeStamp13{
    return [NSString stringWithFormat:@"%lf", [[NSDate date] timeIntervalSince1970] * 1000];
}

//约课
+ (void)orderCourseWithParamsDic:(NSMutableDictionary *)dic andOption:(void (^)(NSDictionary *dic))option{
    NSString *path;
    NSString *checkKey;
    NSString *bookType = dic[@"bookType"];
    if ([bookType isEqualToString:@"save"]) {
        path = OrderCourseURL;
        checkKey = SaveCourseBookCheckSign;
    } else if ([bookType isEqualToString:@"delete"]) {
        path = DeleteOrderCourseURL;
        checkKey = DeleteCourseBookCheckSign;
    }
    NSString *urlString = [FTNetConfig host:Domain path:path];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //md5前的checkSign字典
    NSMutableDictionary *dicBeforeMD5 = [[NSMutableDictionary alloc]initWithDictionary:@{
                                                                                         @"userId":[NetWorking getUserId],
                                                                                         @"corporationid" : dic[@"gymId"],
                                                                                         @"date" : dic[@"date"],
                                                                                         @"timeId" : dic[@"timeId"],
                                                                                         @"timeSection" : dic[@"timeSection"],
                                                                                         @"loginToken":[self getLoginToken],
//                                                                                         @"courseId" : dic[@"courseId"],
                                                                                         @"type" : dic[@"type"],
                                                                                         @"ts":[self getTimeStamp13]}];
    NSString *courseId = dic[@"courseId"];//课程id，团课必填
    if(courseId){
        [dicBeforeMD5 setObject:courseId forKey:@"courseId"];
    }
    
    NSString *coachUserId = dic[@"coachUserId"];//教练id，私教课必填
    if(coachUserId){
        [dicBeforeMD5 setObject:coachUserId forKey:@"coachUserId"];
    }
    
    NSString *fenString = dic[@"price"];//教练id，私教课必填
    if(fenString){
        [dicBeforeMD5 setObject:fenString forKey:@"price"];
    }
    
    NSString *checkSign = [FTTools md5Dictionary:dicBeforeMD5 withCheckKey:checkKey];
    [dicBeforeMD5 setValue:checkSign forKey:@"checkSign"];
    NSDictionary *parmamDic = dicBeforeMD5;
    
    [manager POST:urlString parameters:parmamDic progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (responseDic && responseDic != (id)[NSNull null]) {
            option(responseDic);
        }else{
            option(nil);
        }
    } failure:^(NSURLSessionTask * _Nonnull task, NSError * _Nonnull error) {
        option(nil);
    }];
    
}

/**
 教练更改可约不可约状态

 @param dic    入参
 @param option block回掉
 */
+ (void)changeCourseStatusWithParamsDic:(NSMutableDictionary *)dic andOption:(void (^)(NSDictionary *dic))option{
    NSString *path;
    NSString *checkKey;
    
        path = ChangeCourseStatusURL;
        checkKey = ChangeCourseStatusCheckSign;
    
    NSString *urlString = [FTNetConfig host:Domain path:path];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //md5前的checkSign字典
    NSMutableDictionary *dicBeforeMD5 = [[NSMutableDictionary alloc]initWithDictionary:@{
                                                                                         @"userId":[NetWorking getUserId],
                                                                                         @"corporationid" : dic[@"gymId"],
                                                                                         @"date" : dic[@"date"],
                                                                                         @"timeId" : dic[@"timeId"],
                                                                                         @"timeSection" : dic[@"timeSection"],
                                                                                         @"loginToken":[self getLoginToken],
                                                                                       @"isDelated" : dic[@"isDelated"],
                                                                                         @"type" : dic[@"type"],
                                                                                         @"ts":[self getTimeStamp13]}];
    
    NSString *checkSign = [FTTools md5Dictionary:dicBeforeMD5 withCheckKey:checkKey];
    [dicBeforeMD5 setValue:checkSign forKey:@"checkSign"];
    NSDictionary *parmamDic = dicBeforeMD5;
    
    [manager POST:urlString parameters:parmamDic progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (responseDic && responseDic != (id)[NSNull null]) {
            option(responseDic);
        }else{
            option(nil);
        }
    } failure:^(NSURLSessionTask * _Nonnull task, NSError * _Nonnull error) {
        option(nil);
    }];
    
}
@end

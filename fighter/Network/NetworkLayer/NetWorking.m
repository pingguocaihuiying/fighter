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
    headpic = [FTEncoderAndDecoder encodeToPercentEscapeString:headpic];
    NSString *stemfrom = @"weixin";
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


#pragma mark - 封装请求---对象方法
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
//              NSLog(@"responsedic:%@",responseDic);
              
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
//              NSLog(@"responsedic:%@",responseDic);
              
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

#pragma mark - 封装请求---类方法
//post请求
+ (void) postRequestWithUrl:(NSString *)urlString
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
              //              NSLog(@"responsedic:%@",responseDic);
              
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
+ (void) postUploadDataWithURL:(NSString *)urlString
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
              //              NSLog(@"responsedic:%@",responseDic);
              
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
+ (void) getRequestWithUrl:(NSString *)urlString
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



#pragma mark - 个人主页

+ (void)getHomepageUserInfoWithUserOldid:(NSString *)userOldid andBoxerId:(NSString *)boxerId andCoachId:(NSString *)coachId andCallbackOption:(void (^)(FTUserBean *userBean))userBeanOption{
    NSString *urlString = [FTNetConfig host:Domain path:GetHomepageUserInfo];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
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
    }else{
        NSLog(@"没有id");
    }
    
    NSLog(@"urlString : %@", urlString);
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
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

        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"error : %@", error);
        
    }];
}

+ (void)getCommentsWithObjId:(NSString *)objId andTableName:(NSString *)tableName andOption:(void (^)(NSArray *))option{
    NSString *urlString = [FTNetConfig host:Domain path:GetCommentsURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    assert(objId);
    urlString = [NSString stringWithFormat:@"%@?objId=%@&tableName=%@", urlString, objId, tableName];
    //    NSLog(@"urlString : %@", urlString);
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //        [ZJModelTool createModelWithDictionary:responseObject modelName:nil];
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"message : %@", responseDic[@"message"]);
        NSArray *array = responseDic[@"data"];
        
        if (array && array != (id)[NSNull null]) {
            option(array);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        option(nil);
    }];
}
+ (void)getBoxerRaceInfoWithBoxerId:(NSString *)boxerId andOption:(void (^)(NSArray *array))option{
    NSString *urlString = [FTNetConfig host:Domain path:GetBoxerRaceInfoURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    assert(boxerId);
    urlString = [NSString stringWithFormat:@"%@?boxerId=%@", urlString, boxerId];
    //    NSLog(@"urlString : %@", urlString);
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //        [ZJModelTool createModelWithDictionary:responseObject modelName:nil];
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"message : %@", responseDic[@"message"]);
        NSArray *array = responseDic[@"data"];
        
        if (array && array != (id)[NSNull null]) {
            option(array);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        option(nil);
    }];
}
//获取单个拳讯信息
+ (void)getNewsById:(NSString *)newsId andOption:(void (^)(NSArray *array))option{
    NSString *urlString = [FTNetConfig host:Domain path:GetNewsByIdURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    assert(newsId);
    
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@", newsId, ts, @"quanjijia222222"]];
    urlString = [NSString stringWithFormat:@"%@?newsId=%@&ts=%@&checkSign=%@", urlString, newsId, ts, checkSign];
        NSLog(@"get news by id urlString : %@", urlString);
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //        [ZJModelTool createModelWithDictionary:responseObject modelName:nil];
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"message : %@", responseDic[@"message"]);
        NSArray *array = responseDic[@"data"];
        if (array && array != (id)[NSNull null]) {
            option(array);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        option(nil);
    }];
}

//获取单个视频信息
+ (void)getVideoById:(NSString *)videoId andOption:(void (^)(NSArray *array))option{
    NSString *urlString = [FTNetConfig host:Domain path:GetVideoByIdURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    assert(videoId);
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@", videoId, ts, @"quanjijia222222"]];
    urlString = [NSString stringWithFormat:@"%@?videosId=%@&ts=%@&checkSign=%@", urlString, videoId, ts, checkSign];
        NSLog(@"get video by id urlString : %@", urlString);
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //        [ZJModelTool createModelWithDictionary:responseObject modelName:nil];
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"message : %@", responseDic[@"message"]);
        NSArray *array = responseDic[@"data"];
        
        if (array && array != (id)[NSNull null]) {
            option(array);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
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

+ (void)getGymTimeSlotsById:(NSString *) gymId andOption:(void (^)(NSArray *array))option{
    NSString *urlString = [FTNetConfig host:Domain path:GetGymTimeSlotsByIdURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    assert(gymId);
    
    urlString = [NSString stringWithFormat:@"%@?corporationid=%@", urlString, gymId];
    NSLog(@"getGymTimeSlotsById urlString : %@", urlString);
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //        [ZJModelTool createModelWithDictionary:responseObject modelName:nil];
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"message : %@", responseDic[@"message"]);
        NSArray *array = responseDic[@"data"];
        if (array && array != (id)[NSNull null]) {
            option(array);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        option(nil);
    }];
}
//获取场地配置
+ (void)getGymPlaceInfoById:(NSString *)gymId andOption:(void (^)(NSArray *array))option{
    NSString *urlString = [FTNetConfig host:Domain path:GetGymPlacesByIdURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    assert(gymId);
    
    urlString = [NSString stringWithFormat:@"%@?corporationid=%@", urlString, gymId];
    NSLog(@"get gym places by id : %@", urlString);
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //        [ZJModelTool createModelWithDictionary:responseObject modelName:nil];
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"message : %@", responseDic[@"message"]);
        NSArray *array = responseDic[@"data"];
        if (array && array != (id)[NSNull null]) {
            option(array);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        option(nil);
    }];
}

//获取场地的使用信息
+ (void)getGymPlaceUsingInfoById:(NSString *)gymId andTimestamp:(NSString *)timestamp andOption:(void (^)(NSArray *array))option{
    NSString *urlString = [FTNetConfig host:Domain path:GetGymPlacesUsingInfoByIdURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    assert(gymId);
    
    urlString = [NSString stringWithFormat:@"%@?corporationid=%@&date=%@", urlString, gymId, timestamp];
    
    NSLog(@"getGymPlaceUsingInfoById %@", urlString);
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"message : %@", responseDic[@"message"]);
        NSArray *array = responseDic[@"data"];
        if (array && array != (id)[NSNull null]) {
            option(array);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        option(nil);
    }];
}

//获取拳馆信息
+ (void)getGymInfoById:(NSString *)gymId andOption:(void (^)(NSDictionary *dic))option{
    NSString *urlString = [FTNetConfig host:Domain path:GetGymInfoByIdURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    assert(gymId);
    urlString = [NSString stringWithFormat:@"%@?gym_corporationid=%@", urlString, gymId];
    
//    NSLog(@"getGymInfoById %@", urlString);
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"message : %@", responseDic[@"message"]);
        NSDictionary *dic = responseDic[@"data"];
        if (dic && dic != (id)[NSNull null]) {
            option(dic);
        }else{
            option(nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        option(nil);
    }];
}

//获取拳手列表
+ (void)getBoxerListByWeight:(NSString *)weight andOverWeightLevel: (NSString *) overWeightLevel andOption:(void (^)(NSArray *array))option{
    NSString *urlString = [FTNetConfig host:Domain path:GetBoxerListURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    assert(weight);
    urlString = [NSString stringWithFormat:@"%@?weight=%@&weightLevel=%@", urlString, weight, overWeightLevel];
    
    //    NSLog(@"getGymInfoById %@", urlString);
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"message : %@", responseDic[@"message"]);
        NSArray *array = responseDic[@"data"];
        if (array && array != (id)[NSNull null]) {
            option(array);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        option(nil);
    }];
}

//添加赛事
+ (void)addMatchWithParams:(NSDictionary *)dic andOption:(void (^)(BOOL result))option{
    NSString *urlString = [FTNetConfig host:Domain path:AddMatchURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //    NSLog(@"getGymInfoById %@", urlString);
    [manager POST:urlString parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString *status = responseDic[@"status"];
        NSLog(@"message : %@", responseDic[@"message"]);
        if ([status isEqualToString:@"success"]) {
            option(true);
        }else{
            option(false);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        option(nil);
    }];
}
+ (void)getMatchListWithPageNum:(int)pageNum andPageSize:(NSString *)pageSize andOption:(void(^) (NSArray *array))option{
    NSString *urlString = [FTNetConfig host:Domain path:GetMatchListURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    urlString = [NSString stringWithFormat:@"%@?pageNum=%d&pageSize=%@", urlString, pageNum, pageSize];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"message : %@", responseDic[@"message"]);
        NSArray *array = responseDic[@"data"];
        if (array && array != (id)[NSNull null]) {
            option(array);
        }else{
            option(nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        option(nil);
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

#pragma mark - 获取标签
// 获取教学视频标签
+ (void) getTeachLabelsWithOption:(void(^)(NSDictionary *dict))option {

    NSString *getCategoryUrlString = [FTNetConfig host:Domain path:GetCategoryURL];
    NSLog(@"getCategoryUrlString : %@", getCategoryUrlString);
    NSDictionary *dic = @{@"nameEn": @"teachVideo"};
    
    [self postRequestWithUrl:getCategoryUrlString parameters:dic option:option];

}

@end

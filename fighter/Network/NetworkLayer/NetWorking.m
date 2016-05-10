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


//获取短信验证码
- (void) getCheckCodeWithPhoneNumber:(NSString *)phoneNum option:(void (^)(NSDictionary *dict))option{
    
    NSString *urlString = [FTNetConfig host:Domain path:GetPhoneCodeURL];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:phoneNum forKey:@"phone"];
    
    [self postRequestWithUrl:urlString parameters:dic option:option];
    
}

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
    
    NSString *oldpassword = [NSString stringWithFormat:@"%@%@", oldpass, @"**#qwe"];
    NSString *newpossword =
     [NSString stringWithFormat:@"%@%@", newPass, @"**#qwe"];
    
    NSString *passOld =  [MD5 md5:oldpassword];
    NSString *passNew=  [MD5 md5:newpossword];
    
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    
    NSDictionary *dic = @{@"oldpassword" : passOld,
                          @"newpossword" : passNew,
                          @"userid"  :localUser.olduserid
                          };
    
    [self postRequestWithUrl:updatePaasswordURL parameters:dic option:option];


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
    
    [self postRequestWithUrl:isBindingURLString parameters:dic option:option];
}





//绑定手机号码
- (void) bindingPhoneNumber:(NSString *)phoneNum
                  checkCode:(NSString *)checkcode
                     option:(void (^)(NSDictionary *dict))option{
    
    
//    NSString *bindingURLString = [FTNetConfig host:Domain path:BindingPhoneURL];
    //暂时用更新用户接口
    NSString *bindingURLString = [FTNetConfig host:Domain path:UpdateUserURL];
    
    NSString *username = phoneNum;
    NSString *checkCode = checkcode;
    NSString *imei= [UUID getUUID];
   
    NSDictionary *dic = @{@"userId" : username,
                          @"phone" :phoneNum,
                          @"checkCode" : checkCode,
                          @"imei" : imei,
                          @"sequenceId" : imei,
                          };
    NSLog(@"dic : %@", dic);
    
    [self postRequestWithUrl:bindingURLString parameters:dic option:option];
    
}





#pragma mark - 封装请求
//post请求
- (void) postRequestWithUrl:(NSString *)urlString
                 parameters:(NSDictionary *)dic
                     option:(void (^)(NSDictionary *dict))option {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSLog(@"RegisterUserURL url : %@", urlString);
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
    NSLog(@"RegisterUserURL url : %@", urlString);
    [manager GET:urlString
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


//注册登录微信用户
- (void) requestWeixinTokenAdnOpenId:(NSString *)code
                              option:(void (^)(NSDictionary *dict))option {

    NSString *accessUrlStr = [NSString stringWithFormat:@"%@/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", WX_BASE_URL, WX_App_ID, WX_App_Secret, code];
    
    [self getRequestWithUrl:accessUrlStr parameters:nil option:^(NSDictionary *dict) {
            if(dict) {
                //获取到token 和openId后登陆
                [self getWechatUserInfoWithToken:dict[@"access_token"] andOpenId:dict[@"openid"]];
            }
        
    }];
}

- (void)onResp:(BaseResp *)resp {
    
    // 向微信请求授权后,得到响应结果
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *temp = (SendAuthResp *)resp;
        
        //如果
        NSLog(@"temp state: %d", temp.errCode);
        if (temp.errCode != 0) {
            return;
        }
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSString *accessUrlStr = [NSString stringWithFormat:@"%@/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", WX_BASE_URL, WX_App_ID, WX_App_Secret, temp.code];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:accessUrlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *accessDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            [self getWechatUserInfoWithToken:accessDict[@"access_token"] andOpenId:accessDict[@"openid"]];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"获取access_token时出错 = %@", error);
        }];
        
//
    }
}

//微信
- (void)getWechatUserInfoWithToken:(NSString *)token andOpenId:(NSString *)openId{
    NSString *stringURL = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", token, openId];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:stringURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *userInfoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        for(NSString *key in [userInfoDic allKeys]){
            NSLog(@"key:%@", key);
        }
        
        NSString *openId = userInfoDic[@"openid"];
        NSString *unionId = userInfoDic[@"unionid"];
        NSString *timestampString = [NSString stringWithFormat:@"%.0lf",[[NSDate date] timeIntervalSince1970]];
        NSString *imei = [UUID getUUID];
        NSString *username = userInfoDic[@"nickname"];
        NSString *keyToken = [NSString stringWithFormat:@"%@%@", WXLoginSecret_Key, timestampString];
        NSString *keyTokenMD5 = [MD5 md5:keyToken];
        NSString *province = userInfoDic[@"province"];
        NSString *headpic = userInfoDic[@"headimgurl"];
        headpic = [self encodeToPercentEscapeString:headpic];
        NSString *stemfrom = @"iOS";
        username = [username stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSDictionary *dic = @{@"openId" : openId,
//                              @"unionId" : unionId,
//                              @"timestamp" : timestampString,
//                              @"imei" : imei,
//                              @"username" : username,
//                              @"keyToken" : keyTokenMD5,
//                              @"city" : province};
        
        NSString *wxLoginURLString = [FTNetConfig host:Domain path:UserWXLoginURL];
        wxLoginURLString = [NSString stringWithFormat:@"%@?openId=%@&unionId=%@&timestamp=%@&imei=%@&username=%@&keyToken=%@&city=%@&headpic=%@&stemfrom=%@", wxLoginURLString, openId, unionId, timestampString, imei, username, keyTokenMD5, province, headpic, stemfrom];
        
        NSLog(@"wxLoginURLString : %@", wxLoginURLString);
       
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:wxLoginURLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            bool status = [responseJson[@"status"] boolValue];
            NSString *message = (NSString *)(NSDictionary *)responseJson[@"message"];
            if (status == false) {
                NSLog(@"微信注册失败,message:%@", message);
                
                return ;
            }
            NSLog(@"微信注册成功,message:%@", message);
            
            NSDictionary *userDic = responseJson[@"data"][@"user"];
            FTUserBean *user = [FTUserBean new];
            [user setValuesForKeysWithDictionary:userDic];
            
            
            //从本地读取存储的用户信息
            NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
            FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
            
            if (localUser) {//手机已经登录
                localUser.wxopenId = user.openId;
                localUser.wxName = user.username;
                localUser.wxHeaderPic = user.headpic;
            }else {
                
                localUser = user;
                localUser.wxopenId = user.openId;
                localUser.wxName = user.username;
                localUser.wxHeaderPic = user.headpic;
            }
            
            NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:localUser];
            [[NSUserDefaults standardUserDefaults]setObject:userData forKey:LoginUser];
            [[NSUserDefaults standardUserDefaults]synchronize];
            //发送通知，告诉评论页面微信登录成功
            [[NSNotificationCenter defaultCenter]postNotificationName:WXLoginResultNoti object:@"SUCESS"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginAction" object:nil];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"获取access_token时出错 = %@", error);
            //发送通知，告诉评论页面微信登录失败
            [[NSNotificationCenter defaultCenter]postNotificationName:WXLoginResultNoti object:@"ERROR"];
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取access_token时出错 = %@", error);
    }];
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

@end

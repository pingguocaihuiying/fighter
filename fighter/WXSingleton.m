//
//  WXSingleton.m
//  fighter
//
//  Created by kang on 16/7/22.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "WXSingleton.h"


//微信请求类型
typedef NS_ENUM(NSInteger, WXRequestType) {
    WXRequestTypeNone = 0,   //
    WXRequestTypeLogin,                 //微信跨界登录
    WXRequestTypeHeader,                //请求微信头像
    WXRequestTypeName,                  //请求微信昵称
    WXRequestTypeNameAndHeader,         //请求微信昵称和头像
    WXRequestTypeAll,                   //请求所有数据
};


@interface WXSingleton ()
{
    WXRequestType wxRequestType;
}
@end

static WXSingleton * wxSingleton = nil;

@implementation WXSingleton

#pragma mark - 初始化单例
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wxSingleton = [super allocWithZone:zone];
        [wxSingleton registAPP];
    });
    return wxSingleton;
}

+ (instancetype) shareInstance {
    return [self allocWithZone:nil];
}

- (id) copyWithZone:(NSZone *)zone;{
    return self;
}

- (id) registAPP {
    
    //向微信注册
    [WXApi registerApp:@"wxe69b91d3503144ca" withDescription:@"wechat"];
    
    return self;
}


#pragma mark - 微信回调方法
- (void)onResp:(BaseResp *)resp {
    
    //微信share callback
    NSLog(@"resp.type:%d",resp.type);
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        
        switch (resp.errCode) {
            case WXSuccess:
            {
                NSLog(@"微信分享回调成功");
                //发送通知，告诉评论页面微信登录成功
                [[NSNotificationCenter defaultCenter] postNotificationName:WXShareResultNoti object:@"SUCESS"];
            }
                break;
            case WXErrCodeCommon:
            {
                NSLog(@"微信分享回调普通错误类型");
            }
                break;
            case WXErrCodeUserCancel:
            {
                NSLog(@"微信分享回调取消");
            }
                break;
            case WXErrCodeSentFail:
            {
                
            }
                break;
            case WXErrCodeAuthDeny:
            {
                NSLog(@"微信分享回调授权失败");
            }
                break;
            case WXErrCodeUnsupport:
            {
                NSLog(@"微信分享回调 微信不支持");
            }
                break;
                
            default:
                break;
        };
        
        return;
    }
    
    
    // 向微信请求授权后,得到响应结果
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *temp = (SendAuthResp *)resp;
        
        //如果
        NSLog(@"temp state: %d", temp.errCode);
        if (temp.errCode != 0) {
            return;
        }
        
        //请求头像和昵称
        if (wxRequestType == WXRequestTypeNameAndHeader) {
            
            NetWorking *net = [[NetWorking alloc]init];
            // 1.请求access_token openId
            [net requestWeixinTokenAdnOpenId:temp.code option:^(NSDictionary *tokenDic) {
                
                if (tokenDic) {
                    
                    //存储token openid
                    [[NSUserDefaults standardUserDefaults] setObject:tokenDic[@"access_token"] forKey:@"wxToken"];
                    [[NSUserDefaults standardUserDefaults] setObject:tokenDic[@"openid"] forKey:@"wxOpenId"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    //2.请求微信用户信息
                    [net requestWeixinUserInfoWithToken:tokenDic[@"access_token"] openId:tokenDic[@"openid"] option:^(NSDictionary *userDict) {
                        
                        //从本地读取存储的用户信息
                        NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
                        FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
                        
                        
                        localUser.wxopenId = userDict[@"openid"];
                        localUser.wxHeaderPic = userDict[@"headimgurl"];
                        localUser.wxName = userDict[@"nickname"];
                        
                        //存储数据
                        NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:localUser];
                        [[NSUserDefaults standardUserDefaults]setObject:userData forKey:LoginUser];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"WeiXinNameAndHeader" object:nil];
                    }];
                    
                }
                
            }];
            
        }else {//请求所有数据
            
            NetWorking *net = [[NetWorking alloc]init];
            // 1.请求access_token openId
            [net requestWeixinTokenAdnOpenId:temp.code option:^(NSDictionary *tokenDic) {
                
                if (tokenDic) {
                    
                    
                    //2.请求微信用户信息
                    [net requestWeixinUserInfoWithToken:tokenDic[@"access_token"] openId:tokenDic[@"openid"] option:^(NSDictionary *userDict) {
                        
                        if (userDict) {
                            
                            //3.向格斗家服务器注册
                            [net requestWeixinUser:userDict option:^(NSDictionary *dict) {
                                
                                if (dict) {
                                    bool status = [dict[@"status"] boolValue];
                                    NSString *message = (NSString *)(NSDictionary *)dict[@"message"];
                                    if (status == false) {
                                        NSLog(@"微信注册失败,message:%@", message);
                                        //发送通知，告诉评论页面微信登录失败
                                        [[NSNotificationCenter defaultCenter]postNotificationName:WXLoginResultNoti object:@"ERROR"];
                                        return ;
                                    }
                                    
                                    
                                    NSLog(@"微信注册成功,message:%@", message);
                                     NSLog(@"dict:%@", dict);
//                                    NSLog(@"微信登录信息:%@",dict[@"data"][@"user"]);
                                    NSDictionary *userDic = dict[@"data"][@"user"];
                                    FTUserBean *user = [FTUserBean new];
                                    [user setValuesForKeysWithDictionary:userDic];
                                    
                                    user.identity = dict[@"data"][@"identity"];
                                    user.interestList = dict[@"data"][@"interestList"];
                                    
                                    //从本地读取存储的用户信息
                                    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
                                    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
                                    
                                    //存储token openid
                                    [[NSUserDefaults standardUserDefaults] setObject:user.openId forKey:@"wxopenId"];
                                    [[NSUserDefaults standardUserDefaults] setObject:user.username forKey:@"wxName"];
                                    [[NSUserDefaults standardUserDefaults] setObject:user.headpic forKey:@"wxHeaderPic"];
                                    [[NSUserDefaults standardUserDefaults]synchronize];
                                    
                                    if (localUser) {//手机已经登录
                                        localUser.openId = user.openId;
                                        localUser.unionId = user.unionId;
                                        localUser.wxName = user.username;
                                        localUser.wxHeaderPic = user.headpic;
                                    }else {
                                        localUser = user;
                                        localUser.wxopenId = user.openId;
                                        localUser.unionId = user.unionId;
                                        localUser.wxName = user.username;
                                        localUser.wxHeaderPic = user.headpic;
                                    }
                                    
                                    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:localUser];
                                    [[NSUserDefaults standardUserDefaults]setObject:userData forKey:LoginUser];
                                    [[NSUserDefaults standardUserDefaults]synchronize];
                                    
                                    //发送通知，告诉评论页面微信登录成功
                                    [[NSNotificationCenter defaultCenter] postNotificationName:WXLoginResultNoti object:@"SUCESS"];
                                    //                            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginAction" object:nil];
                                }else {
                                    
                                    [[NSNotificationCenter defaultCenter]postNotificationName:WXLoginResultNoti object:@"ERROR"];
                                    return ;
                                }
                                
                            }];
                            
                        }
                    }];
                }
                
            }];
        }
        
    }
    
    //支付回掉
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
                [[NSNotificationCenter defaultCenter]postNotificationName:WXPayResultNoti object:@"SUCESS"];
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                break;
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                [[NSNotificationCenter defaultCenter]postNotificationName:WXPayResultNoti object:@"ERROR"];
                break;
        }
    }
}


@end

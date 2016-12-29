//
//  WXSingleton.m
//  fighter
//
//  Created by kang on 16/7/22.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "WXSingleton.h"




@interface WXSingleton ()
{
    
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
    
    
    NSLog(@"resp.type:%d",resp.type);
    
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) { // 微信share callback
        [self weiXinShareResponse:resp];
    }else if ([resp isKindOfClass:[SendAuthResp class]]) {  // 向微信请求授权后,得到响应结果
    
        SendAuthResp *temp = (SendAuthResp *)resp;
        
        //如果
        NSLog(@"temp state: %d", temp.errCode);
        if (temp.errCode != 0) {
            return;
        }
        // 向微信服务器请求数据
        [self requestWeiXinAccessTokenAndOpenId:temp];
        
    }else if ([resp isKindOfClass:[PayResp class]]){ //支付回掉
    
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




/**
 想微信服务器请求access_token 和openId
 @param temp
 */
- (void) requestWeiXinAccessTokenAndOpenId:(SendAuthResp *) temp{

     NSLog(@"temp code: %@", temp.code);
    // 1.请求access_token openId
    [NetWorking requestWeixinTokenAdnOpenId:temp.code option:^(NSDictionary *tokenDic) {
        
        if (tokenDic) {
            
//            //存储token openid
//            [[NSUserDefaults standardUserDefaults] setObject:tokenDic[@"access_token"] forKey:@"wxToken"];
//            [[NSUserDefaults standardUserDefaults] setObject:tokenDic[@"openid"] forKey:@"wxOpenId"];
//            [[NSUserDefaults standardUserDefaults]synchronize];
            [self requestWeiXinUserInfo:tokenDic];
        }
    }];
}


/**
 向微信服务器请求微信用户数据

 @param tokenDic
 */
- (void) requestWeiXinUserInfo:(NSDictionary *)tokenDic {

    [NetWorking requestWeixinUserInfoWithToken:tokenDic[@"access_token"] openId:tokenDic[@"openid"] option:^(NSDictionary *userDict) {
        
        if (userDict) {
            
            if (_wxRequestType == WXRequestTypeNameAndHeader) { //请求头像和昵称
//                [self requestWeiXinNameAndHeader:userDict];
                [FTNotificationTools postBindWeiXinNotiWithDic:userDict];
            }else if (_wxRequestType == WXRequestTypeLogin) {  // 微信登录
                [self registWinXinUser:userDict];
            }
        }
        
    }];
}

/**
 向服务器注册微信用户

 @param userDict
 */
- (void) registWinXinUser:(NSDictionary *)userDict  {
    
    //3.向格斗家服务器注册
    [NetWorking requestWeixinUser:userDict option:^(NSDictionary *dict) {
        
        if (dict) {
            bool status = [dict[@"status"] boolValue];
            NSString *message = dict[@"message"];
            if (status == false) {
                NSLog(@"微信注册失败,message:%@", message);
                // 发送微信登录失败通知
                [FTNotificationTools postLoginErrorNoti:FTLoginTypeWeiXin];
                return ;
            }
            
            NSLog(@"微信注册成功,message:%@", message);
            SLog(@"dict:%@", dict);
            //NSLog(@"微信登录信息:%@",dict[@"data"][@"user"]);
            NSDictionary *userDic = dict[@"data"][@"user"];
            FTUserBean *user = [FTUserBean new];
            [user setValuesForKeysWithDictionary:userDic];
            
            if ([dict[@"data"][@"corporationid"] integerValue] > 0) {
                user.corporationid = [NSString stringWithFormat:@"%ld",[dict[@"data"][@"corporationid"] integerValue]];
            }
            user.identity = dict[@"data"][@"identity"];
            user.interestList = dict[@"data"][@"interestList"];
            user.isGymUser = dict[@"data"][@"isGymUser"];
            
            //更新本地数据
            user.openId = userDict[@"openid"];
            user.wxopenId = userDict[@"openid"];
            user.wxHeaderPic = userDict[@"headimgurl"];
            user.wxName = userDict[@"nickname"];
            user.unionId = userDict[@"unionid"];
            

            NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:user];
            [[NSUserDefaults standardUserDefaults]setObject:userData forKey:LoginUser];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            //发送通知，告诉评论页面微信登录成功
            [FTNotificationTools postLoginNoti:FTLoginTypeWeiXin];
            return ;
        }else {
            // 发送微信登录失败通知
            [FTNotificationTools postLoginErrorNoti:FTLoginTypeWeiXin];
            return ;
        }
    }];
}

/**
 存储微信头像和微信名到当前用户
 @param temp
 */
- (void) requestWeiXinNameAndHeader:(NSDictionary *) userDict{
    
//    //从本地读取存储的用户信息
//    FTUserBean *localUser = [FTUserBean loginUser];
//    localUser.wxopenId = userDict[@"openid"];
//    localUser.wxHeaderPic = userDict[@"headimgurl"];
//    localUser.wxName = userDict[@"nickname"];
//    localUser.unionId = userDict[@"unionid"];
//    
//    //存储数据
//    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:localUser];
//    [[NSUserDefaults standardUserDefaults]setObject:userData forKey:LoginUser];
//    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [FTNotificationTools postBindWeiXinNotiWithDic:userDict];
    
}


/**
 微信分享响应

 @param resp
 */
- (void) weiXinShareResponse:(BaseResp *)resp {

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

@end

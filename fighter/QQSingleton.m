//
//  QQShare.m
//  fighter
//
//  Created by kang on 16/7/21.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "QQSingleton.h"
#import "ViewController.h"



@interface QQSingleton ()<TencentSessionDelegate>
{
    TencentOAuth *myTencentOAuth;   //QQ授权类
    NSArray *permissions;           //权限数组
}
@end

static QQSingleton * qqShare = nil;

@implementation QQSingleton
#pragma mark - 初始化单例
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        qqShare = [super allocWithZone:zone];
        [qqShare registAPP];
    });
    return qqShare;
}

+ (instancetype) shareInstance {
    return [self allocWithZone:nil];
}

- (id) copyWithZone:(NSZone *)zone;{
    return self;
}

- (id) registAPP {
    //初始化TencentOAuth
    myTencentOAuth = [[TencentOAuth alloc]initWithAppId:QQ_App_ID andDelegate:self];
    myTencentOAuth.localAppId = @"gogogofight";
    
    return self;
}
#pragma mark - 为QQ分享做准备
-(void)prepareToShare
{
    //获取权限
    permissions = [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_USER_INFO,
                   kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                   kOPEN_PERMISSION_ADD_SHARE,
                   kOPEN_PERMISSION_ADD_TOPIC,
                   kOPEN_PERMISSION_GET_INFO,
                   kOPEN_PERMISSION_GET_OTHER_INFO,
                   nil];
    
    //需要做进一步的处理 - 从本地获取AccessToken，同时赋值。
    [self getUserInfo];
}


#pragma mark - 进行授权登陆
-(void)doOAuthLogin
{
    //直接调用SDK提供的方法 - (BOOL)authorize:(NSArray *)permissions; 进行分享操作，对于这个方法，在返回YES时表示授权成功，此时需要保存用户的accessToken、openId、expirationDate
    
    [myTencentOAuth authorize:permissions];
}

#pragma mark - TencentSessionDelegate
- (void)addShareResponse:(APIResponse*) response {
    
//    //发送通知，告诉评论页面微信登录成功
//    [[NSNotificationCenter defaultCenter] postNotificationName:QQShareResultNoti object:@"SUCESS"];
//
//    NSLog(@"qq share message:%@",response.message);
}

/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin
{
    if (myTencentOAuth.accessToken && 0 != [myTencentOAuth.accessToken length])
    {
        //获取登陆用户的OpenID、Token以及过期时间，同时进行存储。
        [self saveUserInfo:myTencentOAuth];
        
        //调用分享操作 --- 有些问题：授权成功回调后，执行分享操作。
        
    }
    
    if (myTencentOAuth.accessToken && 0 != [myTencentOAuth.accessToken length])
    {
        //获取登陆用户的OpenID、Token以及过期时间，同时进行存储。
        [self saveUserInfo:myTencentOAuth];
        
    }
    else
    {
        UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"登录不成功" message:@"登录不成功 没有获取accesstoken" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [msgbox show];
        
    }

}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled)
    {
        UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"用户取消登录" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [msgbox show];

    }
    else
    {
        UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"登录失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [msgbox show];

    }

    
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork
{
    UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"无网络连接，请设置网络" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
    [msgbox show];
}


#pragma mark - QQ回调方法
////QQ终端向第三方程序发送请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到QQ终端程序界面。
-(void)onReq:(QQBaseReq *)req
{
    
}

//如果第三方程序向QQ发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到QQ终端程序界面。
-(void)onResp:(QQBaseResp *)resp
{
    if ([resp.result integerValue] == 0) {
        // 发送通知，通知qq分享成功
        [[NSNotificationCenter defaultCenter] postNotificationName:QQShareResultNoti object:@"SUCESS"];
    }
}

-(void)isOnlineResponse:(NSDictionary *)response
{

}


#pragma mark - 存储授权用户的OpenID、Token以及过期时间
-(void)saveUserInfo:(TencentOAuth *)oauth
{
    //获取文件路径
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [[paths objectAtIndex:0]stringByAppendingPathComponent:@"oauthUser.dic"];
    
    //构建存储字典
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:oauth.openId forKey:@"openId"];
    [paramDic setObject:oauth.accessToken forKey:@"accessToken"];
    [paramDic setObject:oauth.expirationDate forKey:@"expirationDate"];
    
    //以写文件的方式存储到Document目录下。
    [paramDic writeToFile:documentsDirectory atomically:YES];
}

-(void)getUserInfo
{
    //获取文件路径
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [[paths objectAtIndex:0]stringByAppendingPathComponent:@"oauthUser.dic"];
    
    NSDictionary *paramDic = [NSDictionary dictionaryWithContentsOfFile:documentsDirectory];
    if (paramDic != nil)
    {
        //分别获取
        NSString *accessToken = [NSString stringWithFormat:@"%@",[paramDic objectForKey:@"accessToken"]];
        NSDate *expirationDate = [paramDic objectForKey:@"expirationDate"];
        NSString *openId = [NSString stringWithFormat:@"%@",[paramDic objectForKey:@"openId"]];
        
        //给myTencentOAuth赋值 - 用于后续的判断 - 是否需要授权，同时也是对分享的一个支持
        [myTencentOAuth setAccessToken:accessToken];
        [myTencentOAuth setExpirationDate:expirationDate];
        [myTencentOAuth setOpenId:openId];
    }
}


#pragma mark - QQ请求结果
// qq 分享回调
- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        default:
        {
            break;
        }
    }
}

@end

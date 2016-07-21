//
//  QQShare.m
//  fighter
//
//  Created by kang on 16/7/21.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "QQShare.h"
#import "ViewController.h"

#import <TencentOpenAPI/sdkdef.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface QQShare ()<TencentSessionDelegate>
{
    TencentOAuth *myTencentOAuth;   //QQ授权类
    NSArray *permissions;           //权限数组
}
@end

@implementation QQShare


#pragma mark - 为QQ分享做准备
-(void)prepareToShare
{
    //初始化TencentOAuth
    myTencentOAuth = [[TencentOAuth alloc]initWithAppId:QQ_App_ID andDelegate:self];
    
    //获取权限
    permissions = [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_USER_INFO,
                   kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                   kOPEN_PERMISSION_ADD_ALBUM,
                   kOPEN_PERMISSION_ADD_ONE_BLOG,
                   kOPEN_PERMISSION_ADD_SHARE,
                   kOPEN_PERMISSION_ADD_TOPIC,
                   kOPEN_PERMISSION_CHECK_PAGE_FANS,
                   kOPEN_PERMISSION_GET_INFO,
                   kOPEN_PERMISSION_GET_OTHER_INFO,
                   kOPEN_PERMISSION_LIST_ALBUM,
                   kOPEN_PERMISSION_UPLOAD_PIC,
                   kOPEN_PERMISSION_GET_VIP_INFO,
                   kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                   nil];
    
    //需要做进一步的处理 - 从本地获取AccessToken，同时赋值。
    [self getUserInfo];
}

-(void)shareButtonIsTouch:(UIButton *)paramSender
{
    
    //需要进行判断 -- 判断授权时间是否过期 -- 在没有授权之前，tpExpirationDate会是nil
    NSDate *tpExpirationDate = myTencentOAuth.expirationDate;
    if (tpExpirationDate == nil)
    {
        //需要进行授权操作 - 进行SSO授权
        [self doOAuthLogin];
    }
    else
    {
        //进一步判断 -- 授权是否过期
        NSString *tpExpirationTimeString = [NSString stringWithFormat:@"%.0f",[tpExpirationDate timeIntervalSince1970]];
        NSString *timeString = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
        if ([timeString longLongValue] <[tpExpirationTimeString longLongValue])
        {
            //表示授权没有过期 -- 则可直接分享
            [self doMyShare];
        }
        else
        {
            //表示授权过期了 - 进行SSO授权
            [self doOAuthLogin];
        }
    }
}

#pragma mark - 进行授权登陆
-(void)doOAuthLogin
{
    //直接调用SDK提供的方法 - (BOOL)authorize:(NSArray *)permissions; 进行分享操作，对于这个方法，在返回YES时表示授权成功，此时需要保存用户的accessToken、openId、expirationDate
    
    [myTencentOAuth authorize:permissions];
}

#pragma mark - TencentSessionDelegate
- (void)addShareResponse:(APIResponse*) response {
    
    //发送通知，告诉评论页面微信登录成功
    [[NSNotificationCenter defaultCenter] postNotificationName:QQShareResultNoti object:@"SUCESS"];

    NSLog(@"qq share message:%@",response.message);
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
        [self doMyShare];
    }
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork
{
    
}

#pragma mark - 存储授权用户的OpenID、Token以及过期时间
-(void)saveUserInfo:(TencentOAuth *)oauth
{
//    //获取文件路径
//    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [[paths objectAtIndex:0]stringByAppendingPathComponent:@"oauthUser.dic"];
//    
//    //构建存储字典
//    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
//    [paramDic setObject:oauth.openId forKey:@"openId"];
//    [paramDic setObject:oauth.accessToken forKey:@"accessToken"];
//    [paramDic setObject:oauth.expirationDate forKey:@"expirationDate"];
//    
//    //以写文件的方式存储到Document目录下。
//    [paramDic writeToFile:documentsDirectory atomically:YES];
}

-(void)getUserInfo
{
//    //获取文件路径
//    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [[paths objectAtIndex:0]stringByAppendingPathComponent:@"oauthUser.dic"];
//    
//    NSDictionary *paramDic = [NSDictionary dictionaryWithContentsOfFile:documentsDirectory];
//    if (paramDic != nil)
//    {
//        //分别获取
//        NSString *accessToken = [NSString stringWithFormat:@"%@",[paramDic objectForKey:@"accessToken"]];
//        NSDate *expirationDate = [paramDic objectForKey:@"expirationDate"];
//        NSString *openId = [NSString stringWithFormat:@"%@",[paramDic objectForKey:@"openId"]];
//        
//        //给myTencentOAuth赋值 - 用于后续的判断 - 是否需要授权，同时也是对分享的一个支持
//        [myTencentOAuth setAccessToken:accessToken];
//        [myTencentOAuth setExpirationDate:expirationDate];
//        [myTencentOAuth setOpenId:openId];
//    }
}

#pragma mark - 执行分享操作 --  测试发现，如果不回到主线程中执行分享操作，会出现错误，应该是受QQ授权影响。
//http://wiki.connect.qq.com/ios_sandbox1#2.3.E5.88.86.E4.BA.AB.E7.A4.BA.E4.BE.8B.E4.BB.A3.E7.A0.81
-(void)doMyShare
{
    
    NSDate *tpExpirationDate = myTencentOAuth.expirationDate;
    if (tpExpirationDate == nil)
    {
        //需要进行授权操作 - 进行SSO授权
        [self doOAuthLogin];
    }
    else
    {
        //进一步判断 -- 授权是否过期
        NSString *tpExpirationTimeString = [NSString stringWithFormat:@"%.0f",[tpExpirationDate timeIntervalSince1970]];
        NSString *timeString = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
        if ([timeString longLongValue] <[tpExpirationTimeString longLongValue])
        {
            //表示授权没有过期 -- 则可直接分享
            dispatch_async(dispatch_get_main_queue(), ^{
                
                QQApiNewsObject* newsObj = [self setTencentReq];
                
                // 设置分享到 QZone 的标志位
                [newsObj setCflag: kQQAPICtrlFlagQZoneShareOnStart ];
                SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:newsObj];
                QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
                
                [self handleSendResult:sent];
            });
        }
        else
        {
            //表示授权过期了 - 进行SSO授权
            [self doOAuthLogin];
        }
    }
    
    
}


- (QQApiNewsObject *) setTencentReq {
    
    
    //设置分享链接
    NSURL* url = [NSURL URLWithString: @"http://www.gogogofight.com/page/v2/video_paid_wechat_page.html?objId=262&tableName=c-videos"];
    
    QQApiNewsObject* imgObj = [[QQApiNewsObject alloc]initWithURL:url
                                                            title:@"格斗东西"
                                                      description:@"格斗东西"
                                                 previewImageData:[self getImageDataForSDWebImageCachedKey]
                                                targetContentType:QQApiURLTargetTypeNews];
    
    
    
    return imgObj;
}


//获取SDWebImage缓存图片
- (NSData *) getImageDataForSDWebImageCachedKey {
    
    UIImage *image = [UIImage imageNamed:@"微信用@200"];
    NSData *data = UIImageJPEGRepresentation(image, 1);
    
    if (data == nil || data.length == 0) {
        UIImage *iconImg = [UIImage imageNamed:@"微信用@200"];
        data = UIImageJPEGRepresentation(iconImg, 1);
        
        int i = 1;
        while (data.length > 32*1000) {
            data = UIImageJPEGRepresentation(iconImg, 1-i/10);
            i++;
        }
        return data;
    }
    
    int i = 1;
    while (data.length > 32*1000) {
        data = UIImageJPEGRepresentation(image, 1-i/10);
        i++;
    }
    
    return  data;
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
        case EQQAPISENDSUCESS:
        {
            
            NSLog(@"qq分享回调成功");
//            //发送通知，告诉评论页面微信登录成功
//            [[NSNotificationCenter defaultCenter] postNotificationName:QQShareResultNoti object:@"SUCESS"];
        }
            break;
        default:
        {
            break;
        }
    }
}

@end

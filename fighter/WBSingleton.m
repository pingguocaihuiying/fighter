//
//  WBSingleton.m
//  fighter
//
//  Created by kang on 16/7/25.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "WBSingleton.h"

@interface WBSingleton ()
{
    
}
@end

static WBSingleton * wbShare = nil;

@implementation WBSingleton
#pragma mark - 初始化单例
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wbShare = [super allocWithZone:zone];
        [wbShare registAPP];
    });
    return wbShare;
}

+ (instancetype) shareInstance {
    return [self allocWithZone:nil];
}

- (id) copyWithZone:(NSZone *)zone;{
    return self;
}

- (id) registAPP {
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:WB_App_ID];
    
    return self;
}


#pragma mark - 微博回调方法
/**
 收到一个来自微博客户端程序的请求
 
 收到微博的请求后，第三方应用应该按照请求类型进行处理，处理完后必须通过 [WeiboSDK sendResponse:] 将结果回传给微博
 @param request 具体的请求对象
 */
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

/**
 收到一个来自微博客户端程序的响应
 
 收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 WBBaseResponse.userInfo 中的数据完成自己的功能
 @param response 具体的响应对象
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    
    //    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    //    {
    //        NSString *title = NSLocalizedString(@"发送结果", nil);
    //        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
    //                                                        message:message
    //                                                       delegate:nil
    //                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
    //                                              otherButtonTitles:nil];
    //        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
    //        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
    //        if (accessToken)
    //        {
    //            self.wbtoken = accessToken;
    //        }
    //        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
    //        if (userID) {
    //            self.wbCurrentUserID = userID;
    //        }
    //        [alert show];
    //    }
    
}
@end

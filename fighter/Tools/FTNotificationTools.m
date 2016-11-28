//
//  FTNotificationTools.m
//  fighter
//
//  Created by kang on 2016/11/28.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTNotificationTools.h"

@implementation FTNotificationTools

#pragma mark - 登录通知

/**
 发送登录成功通知

 @param loginType 登录通知类型
 */
+ (void) postLoginNoti:(FTLoginType) loginType {

    NSDictionary *userinfo;
    if (loginType == FTLoginTypePhone) {
        userinfo = @{@"type":@"Phone",
                     @"result":@"SUCCESS"};
    }else if (loginType == FTLoginTypeWeiXin) {
        userinfo = @{@"type":@"WeiXin",
                     @"result":@"SUCCESS"};
    }else if (loginType == FTLoginTypeLogout) {
        userinfo = @{@"type":@"Logout",
                     @"result":@"SUCCESS"};
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LoginNoti object:nil userInfo:userinfo];
}

/**
 发送登录失败通知
 
 @param loginType 登录通知类型
 */
+ (void) postLoginErrorNoti:(FTLoginType) loginType {
    
    NSDictionary *userinfo;
    if (loginType == FTLoginTypePhone) {
        userinfo = @{@"type":@"Phone",
                     @"result":@"ERROR"};
    }else if (loginType == FTLoginTypeWeiXin) {
        userinfo = @{@"type":@"WeiXin",
                     @"result":@"ERROR"};
    }else if (loginType == FTLoginTypeLogout) {
        userinfo = @{@"type":@"Logout",
                     @"result":@"ERROR"};
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LoginNoti object:nil userInfo:userinfo];
}

//- (void) setNotification {
//
//    //注册通知，接收登录成功的消息
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginCallBack:) name:LoginNoti object:nil];
//}
//
//// 登录响应
//- (void) loginCallBack:(NSNotification *)noti {
//    
//    NSDictionary *userInfo = noti.userInfo;
//    if ([userInfo[@"result"] isEqualToString:@"SUCCESS"]) {
//        
//    }
//    
//}

//// 登录响应
//- (void) loginCallBack:(NSNotification *)noti {
//    
//    NSDictionary *userInfo = noti.userInfo;
//    if ([userInfo[@"result"] isEqualToString:@"SUCCESS"]) {
//        [self.view showMessage:@"微信登录成功，可以评论或点赞了"];
//    }else {
//        [self.view showMessage:@"登录登录失败"];
//    }
//    
//}



@end

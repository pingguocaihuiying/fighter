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

- (void) setNotification {

    //注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideNavigationBar:) name:HideHomePageNavNoti object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showNavigationBar:) name:ShowHomePageNavNoti object:nil];
}


- (void) hideNavigationBar:(NSNotification *)noti {
    
}

- (void) showNavigationBar:(NSNotification *)noti {
    
}


#pragma mark - 个人主页导航栏通知

/**
 隐藏个人主页导航栏
 */
+ (void) postHideHomepageNavigationBarNoti {

    [[NSNotificationCenter defaultCenter] postNotificationName:HideHomePageNavNoti object:nil];
}


/**
 显示个人主页导航栏
 */
+ (void) postShowHomepageNavigationbarNoti {

    [[NSNotificationCenter defaultCenter] postNotificationName:ShowHomePageNavNoti object:nil];
}

#pragma mark - 


/**
 显示会员拳馆
 */
+ (void) postShowMembershipGymsNoti {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ShowMemberShipGymsNavNoti object:nil];
}

@end

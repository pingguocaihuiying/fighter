//
//  FTNotificationTools.h
//  fighter
//
//  Created by kang on 2016/11/28.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>


// 通知
#define WXPayResultNoti @"WXPayResultNoti"
#define WXShareResultNoti @"WXShareResultNoti"
#define WeiXinNameAndHeader @"WeiXinNameAndHeader"
#define QQShareResultNoti @"QQShareResultNoti"
#define RechargeResultNoti @"RechargeOrCharge"
#define RechargeMoneytNoti @"RechargeMoneytNoti"
#define BookCoachSuccessNotification @"RechargeMoneytNoti"

#define LoginNoti @"LoginNotifacation" // 登录通知
#define QQShareResponse @"addShareResponse"
#define TaskNotification @"taskNotification"
#define EditNotification @"editNotification"
#define HideHomePageNavNoti @"HideHomePageNavNoti"
#define ShowHomePageNavNoti @"ShowHomePageNavNoti"
#define ShowMemberShipGymsNavNoti @"ShowMemberShipGymsNavNoti"

#define InAPPSwitchControllerNoti @"InAPPSwitchControllerNoti"
#define SwitchNewsDetailNoti @"SwitchNewsDetailNoti"
#define SwitchFightingDetailNoti @"SwitchFightingDetailNoti"
#define SwitchPracticeDetailNoti @"SwitchPracticeDetailNoti"
#define SwitchBoxingBarDetailNoti @"SwitchBoxingBarDetailNoti"
#define SwitchShopDetailNoti @"SwitchShopDetailNoti"
#define SwitchShopHomeNoti @"SwitchShopHomeNoti"

#define CloseDrawerNoti @"CloseDrawerNoti"
/**
 登录通知类型枚举

 */
typedef NS_ENUM(NSInteger, FTLoginType) {
    FTLoginTypePhone, //手机号登录
    FTLoginTypeWeiXin, //微信登录
    FTLoginTypeLogout //退出登录
};

@interface FTNotificationTools : NSObject


#pragma mark - 登录通知

/**
 发送登录通知
 
 @param loginType 登录通知类型
 */
+ (void) postLoginNoti:(FTLoginType) loginType;


/**
 发送登录失败通知
 
 @param loginType 登录通知类型
 */
+ (void) postLoginErrorNoti:(FTLoginType) loginType;


/**
 绑定微信通知
 */
+ (void) postBindWeiXinNotiWithDic:(NSDictionary *)dic;

#pragma mark - 个人主页导航栏通知

+ (void) postHideHomepageNavigationBarNoti;

+ (void) postShowHomepageNavigationbarNoti;

#pragma mark -
/**
 显示会员拳馆
 */
+ (void) postShowMembershipGymsNoti;

#pragma mark - 应用内跳转通知

+ (void) postTabBarIndex:(NSInteger) index dic:(NSDictionary *) dic;

+ (void) postSwitchNewsDetailControllerWithDic:(NSDictionary *) dic;

+ (void) postSwitchFightingDetailControllerWithDic:(NSDictionary *) dic;

+ (void) postSwitchPracticeDetailControllerWithDic:(NSDictionary *) dic;

+ (void) postSwitchBoxingBarDetailControllerWithDic:(NSDictionary *) dic;

+ (void) postSwitchShopDetailControllerWithDic:(NSDictionary *) dic;

+ (void) postSwitchShopHomeNotiWithDic:(NSDictionary *)dic;

#pragma mark - 侧滑栏通知

+ (void) postCloseDrawerNoti;
@end

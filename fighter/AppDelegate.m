//
//  AppDelegate.m
//  fighter
//
//  Created by Liyz on 4/7/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "AppDelegate.h"
#import "FTInformationViewController.h"
#import "FTMatchViewController.h"
#import "FTCoachViewController.h"
#import "FTBoxingHallViewController.h"
#import "FTBaseNavigationViewController.h"
#import "FTBaseTabBarViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
//#import "UMSocialSinaSSOHandler.h"
#import "AFHTTPRequestOperationManager.h"
#import "UUID.h"
#import "FTNetConfig.h"
#import "RBRequestOperationManager.h"
#import "FTUserBean.h"
#import "FTVideoViewController.h"

#import "FTDrawerViewController.h"
#import "MainViewController.h"
#import "Networking.h"
#import "DBManager.h"
#import "RealReachability.h"
#import "IXPushSdk.h"

//#import "UMSocialQQHandler.h"

#import <PLStreamingKit/PLStreamingEnv.h>
#import "WeiboSDK.h"
#import "QQSingleton.h"
#import "WXSingleton.h"

@protocol TencentSessionDelegate;
@interface AppDelegate ()<WeiboSDKDelegate>
{
   
    
}


@property (nonatomic, strong) MainViewController *mainVC;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //更改webview的useragent
    [self setWebviewUserAgent];
    
    //启动时先加载标签分类
    [FTNWGetCategory sharedCategories];
    
    //设置友盟相关的的
    [self setUMeng];
    //设置微信相关的
    [self setWeiXin];
    //设置qq相关
    [self setTencent];
    //设置新浪博客相关
    [self setSinaMicroBlog];
    //设置爱心推
    [self setIXPushWithApplication:application options:launchOptions];
    //设置数据库
    [self setDatabase];
    
    //监听网络
    [GLobalRealReachability startNotifier];
    
    //设置直播环境
    [PLStreamingEnv initEnv];
    
    //屏蔽个人中心时打开这里
//    [self setRootViewController2];

    
    //启动个人中心的功能
    _mainVC = [[MainViewController alloc]init];
    self.window.rootViewController=_mainVC;
    //推送消息
    NSDictionary *dic = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (dic != nil) {
        
        NSLog(@"push info:%@",dic);

        [[NSUserDefaults standardUserDefaults] setObject:dic[@"extra"][@"click_param"] forKey:@"pushMessageDic"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    return YES;
}

- (void)setWebviewUserAgent{
    //get the original user-agent of webview
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *oldAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
//    NSLog(@"old agent :%@", oldAgent);
    
    //add my info to the new agent
    NSString *newAgent = [oldAgent stringByAppendingString:@" Gogogofight"];
//    NSLog(@"new agent :%@", newAgent);
    
    //regist the new agent
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil, nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
}


#pragma  mark - app 相关设置
- (void) setDatabase {
    
    BOOL exist = [[[NSUserDefaults standardUserDefaults] objectForKey:@"tabels"] boolValue];
    
    if (!exist) {
        DBManager *dbManager = [DBManager shareDBManager];
        [dbManager connect];
        [dbManager createAllTables];
        [dbManager close];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"tabels"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        NetWorking *net = [[NetWorking alloc]init];
        [net getRankLabels:^(NSDictionary *dict) {
            if (dict != nil) {
                if ([dict[@"status"] isEqualToString:@"success"]) {
                    
                    DBManager *dbManager = [DBManager shareDBManager];
                    [dbManager connect];
                    [dbManager createLabelsTable];
                    
                    NSArray *labels= dict[@"data"];
                    for (NSDictionary *dic in labels) {
                        
                        [dbManager insertDataIntoLabels:dic];
                        
                    }
                    
                    [dbManager close];
                    
                }
            }
        }];

    }
    
    
}


- (void)setUMeng{
    //友盟统计
    UMConfigInstance.appKey = @"570739d767e58edb5300057b";
    [MobClick startWithConfigure:UMConfigInstance];
//    [MobClick startWithAppkey:@"570739d767e58edb5300057b" reportPolicy:BATCH   channelId:@""];
    
    //友盟分享
    [UMSocialData setAppKey:@"570739d767e58edb5300057b"];
    
    //友盟反馈
    [UMFeedback setAppkey:@"570739d767e58edb5300057b"];
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:WX_App_ID appSecret:WX_App_Secret url:@"http://www.umeng.com/social"];
    
    //设置QQ AppId、appSecret，分享url
//    [UMSocialQQHandler setQQWithAppId:QQ_App_ID appKey:QQ_App_Secret url:@"http://www.umeng.com/social"];
    
//    // 打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。需要 #import "UMSocialSinaSSOHandler.h"
//    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:WB_App_ID
//                                              secret:WB_App_Secret
//                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
}


- (void)setWeiXin{
    //  初始化微信代理单例
    [WXSingleton shareInstance];
}

#pragma mark 设置qq
- (void) setTencent {
    //  初始化QQ代理单例
    [QQSingleton shareInstance];
}

#pragma mark 新浪微博
- (void) setSinaMicroBlog {
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:WB_App_ID];
}


#pragma mark 设置爱心推
- (void)  setIXPushWithApplication:(UIApplication *)application options:(NSDictionary *)launchOptions {
    //设置爱心推
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        UIMutableUserNotificationAction *action = [[UIMutableUserNotificationAction alloc] init];
        action.identifier = @"acceptAction";
        action.title=@"Accept";
        action.activationMode = UIUserNotificationActivationModeForeground;
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];
        action2.identifier = @"rejectAction";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;
        action2.authenticationRequired = YES;
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"Category";
        [categorys setActions:@[action,action2] forContext:(UIUserNotificationActionContextMinimal)];
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:[NSSet setWithObjects:categorys, nil]];
        [IXPushSdkApi register:launchOptions settings:settings];
    }
//    else {
//        [IXPushSdkApi register:launchOptions types:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge)];
//    }
#else
    [PushSdkApi register:launchOptions types:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge)];
#endif
    
    
    if ([IXPushSdkApi isRegistered]) {
        NSLog(@"push is registered");
    } else {
        NSLog(@"push is unregistered");
    }
}


-(void)applicationWillFinishLaunching:(NSNotification *)notification
{
    // Locate the receipt
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    
    // Test whether the receipt is present at the above path
    if(![[NSFileManager defaultManager] fileExistsAtPath:[receiptURL path]])
    {
        // Validation fails
        exit(173);
    }
    
    // Proceed with further receipt validation steps
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

#pragma mark -
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if([UMSocialSnsService handleOpenURL:url]){
        return YES;
    }
    
    WXSingleton *wxSingleton = [WXSingleton shareInstance];
    if([WXApi handleOpenURL:url delegate:wxSingleton]){
        return YES;
    }
    
    
    QQSingleton *qqSingleton = [QQSingleton shareInstance];
    if ( [QQApiInterface handleOpenURL:url delegate:qqSingleton]) {
        return YES;
    }
    
    if ([WeiboSDK handleOpenURL:url delegate:self]) {
        return YES;
    }
    
    if ([url.description isEqualToString:@"gogogofight://"]) {
        return YES;
    }
    return NO;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    QQSingleton *qqShare = [QQSingleton shareInstance];
    if ([QQApiInterface handleOpenURL:url delegate:qqShare]) {
        return YES;
    }
    
    WXSingleton *wxSingleton = [WXSingleton shareInstance];
    if([WXApi handleOpenURL:url delegate:wxSingleton]){
        return YES;
    }

    if ([WeiboSDK handleOpenURL:url delegate:self]) {
        return YES;
    }
    return NO;
}


- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken
{
    NSLog(@"deviceToken:%@",deviceToken);
    [IXPushSdkApi registerDeviceToken:deviceToken
                              channel:@"test" version:@"1.0" appId:1670128310];
}


- (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error {
    
    NSLog(@"register fail********************,%@",error);
}


// 对收到的消息进行处理:
- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

    NSLog(@"Notification info:%@",userInfo);
    [IXPushSdkApi handleNotification:userInfo];
    
    
    switch (application.applicationState) {
        case UIApplicationStateActive:
        {
//            [_mianVC pushMessage:userInfo[@"extra"]];
        }
            break;
        case UIApplicationStateInactive:
        {
            [_mainVC pushMessage:userInfo[@"extra"]];
        }
            break;
        case UIApplicationStateBackground:
        {
//            [_mianVC pushMessage:userInfo[@"extra"]];
        }
            break;
        default:
            break;
    }
    
}


//// 对收到的消息进行处理:
//- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
//{
//    NSLog(@"Notification info:%@",userInfo);
//    [IXPushSdkApi handleNotification:userInfo];
//    completionHandler(UIBackgroundFetchResultNewData);
//    
//}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
//     NSLog(@"to background");
     [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
//
//  AppDelegate.m
//  fighter
//
//  Created by Liyz on 4/7/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "AppDelegate.h"

#import "FTDrawerViewController.h"
#import "MainViewController.h"
#import "Networking.h"
#import "DBManager.h"
#import "RealReachability.h"
#import "IXPushSdk.h"

#import <PLStreamingKit/PLStreamingEnv.h>
#import "WeiboSDK.h"
#import "QQSingleton.h"
#import "WXSingleton.h"
#import "WBSingleton.h"

//#import "UMSocial.h"
//#import "UMSocialWechatHandler.h"


@interface AppDelegate ()
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
    
    // 初始化单例
    [self setSingleton];
    
    
    //设置友盟相关的的
    [self setUMeng];
    
    //设置爱心推
    [self setIXPushWithApplication:application options:launchOptions];
    
    //设置数据库
    [self setDatabase];
    
    //监听网络
    [GLobalRealReachability startNotifier];
    
    //设置直播环境
    [PLStreamingEnv initEnv];
    
   
    //启动个人中心的功能
    _mainVC = [[MainViewController alloc]init];
    self.window.rootViewController=_mainVC;
    
    
    
    NSDictionary *dic = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    //推送消息
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
        
        
        [NetWorking getRankLabels:^(NSDictionary *dict) {
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


#pragma mark - 初始化单例
- (void) setSingleton {

    //  初始化微信代理单例
    [WXSingleton shareInstance];
    
    //  初始化QQ代理单例
    [QQSingleton shareInstance];
    
    //  初始化新浪微博代理单例
    [WBSingleton shareInstance];
    
    //  初始化支付单例
    FTPaySingleton *singleton = [FTPaySingleton shareInstance];
    [singleton fetchBalanceFromWeb:nil];
    
}


- (void)setUMeng{
    //友盟统计
    UMConfigInstance.appKey = @"570739d767e58edb5300057b";
    [MobClick startWithConfigure:UMConfigInstance];
//    [MobClick startWithAppkey:@"570739d767e58edb5300057b" reportPolicy:BATCH   channelId:@""];
    
    //友盟反馈
    [UMFeedback setAppkey:@"570739d767e58edb5300057b"];
    
//    //友盟分享
//    [UMSocialData setAppKey:@"570739d767e58edb5300057b"];
//    
//    //设置微信AppId、appSecret，分享url
//    [UMSocialWechatHandler setWXAppId:WX_App_ID appSecret:WX_App_Secret url:@"http://www.umeng.com/social"];
    
    //设置QQ AppId、appSecret，分享url
//    [UMSocialQQHandler setQQWithAppId:QQ_App_ID appKey:QQ_App_Secret url:@"http://www.umeng.com/social"];
    
//    // 打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。需要 #import "UMSocialSinaSSOHandler.h"
//    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:WB_App_ID
//                                              secret:WB_App_Secret
//                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
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






#pragma mark -
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
//    if([UMSocialSnsService handleOpenURL:url]){
//        return YES;
//    }
    
    // 微信
    WXSingleton *wxSingleton = [WXSingleton shareInstance];
    if([WXApi handleOpenURL:url delegate:wxSingleton]){
        return YES;
    }
    
    // qq
    QQSingleton *qqSingleton = [QQSingleton shareInstance];
    if ( [QQApiInterface handleOpenURL:url delegate:qqSingleton]) {
        return YES;
    }
    
    // 微博
    WBSingleton *wbSingleton = [WBSingleton shareInstance];
    if ([WeiboSDK handleOpenURL:url delegate:wbSingleton]) {
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
    
    // 微博
    WBSingleton *wbSingleton = [WBSingleton shareInstance];
    if ([WeiboSDK handleOpenURL:url delegate:wbSingleton]) {
        return YES;
    }
    return NO;
}


- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken
{
//    NSLog(@"deviceToken:%@",deviceToken);
    NSLog(@"deviceToken:%@",deviceToken);
    //将deviceToken保存在本地
    if (deviceToken) {
        NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
//        NSLog(@"deviceToken 处理前 :%@",token);
        token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
        token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
        token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
        NSLog(@"deviceToken 处理后 :%@",token);
        [[NSUserDefaults standardUserDefaults]setObject:token forKey:@"deviceToken"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
//    [IXPushSdkApi registerDeviceToken:deviceToken
//                              channel:@"test" version:@"1.0" appId:1670128310];
    
    // 格斗东西 开发板
    [IXPushSdkApi registerDeviceToken:deviceToken
                              channel:@"test" version:@"1.0" appId:1104119343];
    
//    // 格斗东西 正式版
//    [IXPushSdkApi registerDeviceToken:deviceToken
//                              channel:@"test" version:@"1.0" appId:1229394843];
    
}


- (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error {
    
    NSLog(@"register fail********************,%@",error);
}


#pragma mark - 通知处理
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    NSLog(@"Local Notification info:%@",notification.userInfo);
    
    switch (application.applicationState) {
        case UIApplicationStateActive:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:TaskNotification object:nil];
        }
            break;
            
        case UIApplicationStateInactive:
        {
            [_mainVC pushMessage:[NSDictionary dictionaryWithObject:notification.userInfo forKey:@"click_param"]];
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

#pragma mark -
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

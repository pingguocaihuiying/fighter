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
#import "WXApi.h"
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
#import <TencentOpenAPI/TencentOAuth.h>
//#import "UMSocialQQHandler.h"
#import "WeiboSDK.h"
#import <PLStreamingKit/PLStreamingEnv.h>

//微信请求类型
typedef NS_ENUM(NSInteger, WXRequestType) {
    WXRequestTypeNone = 0,   //
    WXRequestTypeLogin,                 //微信跨界登录
    WXRequestTypeHeader,                //请求微信头像
    WXRequestTypeName,                  //请求微信昵称
    WXRequestTypeNameAndHeader,         //请求微信昵称和头像
    WXRequestTypeAll,                   //请求所有数据
};


@interface AppDelegate ()<WXApiDelegate,WeiboSDKDelegate>

@property (nonatomic, assign)WXRequestType wxRequestType;
@property (nonatomic, strong) MainViewController *mainVC;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
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

- (void) setShareSDK {
    
//    [ShareSDK registerApp:Mob_App_ID
//          activePlatforms:@[@(SSDKPlatformTypeSinaWeibo)]
//                 onImport:nil
//          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
//              
//              switch (platformType)
//              {
//                  case SSDKPlatformTypeSinaWeibo:
//                      
//                      //初始化新浪微博
//                      [appInfo SSDKSetupSinaWeiboByAppKey:WB_App_ID
//                                                appSecret:WB_App_Secret
//                                              redirectUri:@"http://www.sharesdk.cn"
//                                                 authType:SSDKAuthTypeWeb];
//                      
//                      break;
//                  default:
//                      break;
//              }
//              
//          }];
    

    
}



- (void)setWeiXin{
    //向微信注册
    [WXApi registerApp:@"wxe69b91d3503144ca" withDescription:@"wechat"];
}

#pragma mark 设置qq
- (void) setTencent {

  TencentOAuth *tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQ_App_ID andDelegate:nil]; //注册
    tencentOAuth.localAppId = @"gogogofight";
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



#pragma mark - 微信注册登录响应方法
- (void)onResp:(BaseResp *)resp {
    
    // 向微信请求授权后,得到响应结果
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *temp = (SendAuthResp *)resp;
        
        //如果
        NSLog(@"temp state: %d", temp.errCode);
        if (temp.errCode != 0) {
            return;
        }
        
        //请求头像和昵称
        if (self.wxRequestType == WXRequestTypeNameAndHeader) {
            
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
                    
//                    //存储token openid
//                    [[NSUserDefaults standardUserDefaults] setObject:tokenDic[@"access_token"] forKey:@"wxToken"];
//                    [[NSUserDefaults standardUserDefaults] setObject:tokenDic[@"openid"] forKey:@"wxOpenId"];
//                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
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
                                    NSLog(@"微信登录信息:%@",dict[@"data"][@"user"]);
                                    NSDictionary *userDic = dict[@"data"][@"user"];
                                    FTUserBean *user = [FTUserBean new];
                                    [user setValuesForKeysWithDictionary:userDic];
                                    
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
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if([UMSocialSnsService handleOpenURL:url]){
        return YES;
    }

    if([WXApi handleOpenURL:url delegate:self]){
        return YES;
    }
    
    if ([TencentOAuth HandleOpenURL:url]) {
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
    
    if ([TencentOAuth HandleOpenURL:url]) {
        return YES;
    }
    
    if ([WeiboSDK handleOpenURL:url delegate:self]) {
        return YES;
    }
    return NO;
}



- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{

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


- (void)setRootViewController2{
    FTInformationViewController *infoVC = [FTInformationViewController new];
    //    FTBaseNavigationViewController *infoNaviVC = [[FTBaseNavigationViewController alloc]initWithRootViewController:infoVC];
    infoVC.tabBarItem.title = @"拳讯";
    
    [infoVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                               Bar_Item_Select_Title_Color, UITextAttributeTextColor,
                                               nil] forState:UIControlStateSelected];
    infoVC.tabBarItem.image = [UIImage imageNamed:@"底部导航-拳讯"];
    infoVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"底部导航-拳讯pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    FTMatchViewController *matchVC = [FTMatchViewController new];
    //    FTBaseNavigationViewController *matchNaviVC = [[FTBaseNavigationViewController alloc]initWithRootViewController:matchVC];
    matchVC.tabBarItem.title = @"赛事";
    [matchVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                Bar_Item_Select_Title_Color, UITextAttributeTextColor,
                                                nil] forState:UIControlStateSelected];
    
    
    matchVC.tabBarItem.image = [UIImage imageNamed:@"底部导航-赛事"];
    matchVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"底部导航-赛事pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    FTVideoViewController *videoVC = [FTVideoViewController new];
    //    FTBaseNavigationViewController *fightKingNaviVC = [[FTBaseNavigationViewController alloc]initWithRootViewController:fightKingVC];
    videoVC.tabBarItem.title = @"视频";
    [videoVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                    Bar_Item_Select_Title_Color, UITextAttributeTextColor,
                                                    nil] forState:UIControlStateSelected];
    
    videoVC.tabBarItem.image = [UIImage imageNamed:@"底部导航-视频"];
    videoVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"底部导航-视频pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    FTCoachViewController *coachVC = [FTCoachViewController new];
    //    FTBaseNavigationViewController *coachNaviVC = [[FTBaseNavigationViewController alloc]initWithRootViewController:coachVC];
    coachVC.tabBarItem.title = @"教练";
    [coachVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                Bar_Item_Select_Title_Color, UITextAttributeTextColor,
                                                nil] forState:UIControlStateSelected];
    
    coachVC.tabBarItem.image = [UIImage imageNamed:@"底部导航-教练"];
    coachVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"底部导航-教练pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    FTBoxingHallViewController *boxingHallVC = [FTBoxingHallViewController new];
    //    FTBaseNavigationViewController *boxingHallNaviVC = [[FTBaseNavigationViewController alloc]initWithRootViewController:boxingHallVC];
    boxingHallVC.tabBarItem.title = @"拳馆";
    [boxingHallVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                     Bar_Item_Select_Title_Color, UITextAttributeTextColor,
                                                     nil] forState:UIControlStateSelected];
    
    boxingHallVC.tabBarItem.image = [UIImage imageNamed:@"底部导航-拳馆"];
    boxingHallVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"底部导航-拳馆pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    

    
        //设置tabbar的属性
    FTBaseTabBarViewController *tabBartVC = [FTBaseTabBarViewController new];
    tabBartVC.tabBar.barTintColor = [UIColor blackColor];
    tabBartVC.tabBar.translucent = NO;
//        tabBartVC.viewControllers = @[infoVC, matchVC, videoVC, coachVC, boxingHallVC];
            tabBartVC.viewControllers = @[infoVC, videoVC];
    
    FTBaseNavigationViewController *navi = [[FTBaseNavigationViewController alloc]initWithRootViewController:tabBartVC];
    self.window.rootViewController = navi;
}

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


//url转码
- (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)input,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return outputStr;
}
@end
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
#import "Mobclick.h"
#import "UMSocial.h"
#import "UMFeedback.h"
#import "WXApi.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
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

//微信请求类型
typedef NS_ENUM(NSInteger, WXRequestType) {
    WXRequestTypeNone = 0,   //
    WXRequestTypeLogin,                 //微信跨界登录
    WXRequestTypeHeader,                //请求微信头像
    WXRequestTypeName,                  //请求微信昵称
    WXRequestTypeNameAndHeader,         //请求微信昵称和头像
    WXRequestTypeAll,                   //请求所有数据
};


@interface AppDelegate ()<WXApiDelegate>

@property (nonatomic, assign)WXRequestType wxRequestType;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //设置友盟相关的的
    [self setUMeng];
    //设置微信相关的
    [self setWeiXin];
    
    //设置数据库
    [self setDatabase];
    
    //屏蔽个人中心时打开这里
//    [self setRootViewController2];

    
//    FTDrawerViewController *drawerVC = [[FTDrawerViewController alloc]init];
//    self.window.rootViewController = drawerVC;
    
    //启动个人中心的功能
    MainViewController *sl = [[MainViewController alloc]init];
//    FTBaseNavigationViewController *_navi=[[FTBaseNavigationViewController alloc]initWithRootViewController:sl];
    self.window.rootViewController=sl;
    
    return YES;
}

- (void) setDatabase {
    
    DBManager *dbManager = [DBManager shareDBManager];
    [dbManager connect];
    [dbManager createLabelsTable];
    [dbManager close];
    
}


- (void)setUMeng{
    //友盟统计
    [MobClick startWithAppkey:@"570739d767e58edb5300057b" reportPolicy:BATCH   channelId:@""];
    
    //友盟分享
    [UMSocialData setAppKey:@"570739d767e58edb5300057b"];
    
    //友盟反馈
    [UMFeedback setAppkey:@"570739d767e58edb5300057b"];
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:WX_App_ID appSecret:WX_App_Secret url:@"http://www.umeng.com/social"];
    
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。需要 #import "UMSocialSinaSSOHandler.h"
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"2201505639"
                                              secret:@"cb1771445170f9c625224f6e1403ce48"
                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
}

- (void)setWeiXin{
    //向微信注册
    [WXApi registerApp:@"wxe69b91d3503144ca" withDescription:@"wechat"];
}

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
        
        
        
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        
//        NSString *accessUrlStr = [NSString stringWithFormat:@"%@/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", WX_BASE_URL, WX_App_ID, WX_App_Secret, temp.code];
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        [manager GET:accessUrlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            
//            NSDictionary *accessDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//            //            NSLog(@"respinse dic : token : %@ openid : %@", accessDict[@"access_token"], accessDict[@"openid"]);
//            [self getWechatUserInfoWithToken:accessDict[@"access_token"] andOpenId:accessDict[@"openid"]];
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"获取access_token时出错 = %@", error);
//        }];
    }
}

//- (void)getWechatUserInfoWithToken:(NSString *)token andOpenId:(NSString *)openId{
//    NSString *stringURL = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", token, openId];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager GET:stringURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSDictionary *userInfoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        
//        for(NSString *key in [userInfoDic allKeys]){
//            NSLog(@"key:%@", key);
//        }
//        
//        NSString *openId = userInfoDic[@"openid"];
//        NSString *unionId = userInfoDic[@"unionid"];
//        NSString *timestampString = [NSString stringWithFormat:@"%.0lf",[[NSDate date] timeIntervalSince1970]];
//        NSString *imei = [UUID getUUID];
//        NSString *username = userInfoDic[@"nickname"];
//        NSString *keyToken = [NSString stringWithFormat:@"%@%@", WXLoginSecret_Key, timestampString];
//        NSString *keyTokenMD5 = [MD5 md5:keyToken];
//        NSString *province = userInfoDic[@"province"];
//        NSString *headpic = userInfoDic[@"headimgurl"];
//        headpic = [self encodeToPercentEscapeString:headpic];
//        NSString *stemfrom = @"iOS";
//        username = [username stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSDictionary *dic = @{@"openId" : openId,
//                              @"unionId" : unionId,
//                              @"timestamp" : timestampString,
//                              @"imei" : imei,
//                              @"username" : username,
//                              @"keyToken" : keyTokenMD5,
//                              @"city" : province};
//        
//        NSString *wxLoginURLString = [FTNetConfig host:Domain path:UserWXLoginURL];
//                wxLoginURLString = [NSString stringWithFormat:@"%@?openId=%@&unionId=%@&timestamp=%@&imei=%@&username=%@&keyToken=%@&city=%@&headpic=%@&stemfrom=%@", wxLoginURLString, openId, unionId, timestampString, imei, username, keyTokenMD5, province, headpic, stemfrom];
////        wxLoginURLString = [NSString stringWithFormat:@"%@?openId=%@&unionId=%@&timestamp=%@&imei=%@&username=%@&keyToken=%@&city=%@", wxLoginURLString, openId, unionId, timestampString, imei, username, keyTokenMD5, province];
//        NSLog(@"wxLoginURLString : %@", wxLoginURLString);
////        wxLoginURLString = @"www.baidu.com";
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        [manager GET:wxLoginURLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            
//            NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//                bool status = [responseJson[@"status"] boolValue];
//                NSString *message = (NSString *)(NSDictionary *)responseJson[@"message"];
//                if (status == false) {
//                    NSLog(@"微信注册失败,message:%@", message);
//    
//                    return ;
//                }
//            
//
//            NSLog(@"微信注册成功,message:%@", message);
//            NSLog(@"微信登录信息:%@",responseJson[@"data"][@"user"]);
//            NSDictionary *userDic = responseJson[@"data"][@"user"];
//            FTUserBean *user = [FTUserBean new];
//            [user setValuesForKeysWithDictionary:userDic];
//            
//            //从本地读取存储的用户信息
//            NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
//            FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
//            
//            if (localUser) {//手机已经登录
//                localUser.wxopenId = user.openId;
//                localUser.wxName = user.username;
//                localUser.wxHeaderPic = user.headpic;
//            }else {
//            
//                localUser = user;
//            }
//            
//            NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:localUser];
//            [[NSUserDefaults standardUserDefaults]setObject:userData forKey:LoginUser];
//            [[NSUserDefaults standardUserDefaults]synchronize];
//            //发送通知，告诉评论页面微信登录成功
////            [[NSNotificationCenter defaultCenter] postNotificationName:WXLoginResultNoti object:@"SUCESS"];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginAction" object:nil];
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"获取access_token时出错 = %@", error);
//            //发送通知，告诉评论页面微信登录失败
//            [[NSNotificationCenter defaultCenter]postNotificationName:WXLoginResultNoti object:@"ERROR"];
//        }];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"获取access_token时出错 = %@", error);
//    }];
//}
//


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if([UMSocialSnsService handleOpenURL:url]){
        return YES;
    }

    if([WXApi handleOpenURL:url delegate:self]){
        return YES;
    }
    if ([url.description isEqualToString:@"gogogofight://"]) {
        return YES;
    }
    return NO;
}

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
    
#pragma -mark 第一版不用tabbar，直接用拳讯作为rootVC
    
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
//
//  AppDelegate.m
//  fighter
//
//  Created by Liyz on 4/7/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "AppDelegate.h"
#import "FTInformationViewController.h"
#import "FTFightKingViewController.h"
#import "FTMatchViewController.h"
#import "FTCoachViewController.h"
#import "FTBoxingHallViewController.h"
#import "FTBaseNavigationViewController.h"
#import "FTBaseTabBarViewController.h"
#import "Mobclick.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //设置友盟相关的
    [self setUMeng];
    
    [self setRootViewController];
 
    return YES;
}

- (void)setUMeng{
    [MobClick startWithAppkey:@"570739d767e58edb5300057b" reportPolicy:BATCH   channelId:@""];
}

- (void)setRootViewController{
    FTInformationViewController *infoVC = [FTInformationViewController new];
    FTBaseNavigationViewController *infoNaviVC = [[FTBaseNavigationViewController alloc]initWithRootViewController:infoVC];
    infoNaviVC.tabBarItem.title = @"拳讯";

    [infoNaviVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                    Bar_Item_Select_Title_Color, UITextAttributeTextColor,
                                                   nil] forState:UIControlStateSelected];
    infoNaviVC.tabBarItem.image = [UIImage imageNamed:@"底部导航-拳讯"];
    infoNaviVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"底部导航-拳讯pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    FTMatchViewController *matchVC = [FTMatchViewController new];
    FTBaseNavigationViewController *matchNaviVC = [[FTBaseNavigationViewController alloc]initWithRootViewController:matchVC];
    matchNaviVC.tabBarItem.title = @"赛事";
    [matchNaviVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   Bar_Item_Select_Title_Color, UITextAttributeTextColor,
                                                   nil] forState:UIControlStateSelected];

    
    matchNaviVC.tabBarItem.image = [UIImage imageNamed:@"底部导航-赛事"];
    matchNaviVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"底部导航-赛事pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    FTFightKingViewController *fightKingVC = [FTFightKingViewController new];
    FTBaseNavigationViewController *fightKingNaviVC = [[FTBaseNavigationViewController alloc]initWithRootViewController:fightKingVC];
    fightKingNaviVC.tabBarItem.title = @"格斗王";
    [fightKingNaviVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   Bar_Item_Select_Title_Color, UITextAttributeTextColor,
                                                   nil] forState:UIControlStateSelected];

    fightKingNaviVC.tabBarItem.image = [UIImage imageNamed:@"底部导航-格斗王"];
    fightKingNaviVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"底部导航-格斗王pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    FTCoachViewController *coachVC = [FTCoachViewController new];
    FTBaseNavigationViewController *coachNaviVC = [[FTBaseNavigationViewController alloc]initWithRootViewController:coachVC];
    coachNaviVC.tabBarItem.title = @"教练";
    [coachNaviVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   Bar_Item_Select_Title_Color, UITextAttributeTextColor,
                                                   nil] forState:UIControlStateSelected];

    coachNaviVC.tabBarItem.image = [UIImage imageNamed:@"底部导航-教练"];
    coachNaviVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"底部导航-教练pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    FTBoxingHallViewController *boxingHallVC = [FTBoxingHallViewController new];
    FTBaseNavigationViewController *boxingHallNaviVC = [[FTBaseNavigationViewController alloc]initWithRootViewController:boxingHallVC];
    boxingHallNaviVC.tabBarItem.title = @"拳馆";
    [boxingHallNaviVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   Bar_Item_Select_Title_Color, UITextAttributeTextColor,
                                                   nil] forState:UIControlStateSelected];

    boxingHallNaviVC.tabBarItem.image = [UIImage imageNamed:@"底部导航-拳馆"];
    boxingHallNaviVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"底部导航-拳馆pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //设置tabbar的属性
    FTBaseTabBarViewController *rootVC = [FTBaseTabBarViewController new];
//    rootVC.tabBar.barStyle = UIBarStyleDefault;
    rootVC.tabBar.barTintColor = [UIColor blackColor];
//    rootVC.tabBar.tintColor = [UIColor grayColor];
    rootVC.tabBar.translucent = NO;
    
    rootVC.viewControllers = @[infoNaviVC, matchNaviVC, fightKingNaviVC, coachNaviVC, boxingHallNaviVC];
    
    self.window.rootViewController = rootVC;
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

@end

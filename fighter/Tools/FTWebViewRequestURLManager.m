//
//  FTWebViewRequestURLManager.m
//  fighter
//
//  Created by 李懿哲 on 05/01/2017.
//  Copyright © 2017 Mapbar. All rights reserved.
//

#import "FTWebViewRequestURLManager.h"
#import "FTHomepageMainViewController.h"
#import "FTCommentViewController.h"

@implementation FTWebViewRequestURLManager
+ (void) managerURLRequest:(NSURLRequest *)request withViewController:(UIViewController *)viewController{
    NSString *requestURL = [NSString stringWithFormat:@"%@", request.URL];
    NSLog(@"requestURL : %@", requestURL);
    
    if ([requestURL isEqualToString:@"js-call:onload"]) {//加载完成
        if ([viewController respondsToSelector:@selector(disableLoadingAnimation)]) {
            [viewController performSelector:@selector(disableLoadingAnimation)];
        }
    }else if ([requestURL isEqualToString:@"js-call:setVideoUrl"]) {//付费视频传url
        if ([viewController respondsToSelector:@selector(setWebViewUrl)]) {
            [viewController performSelector:@selector(setWebViewUrl)];
        }
    }else if ([requestURL hasPrefix:@"js-call:userId="]) {//用户头像
        NSString *userId = [requestURL stringByReplacingOccurrencesOfString:@"js-call:userId=" withString:@""];
        //        NSLog(@"userId : %@", userId);
        FTHomepageMainViewController *homepageMainVC = [FTHomepageMainViewController new];
        homepageMainVC.olduserid = userId;
        [viewController.navigationController pushViewController:homepageMainVC animated:YES];
    }else  if ([requestURL hasPrefix:@"js-call:goGym?corId="]) {//拳馆
        NSString *corId = [requestURL stringByReplacingOccurrencesOfString:@"js-call:goGym?corId=" withString:@""];
        NSDictionary *dic = @{@"type":@"gym",
                              @"corporationid":corId
                              };
        [FTNotificationTools postTabBarIndex:2 dic:dic];
    }else  if ([requestURL hasPrefix:@"js-call:goCoach?corId="]) {//预约私教
        
        NSArray *array = [requestURL componentsSeparatedByString:@"&"];
        NSString *corId = [array[0] stringByReplacingOccurrencesOfString:@"js-call:goCoach?corId=" withString:@""];
        NSString *coachId = [array[1] stringByReplacingOccurrencesOfString:@"coachId=" withString:@""];
        
        NSDictionary *dic = @{@"type":@"coach",
                              @"corporationid":corId,
                              @"coachId":coachId
                              };
        [FTNotificationTools postTabBarIndex:2 dic:dic];
    }else  if ([requestURL hasPrefix:@"js-call:goShop?"]) {//商城
        
        NSArray *array = [requestURL componentsSeparatedByString:@"&"];
        NSString *goodId = [array[0] stringByReplacingOccurrencesOfString:@"js-call:goShop?goodId=" withString:@""];
        NSString *corporationId = [array[1] stringByReplacingOccurrencesOfString:@"corId=" withString:@""];
        
        if ([goodId isEqualToString:@"0"]) {
            NSDictionary *dic = @{@"type":@"home",
                                  @"goodId":goodId,
                                  @"corporationid":corporationId
                                  };
            [FTNotificationTools postSwitchShopHomeNotiWithDic:dic];
        }else {
            NSDictionary *dic = @{@"type":@"detail",
                                  @"goodId":goodId,
                                  @"corporationid":corporationId
                                  };
            [FTNotificationTools postSwitchShopDetailControllerWithDic:dic];
        }
    }else  if ([requestURL hasPrefix:@"js-call:reComment="]) {//评论评论
        NSArray *array = [requestURL componentsSeparatedByString:@"&"];
        NSString *userId = [array[1] stringByReplacingOccurrencesOfString:@"userId=" withString:@""];
        NSString *userName = [array[2] stringByReplacingOccurrencesOfString:@"userName=" withString:@""];
        NSString *parentId = [array[3] stringByReplacingOccurrencesOfString:@"parentId=" withString:@""];//留着扩展用
        NSLog(@"userId:%@,userName:%@, parentId:%@", userId, userName, parentId);
        if ([viewController respondsToSelector:@selector(pushToCommentVCWithUserId:andUserName:)]) {
            [viewController performSelector:@selector(pushToCommentVCWithUserId:andUserName:) withObject:userId withObject:userName];
        }
    }

}

@end

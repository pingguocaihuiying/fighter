//
//  FTLocalNotification.m
//  fighter
//
//  Created by kang on 16/8/24.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTLocalNotification.h"

@implementation FTLocalNotification

// 注册东西任务本地通知
+ (void) registTaskNotification {

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSDate *now = [formatter dateFromString:@"18:10:00"];//触发通知的时间

    UILocalNotification *noti = [[UILocalNotification alloc] init];
    
    if (noti) {
        
        //设置推送时间
        noti.fireDate = now;//=now
        //设置时区
        noti.timeZone = [NSTimeZone defaultTimeZone];
        //设置重复间隔
        noti.repeatInterval = NSCalendarUnitDay;//NSCalendarUnitMinute ,NSCalendarUnitDay
        //推送声音
        noti.soundName = UILocalNotificationDefaultSoundName;
        
        
        //内容
        noti.alertBody = @"今日东西任务已经刷新，赶紧去赚积分吧！";
        
        //设置userinfo 方便在之后需要撤销的时候使用
        NSDictionary *infoDic = [NSDictionary dictionaryWithObject:@"taskLocalNotification" forKey:@"taskLocalNotification"];
        noti.userInfo = infoDic;
        
        //添加推送到uiapplication
        UIApplication *app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:noti];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@"taskNotification" forKey:@"taskNotification"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


// 取消东西任务本地通知
+ (void) cancelTaskNotification {

    
    UIApplication *app = [UIApplication sharedApplication];
    
    //获取本地推送数组
    NSArray *localArr = [app scheduledLocalNotifications];
    
    if (localArr) {
        
        for (UILocalNotification *noti in localArr) {
            
            NSDictionary *dict = noti.userInfo;
            
            if (dict) {
                
                NSString *inKey = [dict objectForKey:@"taskLocalNotification"];
                
                if ([inKey isEqualToString:@"taskLocalNotification"]) {
                    
                    [app cancelLocalNotification:noti];
                    break;
                }
            }
        }
        
     }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"taskNotification"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


@end

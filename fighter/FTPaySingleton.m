//
//  FTPaySingleton.m
//  fighter
//
//  Created by kang on 16/7/20.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTPaySingleton.h"

static FTPaySingleton * singleton = nil;

@implementation FTPaySingleton

#pragma mark - 初始化单例
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [super allocWithZone:zone];
    });
    return singleton;
}

+ (instancetype) shareInstance {
    return [self allocWithZone:nil];
}

- (id) copyWithZone:(NSZone *)zone;{
    return self;
}

#pragma mark - 注册通知
- (void) registNotifacation {

    //添加监听器，充值购买
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshBalance:) name:RechargeResultNoti object:nil];
}

#pragma mark - 余额

// 刷新余额
- (void) refreshBalance:(NSNotification *)noti {
    
    [self fetchBalanceFromWeb:nil];
}


- (void) fetchBalanceFromWeb:(void (^)(void))option {
    
    //判断是否登录
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    if (localUserData == nil ) {
        return;
    }
    
    // 获取余额
    [NetWorking queryMoneyWithOption:^(NSDictionary *dict) {
        
        NSLog(@"dict:%@",dict);
        if ([dict[@"status"] isEqualToString:@"success"] && dict[@"data"]) {
            
            NSDictionary *dic = dict[@"data"];
            
            NSInteger taskTotal = [dic[@"taskTotal"] integerValue];
            NSInteger otherTotal = [dic[@"otherTotal"] integerValue];
            NSInteger cost = [dic[@"cost"] integerValue];
            self.balance = taskTotal+otherTotal-cost;
            
            if (option) {
                option();
            }
           
        }else {
            
            NSLog(@"message:%@",[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
        }
    }];
}

@end

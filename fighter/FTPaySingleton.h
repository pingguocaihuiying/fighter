//
//  FTPaySingleton.h
//  fighter
//
//  Created by kang on 16/7/20.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTPaySingleton : NSObject

@property (assign)NSInteger balance;// 账户余额


+ (instancetype) shareInstance;



- (void) fetchBalanceFromWeb:(void (^)(void))option;

- (void) payRequest:(NSSet *) productIdentifiers buyType:(int) buytpye;

@end

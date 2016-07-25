//
//  WBSingleton.h
//  fighter
//
//  Created by kang on 16/7/25.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"

@interface WBSingleton : NSObject <WeiboSDKDelegate>

+ (instancetype) shareInstance;

@end

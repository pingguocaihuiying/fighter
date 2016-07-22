//
//  WXSingleton.h
//  fighter
//
//  Created by kang on 16/7/22.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@interface WXSingleton : NSObject <WXApiDelegate>

+(instancetype) shareInstance;

@end

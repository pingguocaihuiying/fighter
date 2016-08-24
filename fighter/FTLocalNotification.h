//
//  FTLocalNotification.h
//  fighter
//
//  Created by kang on 16/8/24.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTLocalNotification : NSObject

+ (void) registTaskNotification;

+ (void) cancelTaskNotification;
@end

//
//  FTUserTools.h
//  fighter
//
//  Created by Liyz on 5/18/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTUserBean.h"

@interface FTUserTools : NSObject
+ (FTUserBean *)getLocalUser;



/**
 发一条送用户注销的通知
 */
+ (void)sendSignOutNotification;
@end

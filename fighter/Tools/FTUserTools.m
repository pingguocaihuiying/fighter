//
//  FTUserTools.m
//  fighter
//
//  Created by Liyz on 5/18/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTUserTools.h"

@implementation FTUserTools

+ (FTUserBean *)getLocalUser{
    FTUserBean *localUser = [FTUserBean loginUser];
    return localUser;
}
+ (void)sendSignOutNotification{
    [[NSNotificationCenter defaultCenter]postNotificationName:USER_SIGN_OUT object:nil];
}
@end

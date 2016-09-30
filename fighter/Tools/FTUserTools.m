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
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    return localUser;
}
+ (void)sendSignOutNotification{
    [[NSNotificationCenter defaultCenter]postNotificationName:USER_SIGN_OUT object:nil];
}
@end

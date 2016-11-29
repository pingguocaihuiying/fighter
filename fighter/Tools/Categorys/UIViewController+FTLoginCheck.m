//
//  UIViewController+FTLoginCheck.m
//  fighter
//
//  Created by 李懿哲 on 29/11/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "UIViewController+FTLoginCheck.h"

@implementation UIViewController (FTLoginCheck)

- (BOOL)isLogin{
    FTUserBean *localUserBean = [FTUserTools getLocalUser];
    if (localUserBean) {
        return YES;
    } else {
        [FTTools loginwithVC:self];
        return NO;
    }
}

@end

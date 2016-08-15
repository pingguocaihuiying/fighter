//
//  UIWindow+MBProgressHUD.h
//  fighter
//
//  Created by kang on 16/5/5.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (MBProgressHUD)

- (void)showHUDWithMessage:(NSString *)message;

- (void) addLabelWithMessage:(NSString *)message second:(NSInteger) second;

@end

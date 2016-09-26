//
//  UIView+MBProgressHUD.h
//  fighter
//
//  Created by kang on 16/8/13.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MBProgressHUD)


- (void)showMessage:(NSString *)message  second:(NSInteger) second;

- (void) addLabelWithMessage:(NSString *)message second:(NSInteger) second;

- (void) showMessage:(NSString *)message;
@end

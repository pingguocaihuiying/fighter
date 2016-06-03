//
//  UIWindow+MBProgressHUD.m
//  fighter
//
//  Created by kang on 16/5/5.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "UIWindow+MBProgressHUD.h"
#import "MBProgressHUD.h"

@implementation UIWindow (MBProgressHUD)

- (void)showHUDWithMessage:(NSString *)message{
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self];
    [self addSubview:HUD];
//    HUD.label.text = message;
    HUD.labelText = message;
//    HUD.label.numberOfLines = 0;
    
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
//    [HUD.customView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"弹出框背景"]]];
    dispatch_block_t block = ^{
    
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  2* NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        });
    };
//    [HUD showAnimated:YES whileExecutingBlock:block];
    [HUD show:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  2* NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//        [HUD removeFromSuperview];
        [HUD hide:YES];
    });
}



@end

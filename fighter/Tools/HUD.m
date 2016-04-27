//
//  HUD.m
//  renzhenzhuan
//
//  Created by Liyz on 4/7/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "HUD.h"


@implementation HUD
+ (void)showMessage:(NSString *)message inView:(UIView *)view{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    hud.labelText = message;
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
    
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [hud removeFromSuperview];
//        self->hud = nil;
    }];

}

@end

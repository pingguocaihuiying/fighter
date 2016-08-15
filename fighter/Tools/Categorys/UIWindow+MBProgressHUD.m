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
//    dispatch_block_t block = ^{
//    
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  2* NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//        });
//    };
//    [HUD showAnimated:YES whileExecutingBlock:block];
    [HUD show:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  2* NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//        [HUD removeFromSuperview];
        [HUD hide:YES];
    });
}


- (void) addLabelWithMessage:(NSString *)message second:(NSInteger) second {
    
    CGFloat width = SCREEN_WIDTH - 80*SCALE;
    
    UILabel *detailsLabel = [[UILabel alloc] init];
    detailsLabel.font = [UIFont boldSystemFontOfSize:16.0];
    detailsLabel.adjustsFontSizeToFitWidth = NO;
    detailsLabel.textAlignment = NSTextAlignmentCenter;
    detailsLabel.opaque = NO;
    //    detailsLabel.backgroundColor = [UIColor clearColor];
    detailsLabel.textColor = [UIColor whiteColor];
    detailsLabel.numberOfLines = 0;
    detailsLabel.text = message;
    
    CGSize size =  [message sizeWithAttributes:@{NSFontAttributeName:detailsLabel.font}];
    
    CGFloat mod = fmod(size.width, width);
    UIImageView *imageView;
    CGFloat height = 0.0;
    
    if (mod == 0) {
        height = size.height * (size.width/width);
    }else {
        height = size.height * (size.width/width +1);
    }
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-width)/2 -8 ,(SCREEN_HEIGHT-height -80 )-15,width +16, height +30)];
    detailsLabel.frame = CGRectMake(8,15,width, height);
    
    imageView.image = [UIImage imageNamed:@"弹出框背景ios"];
    
    [self addSubview:imageView];
    [imageView addSubview:detailsLabel];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  second * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        [imageView removeFromSuperview];
        
    });
}



@end

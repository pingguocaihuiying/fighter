//
//  UIView+MBProgressHUD.m
//  fighter
//
//  Created by kang on 16/8/13.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "UIView+MBProgressHUD.h"
#import "MBProgressHUD.h"

@implementation UIView (MBProgressHUD)


- (void)showMessage:(NSString *)message  second:(NSInteger) second {
    
//    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self];
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT/3)];
    [self addSubview:HUD];
    HUD.detailsLabelText = message;
    HUD.detailsLabelFont = [UIFont boldSystemFontOfSize:16.0];
//    HUD.labelText = message;
    HUD.yOffset = 100;
    
//    HUD.label.numberOfLines = 0;
    
    HUD.mode = MBProgressHUDModeText;
//    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
   
    [HUD show:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  second * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        [HUD removeFromSuperview];
        
    });
}



- (void) addLabelWithMessage:(NSString *)message second:(NSInteger) second {

    CGFloat width = SCREEN_WIDTH - 80*SCALE;
    
    UILabel *detailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, SCREEN_HEIGHT/2 + 100, SCREEN_WIDTH-120, SCREEN_HEIGHT/4)];
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
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-width)/2 -8 ,(SCREEN_HEIGHT-height -20 )-15,width +16, height +30)];
    detailsLabel.frame = CGRectMake(8,15,width, height);
    
    imageView.image = [UIImage imageNamed:@"弹出框背景ios"];
    
    [self addSubview:imageView];
    [imageView addSubview:detailsLabel];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  second * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        [imageView removeFromSuperview];
        
    });
}

- (void) showMessage:(NSString *)message {
    
    CGFloat width = SCREEN_WIDTH - 80*SCALE;
    
    UILabel *detailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, SCREEN_HEIGHT/2 + 100, SCREEN_WIDTH-120, SCREEN_HEIGHT/4)];
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
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-width)/2 -8 ,SCREEN_HEIGHT/2,width +16, height +30)];
    detailsLabel.frame = CGRectMake(8,15,width, height);
    
    imageView.image = [UIImage imageNamed:@"弹出框背景ios"];
    
    [self addSubview:imageView];
    [imageView addSubview:detailsLabel];
    
    [self addLabelConstraint:detailsLabel toItem:imageView];
    [self addImageViewConstraint:imageView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        [imageView removeFromSuperview];
        
    });
}




- (void) addImageViewConstraint:(UIImageView *) imageView {
    
    [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:imageView
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeCenterX
                                                                        multiplier:1.0
                                                                          constant:0];
    
    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:imageView
                                                                          attribute:NSLayoutAttributeCenterY
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self
                                                                          attribute:NSLayoutAttributeCenterY
                                                                         multiplier:1.0
                                                                           constant:0];
    

    
    [self addConstraint:centerXConstraint];
    [self addConstraint:centerYConstraint];
    
}

- (void) addLabelConstraint:(UILabel *) label toItem:(UIView *) itemView {
    
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:label
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:itemView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:15];
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:label
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:itemView
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:15];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:label
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:itemView
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0
                                                                        constant:-15];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:label
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:itemView
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0
                                                                        constant:-15];
    
    [self addConstraint:topConstraint];
    [self addConstraint:leftConstraint];
    [self addConstraint:rightConstraint];
    [self addConstraint:bottomConstraint];
}

@end

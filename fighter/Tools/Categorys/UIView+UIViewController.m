//
//  UIView+UIViewController.m
//  fighter
//
//  Created by kang on 16/8/22.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "UIView+UIViewController.h"

@implementation UIView (UIViewController)
@dynamic viewController;

- (UIViewController *)viewController {
    UIResponder *next = [self nextResponder];
    
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        
        next = [next nextResponder];
    } while (next != nil); 
    
    return nil; 
} 

@end

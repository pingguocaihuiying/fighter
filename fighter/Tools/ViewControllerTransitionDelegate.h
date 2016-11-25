//
//  ViewControllerTransitionDelegate.h
//  fighter
//
//  Created by kang on 2016/11/25.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/**
 View Controller 转场代理
 */
@protocol ViewControllerTransitionDelegate <NSObject>
@optional
- (void) pushToController:(UIViewController *) viewController;
- (void) pressentController:(UIViewController *) viewController;

@end

//
//  PushDelegate.h
//  fighter
//
//  Created by kang on 16/8/4.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PushDelegate <NSObject>

- (void) pushToController:(UIViewController *) viewController;

@end
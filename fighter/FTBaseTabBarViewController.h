//
//  BaseTabBarViewController.h
//  fighter
//
//  Created by Liyz on 4/8/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTDynamicsDrawerViewController.h"

@interface FTBaseTabBarViewController : UITabBarController

@property (nonatomic, weak) id<FTDynamicsTransDelegate> drawerDelegate;

@end

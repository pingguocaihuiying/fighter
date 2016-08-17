//
//  BaseTabBarViewController.h
//  fighter
//
//  Created by Liyz on 4/8/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTDynamicsDrawerViewController.h"
#import "OpenSliderDelegate.h"

@interface FTBaseTabBarViewController : UITabBarController

@property (nonatomic, weak) id<FTDynamicsTransDelegate> drawerDelegate;
@property (nonatomic,weak) id<OpenSliderDelegate> openSliderDelegate;

@end

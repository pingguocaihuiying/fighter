//
//  BaseViewController.h
//  fighter
//
//  Created by Liyz on 4/8/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTDynamicsDrawerViewController.h"
#import "FTBaseBean.h"

@interface FTBaseViewController : UIViewController

@property (nonatomic, weak) id<FTDynamicsTransDelegate> drawerDelegate;

@property (nonatomic, strong)FTBaseBean *bean;



@end

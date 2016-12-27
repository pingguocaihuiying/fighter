//
//  FTOrderCoachViewController.h
//  fighter
//
//  Created by 李懿哲 on 27/09/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"
#import "FTGymDetailBean.h"
#import "FTCoachBean.h"

@interface FTOrderCoachViewController : FTBaseViewController
@property (nonatomic, strong) FTCoachBean *coachBean;
@property (nonatomic, assign) int gymOpenItem;
@end

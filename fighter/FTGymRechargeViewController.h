//
//  FTGymRechargeViewController.h
//  fighter
//
//  Created by kang on 2016/9/27.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"

@interface FTGymRechargeViewController : FTBaseViewController

@property (weak, nonatomic) IBOutlet UILabel *blanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *rechargeLabel;
@property (weak, nonatomic) IBOutlet UIButton *subButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *rechargeButton;

@property (nonatomic, assign) NSInteger corporationId;

@end

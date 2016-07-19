//
//  FTGymDetailViewController.h
//  fighter
//
//  Created by Liyz on 7/1/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"
#import "FTTimeSectionTableView.h"

@interface FTGymDetailViewController : FTBaseViewController
@property (weak, nonatomic) IBOutlet UIButton *adjustTicketButton;
@property (nonatomic, copy) NSString *basicPrice;//门票基础价格（拳馆方设定）
@property (nonatomic, copy) NSString *extraPrice;//门票额外价格（发起比赛人设定）

@property (nonatomic, copy) NSString *gymName;//拳馆名字
@property (nonatomic, copy) NSString *gymID;//拳馆id

@property (weak, nonatomic) IBOutlet FTTimeSectionTableView *t0;
@property (weak, nonatomic) IBOutlet FTTimeSectionTableView *t1;
@property (weak, nonatomic) IBOutlet FTTimeSectionTableView *t2;
@property (weak, nonatomic) IBOutlet FTTimeSectionTableView *t3;
@property (weak, nonatomic) IBOutlet FTTimeSectionTableView *t4;
@property (weak, nonatomic) IBOutlet FTTimeSectionTableView *t5;
@property (weak, nonatomic) IBOutlet FTTimeSectionTableView *t6;

@property (weak, nonatomic) IBOutlet UIImageView *gymImage;
@end

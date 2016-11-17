//
//  UserCenterViewController.h
//  fighter
//
//  Created by kang on 16/5/5.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"
#import "FTUserViewController.h"
#import "PushDelegate.h"


@interface FTUserCenterViewController : FTUserViewController <PushDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) NSString *navigationSkipType;
@end

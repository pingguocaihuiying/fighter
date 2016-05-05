//
//  UserCenterViewController.h
//  fighter
//
//  Created by kang on 16/5/5.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"

@interface FTUserCenterViewController : FTBaseViewController

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIButton *avatarBtn;

@property (weak, nonatomic) IBOutlet UIImageView *centerImageView;

@property (weak, nonatomic) IBOutlet UIImageView *footerImageView;


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

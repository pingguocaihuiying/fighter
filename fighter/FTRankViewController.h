//
//  FTRankViewController.h
//  fighter
//
//  Created by kang on 16/5/13.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTRankBaseViewController.h"

@interface FTRankViewController : FTRankBaseViewController < UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIImageView *tableImageView;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

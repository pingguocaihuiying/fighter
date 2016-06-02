//
//  FTWeixinInfoVC.h
//  fighter
//
//  Created by kang on 16/5/9.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"
#import "FTUserViewController.h"
@interface FTWeixinInfoVC : FTUserViewController

@property (weak, nonatomic) IBOutlet UIImageView *wXHeaderImageView;

@property (weak, nonatomic) IBOutlet UILabel *wXNameLabel;

@property (nonatomic, copy) NSString *headerUrl;

@property (nonatomic, copy) NSString *username;

@end

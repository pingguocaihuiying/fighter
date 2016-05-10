//
//  FTWeixinInfoVC.h
//  fighter
//
//  Created by kang on 16/5/9.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"

@interface FTWeixinInfoVC : FTBaseViewController

@property (weak, nonatomic) IBOutlet UIImageView *wXHeaderImageView;

@property (weak, nonatomic) IBOutlet UILabel *wXNameLabel;

@property (nonatomic, copy) NSString *headerUrl;

@property (nonatomic, copy) NSString *username;

@end

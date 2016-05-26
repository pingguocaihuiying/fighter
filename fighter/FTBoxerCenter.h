//
//  FTBoxerCenterViewController.h
//  fighter
//
//  Created by kang on 16/5/20.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTRankBaseViewController.h"

@interface FTBoxerCenter : FTRankBaseViewController
@property (weak, nonatomic) IBOutlet UIView *headerBackground;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;


@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UIImageView *borderImageView;

@property (weak, nonatomic) IBOutlet UIButton *focusBtn;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *focusLabel;

@property (weak, nonatomic) IBOutlet UILabel *fansLabel;

@property (weak, nonatomic) IBOutlet UILabel *briefLabel;

@end

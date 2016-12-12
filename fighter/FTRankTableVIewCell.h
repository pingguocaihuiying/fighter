//
//  FTRankTableVIewCell.h
//  fighter
//
//  Created by kang on 16/5/16.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTRankTableVIewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *heightLabel;

@property (weak, nonatomic) IBOutlet UILabel *weightLabel;

@property (weak, nonatomic) IBOutlet UILabel *rankLabel;

@property (weak, nonatomic) IBOutlet UILabel *NOLabel;


// 胜 负 平 KO
@property (weak, nonatomic) IBOutlet UILabel *winLabel;
@property (weak, nonatomic) IBOutlet UILabel *loseLabel;
@property (weak, nonatomic) IBOutlet UILabel *tieLabel;
@property (weak, nonatomic) IBOutlet UILabel *KOLabel;

@property (weak, nonatomic) IBOutlet UILabel *winTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *loseTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *tieTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *KOTextLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarMaskWidthConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarMaskHeightConstraint;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *winTextTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loseTextTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tieTextTrailingConstraint;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *KOTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *NOLeadingConstraint;

@end

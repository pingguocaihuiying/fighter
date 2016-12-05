//
//  FTRankHeaderCell.h
//  fighter
//
//  Created by kang on 16/5/17.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>



/**
排行榜冠军cell
 */
@interface FTRankHeaderCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *heightLabel;

@property (weak, nonatomic) IBOutlet UILabel *weightLabel;

@property (weak, nonatomic) IBOutlet UILabel *briefLabel;

// 胜 负 平 KO
@property (weak, nonatomic) IBOutlet UILabel *winLabel;
@property (weak, nonatomic) IBOutlet UILabel *loseLabel;
@property (weak, nonatomic) IBOutlet UILabel *tieLabel;
@property (weak, nonatomic) IBOutlet UILabel *KOLabel;


- (void) setBriefLabelText:(NSString *)text;
@end

//
//  FTGymCell.h
//  fighter
//
//  Created by kang on 16/6/24.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTRatingBar.h"

@interface FTGymCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *subtitle;

@property (weak, nonatomic) IBOutlet UIView *labelsView;
/**
 距离label
 */
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
/**
 rangting bar view
 */
@property (weak, nonatomic) IBOutlet FTRatingBar *ratingBar;

/**
 评论人数 label
 */
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

/**
 会员人数label
 */
@property (weak, nonatomic) IBOutlet UILabel *memberLabel;

- (void) labelsViewAdapter:(NSString *) labelsString;

- (CGFloat) caculateHeight:(NSString *) labelsString;

- (void) clearLabelView ;

@end

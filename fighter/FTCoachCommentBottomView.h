//
//  FTCoachCommentBottomView.h
//  fighter
//
//  Created by 李懿哲 on 10/11/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTRatingBar.h"

@interface FTCoachCommentBottomView : UIView

@property (strong, nonatomic) IBOutlet UILabel *commentContentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *coachHeaderImageView;
@property (strong, nonatomic) IBOutlet UILabel *coachNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet FTRatingBar *ratingBar;
@property (weak, nonatomic) IBOutlet UILabel *hasCommentedLabel;//已评价label

@end

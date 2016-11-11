//
//  FTTraineeSkillCell.h
//  fighter
//
//  Created by kang on 2016/11/1.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTBaseTableViewCell.h"
#import "FTRatingBar.h"
#import "FTTraineeSkillBean.h"

@interface FTTraineeSkillCell : FTBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *skillLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;

@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *skillLabelWidthConstraint;
@property (weak, nonatomic) IBOutlet FTRatingBar *ratingBar;

- (void)setWithBean:(FTTraineeSkillBean *)bean;

@end

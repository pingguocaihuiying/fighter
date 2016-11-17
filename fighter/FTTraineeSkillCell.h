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
#import "FTUserSkillBean.h"

@interface FTTraineeSkillCell : FTBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *skillLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;

@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *skillLabelWidthConstraint;
@property (weak, nonatomic) IBOutlet FTRatingBar *ratingBar;
@property (strong, nonatomic) IBOutlet UIImageView *redPoint;
@property (strong, nonatomic) UILabel *increaseLabel;//增加的技能点数
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *increaseLabelBottomSpace;
@property (nonatomic, strong) FTUserSkillBean *skillBean;

- (void)setWithBean:(FTTraineeSkillBean *)bean;
- (void)setWithSkillBean:(FTUserSkillBean *) skillBean;
- (void)setWithSkillNewBean:(FTUserSkillBean *)skillBeanNew andSkillOldBean:(FTUserSkillBean *)skillBeanOld;

@end

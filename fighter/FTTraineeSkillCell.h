//
//  FTTraineeSkillCell.h
//  fighter
//
//  Created by kang on 2016/11/1.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTBaseTableViewCell.h"

@interface FTTraineeSkillCell : FTBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *skillLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *levelImage1;
@property (weak, nonatomic) IBOutlet UIImageView *levelImage2;
@property (weak, nonatomic) IBOutlet UIImageView *levelImage3;
@property (weak, nonatomic) IBOutlet UIImageView *levelImage4;
@property (weak, nonatomic) IBOutlet UIImageView *levelImage5;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *skillLabelWidthConstraint;


@end

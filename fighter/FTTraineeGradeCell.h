//
//  FTTraineeGradeCell.h
//  fighter
//
//  Created by kang on 2016/11/1.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTTraineeSkillBean.h"
#import "FTCourseHeaderFile.h"

@interface FTTraineeGradeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *skillLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;

@property (weak, nonatomic) IBOutlet UILabel *editableGradeLabel;

@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *subButton;

@property (weak, nonatomic) IBOutlet UIView *bottomLine;

- (void)setWithBean:(FTTraineeSkillBean *)bean block:(EditSkillBlock) block;

@property (nonatomic, strong) FTTraineeSkillBean *skillBean;
@property (nonatomic, assign) NSInteger skillState;
@property (nonatomic, copy) EditSkillBlock editSkillBlock;
@property (nonatomic, copy) TransmitParamsBlock transimitBlock;
@property (nonatomic, assign) NSInteger paramsNum;
@end

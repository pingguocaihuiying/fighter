//
//  FTTraineeGradeCell.m
//  fighter
//
//  Created by kang on 2016/11/1.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTTraineeGradeCell.h"

@implementation FTTraineeGradeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    self.bottomLine.backgroundColor = Cell_Space_Color;
    [self.editableGradeLabel setText:@"未评"];
    self.skillState = 0;
    
    __weak typeof(self) weakself = self;
    self.transimitBlock = ^(NSMutableDictionary *dic) {
        weakself.paramsNum = dic.allKeys.count;
    };
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setWithBean:(FTTraineeSkillBean *)bean block:(EditSkillBlock) block{
    
    self.editSkillBlock = block;
    self.skillBean = bean;
    self.skillLabel.text = bean.name;
    self.gradeLabel.text = [NSString stringWithFormat:@"%ld",bean.score];
    
}

- (void) setEditableGradeLabelText:(NSInteger)state {
    self.editableGradeLabel.text = [self editSkillGrade:state];
//    self.skillBean.score = state;
    self.gradeLabel.text = [NSString stringWithFormat:@"%ld",self.skillBean.score +state];
}


/**
 评分 减按钮响应事件

 @param sender
 */
- (IBAction)subButtonAction:(id)sender {
    _skillState --;
    
    if (_skillState <-1) {
        _skillState = -1;
    }
    
    [self runEditSkillBlock:_skillState];
}

/**
 评分 加按钮响应事件
 
 @param sender
 */
- (IBAction)addButtonAction:(id)sender {
    _skillState ++;
    
    if (_skillState > 2) {
        _skillState = 2;
    }
    
    [self runEditSkillBlock:_skillState];
    
}


/**
 将评分值返回 View Controller

 @param skillState 评分变化值
 */
- (void) runEditSkillBlock:(NSInteger)skillState {

    if (self.editSkillBlock) {
        NSString *value = [NSString stringWithFormat:@"%ld",skillState];
        BOOL isSet = self.editSkillBlock(self.skillBean.name ,value);
        if (isSet) {
            [self setEditableGradeLabelText:skillState];
        }
    }
}



/**
 设置评分值

 @param skillState 评分变化值
 */
- (void) setSkillState:(NSInteger)skillState {
    
    if (_skillState != skillState) {
        _skillState = skillState;
        self.editableGradeLabel.text = [self editSkillGrade:skillState];
        self.skillBean.score += skillState;
        self.gradeLabel.text = [NSString stringWithFormat:@"%ld",self.skillBean.score];
    }
}


/**
 评分值对应评价

 @param state 评分变化值

 @return 评分值对应评价字符串
 */
- (NSString *) editSkillGrade:(NSInteger) state {
    
    NSString *editeGrade;
    if (state == -1) {
        editeGrade = @"差";
    }else if (state == 0) {
        editeGrade = @"一般";
    }else if (state == 1) {
        editeGrade = @"好";
    }else if (state == 2) {
        editeGrade = @"极好";
    }
    
    return editeGrade;
}



@end

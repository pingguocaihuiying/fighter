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


- (IBAction)subButtonAction:(id)sender {
    _skillState --;
    
    if (_skillState <-1) {
        _skillState = -1;
    }
    if (self.editSkillBlock) {
        NSString *value = [NSString stringWithFormat:@"%ld",_skillState];
        BOOL isSet = self.editSkillBlock(self.skillBean.name ,value);
        if (isSet) {
            [self setEditableGradeLabelText:_skillState];
        }
    }
}

- (IBAction)addButtonAction:(id)sender {
    _skillState ++;
    
    if (_skillState > 2) {
        _skillState = 2;
    }
    
    if (self.editSkillBlock) {
        NSString *value = [NSString stringWithFormat:@"%ld",_skillState];
        BOOL isSet = self.editSkillBlock(self.skillBean.name ,value);
        if (isSet) {
            [self setEditableGradeLabelText:_skillState];
        }
    }
    
}


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

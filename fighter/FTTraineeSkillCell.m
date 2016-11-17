//
//  FTTraineeSkillCell.m
//  fighter
//
//  Created by kang on 2016/11/1.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTTraineeSkillCell.h"
#import "FTUserSkillBean.h"

@implementation FTTraineeSkillCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    self.skillLabelWidthConstraint.constant = self.skillLabelWidthConstraint.constant *SCALE;
    self.bottomLine.backgroundColor = Cell_Space_Color;
    
    self.ratingBar.fullSelectedImage = [UIImage imageNamed:@"火苗-红"];
    self.ratingBar.unSelectedImage = [UIImage imageNamed:@"火苗-灰"];
    
    self.ratingBar.isIndicator = YES;//指示器，就不能滑动了，只显示评分结果
    [self.ratingBar displayRating:5.0f];
    
    [self addIncreaseLabel];
}

- (void)addIncreaseLabel{
    CGRect r = _gradeLabel.frame;
    r.origin.y -= 20;
    r.origin.x += 8;
    
    _increaseLabel = [[UILabel alloc]initWithFrame:r];
//    _increaseLabel.text = @"5";
    _increaseLabel.textColor = [UIColor redColor];
    _increaseLabel.hidden = YES;
    [self addSubview:_increaseLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (NSInteger) levelOfGrade:(NSInteger) grade {

    NSInteger level = 0;
    
    if (grade <20) {
        level = 0;
    }else if (level < 40) {
        level = 1;
    }else if (level < 60) {
        level = 2;
    }else if (level < 80) {
        level = 3;
    }else if (level < 100) {
        level = 4;
    }
    
    return level;
}



- (void)setWithBean:(FTTraineeSkillBean *)bean{
    
    _skillLabel.text = bean.name;
    _gradeLabel.text = [NSString stringWithFormat:@"%ld",bean.score];
   [self.ratingBar displayRating:[self levelOfGrade:bean.score / bean.subNumber]];
    
}

- (void)setWithSkillBean:(FTUserSkillBean *)skillBean{
    _skillLabel.text = skillBean.name;
    _gradeLabel.text = [NSString stringWithFormat:@"%.0f",skillBean.score];
    [self.ratingBar displayRating:[self levelOfGrade:skillBean.score]];
    
    /*
     如果是父项，判断是否显示小红点
     */
    if (skillBean.isParrent && skillBean.hasNewVersion){
        _redPoint.hidden = NO;
    }else{
        _redPoint.hidden = YES;
    }
    
}

- (void)setWithSkillNewBean:(FTUserSkillBean *)skillBeanNew andSkillOldBean:(FTUserSkillBean *)skillBeanOld{
    _skillLabel.text = skillBeanOld.name;
    _increaseLabel.text = [NSString stringWithFormat:@"%.0f", skillBeanNew.score - skillBeanOld.score];
    _gradeLabel.text = [NSString stringWithFormat:@"%.0f",skillBeanOld.score];
    [self.ratingBar displayRating:[self levelOfGrade:skillBeanOld.score]];
    
    /*
     如果是父项，判断是否显示小红点
     */
    if (skillBeanOld.isParrent && skillBeanOld.hasNewVersion){
        _redPoint.hidden = NO;
    }else{
        _redPoint.hidden = YES;
        
        
        CGRect r =  _increaseLabel.frame;
        r.origin.y += 15;
        
        /*
         动画效果
         */
        
        [UIView beginAnimations:@"UIViewAnimationCurveEaseOut" context:nil];
        [UIView setAnimationDidStopSelector:@selector(animationStop)];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:2.5];
        
        _increaseLabel.frame = r;
        
        [UIView commitAnimations];
    }
    
}
- (void)animationStop{
    
    //移除的变化label
    
        _increaseLabel.hidden = YES;//隐藏变化值label
        
        //显示最新score
        _gradeLabel.text = [NSString stringWithFormat:@"%.0f", _skillBean.score];
//        _gradeLabel.text = @"73";
    
    
}
@end

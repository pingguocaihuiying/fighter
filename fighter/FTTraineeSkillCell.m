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
    r.origin.x += 23.5;
    
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
        level = 1;
    }else if (grade < 40) {
        level = 2;
    }else if (grade < 60) {
        level = 3;
    }else if (grade < 80) {
        level = 4;
    }else {
        level = 5;
    }
    
    return level;
}



- (void)setWithBean:(FTTraineeSkillBean *)bean{
    
    _skillLabel.text = bean.name;
    
    if (bean.score >= 0 ) {
        _gradeLabel.text = [NSString stringWithFormat:@"%ld",bean.score];
    }else {
        _gradeLabel.text = @"-";
    }
    
   [self.ratingBar displayRating:[self levelOfGrade:bean.score / bean.subNumber]];
    
}

- (void)setWithSkillBean:(FTUserSkillBean *)skillBean{
    
    _skillLabel.text = skillBean.name;
    if (skillBean.score >= 0 ) {
        _gradeLabel.text = [NSString stringWithFormat:@"%.0f",skillBean.score];
    }else {
        _gradeLabel.text = @"-";
    }
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
    _skillBean = skillBeanNew;
    _skillBeanOld = skillBeanOld;
    
    float increaseScore = skillBeanNew.score - skillBeanOld.score;
    
    _skillLabel.text = skillBeanOld.name;

    if (skillBeanOld.score >= 0 ) {
        _gradeLabel.text = [NSString stringWithFormat:@"%.0f",skillBeanOld.score];
    }else {
        _gradeLabel.text = @"-";
    }

    [self.ratingBar displayRating:[self levelOfGrade:skillBeanOld.score]];
    
    /*
     判断是否是父项列表，还是在子项列表
     */
    if (skillBeanOld.isParrent && skillBeanOld.hasNewVersion){
        _redPoint.hidden = NO;//显示小红点
    }else{
        _redPoint.hidden = YES;
        
        _increaseLabel.hidden = NO;//显示增长的值
        _increaseLabel.text = [NSString stringWithFormat:@"%.0f", increaseScore];
        
        CGRect r =  _increaseLabel.frame;
        r.origin.y += 18;
        
        /*
         动画效果
         */
        
        [UIView beginAnimations:@"UIViewAnimationCurveEaseOut" context:nil];
        [UIView setAnimationDidStopSelector:@selector(animationStop)];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:1.5];
        
        _increaseLabel.frame = r;
        _increaseLabel.alpha = 0.3;
        
        [UIView commitAnimations];
    }
    
}
- (void)animationStop{
    NSInteger scoreNew = _skillBean.score ;
    
    if (scoreNew <= 0) {
        scoreNew = 100;//如果新分数<=0,说明数据有异常，设为100，引起注意：这是个bug
    }
    //移除的变化label
    
        _increaseLabel.hidden = YES;//隐藏变化值label
        
        //显示最新score
        _gradeLabel.text = [NSString stringWithFormat:@"%ld", scoreNew];
    
#warning 测试
    
    _gradeLabel.text = [NSString stringWithFormat:@"%ld", scoreNew];
    CATransition *anima = [CATransition animation];
    anima.type = kCATransitionFade;//设置动画的类型
    anima.subtype = kCATransitionFromRight; //设置动画的方向
    anima.duration = 0.8f;
    [_gradeLabel.layer addAnimation:anima forKey:@"fadeAnimation"];
    
    //更新评分bar
    float rating = [self levelOfGrade:scoreNew];
    NSLog(@"ratingrating : %f", rating);
    [self.ratingBar displayRating:rating];
    

}
@end

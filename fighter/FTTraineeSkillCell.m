//
//  FTTraineeSkillCell.m
//  fighter
//
//  Created by kang on 2016/11/1.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTTraineeSkillCell.h"
#import "FTUserSkillBean.h"

#define RatingBarLeadingSpacingIn320 85

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
    _increaseLabel.textColor = [UIColor redColor];
    _increaseLabel.hidden = YES;
    [self addSubview:_increaseLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (NSInteger) levelOfGrade:(NSInteger) grade {

    NSInteger level = 0;
    if(grade <20) {
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
    
    NSLog(@"paaaaaa : %ld", bean.parent);
    
    /*
     如果是320的屏幕，把火苗往左移动一些
     */
    if (SCREEN_WIDTH == 320 && (bean.parent == 0) ){
        _ratingBarLeadingspacing.constant = RatingBarLeadingSpacingIn320;
    }
}

- (void)setWithSkillBean:(FTUserSkillBean *)skillBean{
    
    _skillLabel.text = skillBean.name;
    if (skillBean.score >= 0 ) {
        if (skillBean.score >= 99 && !skillBean.isParrent)  {//如果大于99 而且是子项，只显示99
            _gradeLabel.text = @"99";
        }else{
            _gradeLabel.text = [NSString stringWithFormat:@"%.0f",skillBean.score];
        }
        
    }else {
        _gradeLabel.text = @"-";
    }
    
    
    /*
     如果是父项，判断是否显示小红点
     */
    if (skillBean.isParrent && skillBean.hasNewVersion){
        _redPoint.hidden = NO;
    }else{
        _redPoint.hidden = YES;
        
    }
    //设置星的个数
    if (skillBean.isParrent) {
        [self.ratingBar displayRating:[self levelOfGrade:skillBean.score / skillBean.subNumber]];//如果是母项，分数要除以子项个数再计算星级
    } else {
        [self.ratingBar displayRating:[self levelOfGrade:skillBean.score]];
    }
    
    /*
     如果是320的屏幕，把火苗往左移动一些
     */
    if (SCREEN_WIDTH == 320 && skillBean.isParrent) {
        _ratingBarLeadingspacing.constant = RatingBarLeadingSpacingIn320;
    }
}

- (void)setWithSkillNewBean:(FTUserSkillBean *)skillBeanNew andSkillOldBean:(FTUserSkillBean *)skillBeanOld{
    _skillBean = skillBeanNew;
    _skillBeanOld = skillBeanOld;
    
    float increaseScore = skillBeanNew.score - skillBeanOld.score;
    
    _skillLabel.text = skillBeanOld.name;

    
    /*
      2016年12月5日备注
     *接下来设置score的老版本的值，但不知道什么原因，传过来的skillBeanOld的值是0，暂时先取了skillBeanNew的increase字段做显示
     */
    _gradeLabel.text = [NSString stringWithFormat:@"%.0f", skillBeanNew.increase];
    if (skillBeanOld.score >= 0 ) {
        if (skillBeanOld.score >= 99 ){
            _gradeLabel.text = @"99";
        }else{
            _gradeLabel.text = [NSString stringWithFormat:@"%.0f",skillBeanOld.score];
        }
        
    }else{
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
    
    if (scoreNew >= 99) {//如果大于99，只显示99
        scoreNew = 99;
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

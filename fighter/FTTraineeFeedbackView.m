//
//  FTTraineeFeedbackView.m
//  fighter
//
//  Created by kang on 2016/11/22.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTTraineeFeedbackView.h"
#import "FTRatingBar.h"

@interface FTTraineeFeedbackView ()

@property (nonatomic, strong) UIView *panelView; //容器view
@property (nonatomic, strong) UIImageView *panelImageView; //容器边框图View

@property (nonatomic, strong) UIImageView *coachAvatarImageView; //教练头像

@property (nonatomic, strong) UILabel *coachNameLabel;  //教练名称
@property (nonatomic, strong) UILabel *courseDateLabel; //课程日期
@property (nonatomic, strong) UILabel *courseNameLabel; //课程名称
@property (nonatomic, strong) UILabel *tipsLabel;       //反馈提示
@property (nonatomic, strong) UILabel *feedbackLabel;   //反馈评价

@property (nonatomic, strong) UIButton *submitButton; //提交按钮
@property (nonatomic, strong) UIButton *cancelButton; //取消按钮

@property (nonatomic, strong) FTRatingBar *ratingbar; //评级控件

@end

@implementation FTTraineeFeedbackView

- (id) init {
    
    self = [super init];
    
    if (self) {
//        [self setNotification];
        [self setSubviews];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
//        [self setNotification];
        [self setSubviews];
        
    }
    return self;
}
//
- (void) setSubviews {
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    [self addSubview:self.panelView];
    [self addSubview:self.panelImageView];
    [self addSubview:self.coachAvatarImageView];
    
    [self addSubview:self.coachNameLabel];
    [self addSubview:self.courseDateLabel];
    [self addSubview:self.courseNameLabel];
    [self addSubview:self.tipsLabel];
    [self addSubview:self.feedbackLabel];
    
    [self addSubview:self.ratingbar];
    
    [self addSubview:self.submitButton];
    [self addSubview:self.cancelButton];
    
//    [self addSubviewsConstraint];
    
}
//
//
//- (void) addSubviewsConstraint {
//    
//    [self addPaneImageViewConstraint];
//    [self addTitleLabelConstraint];
//    [self addPanelViewConstraint];
//    [self addTextImageViewConstraint];
//    [self addTextViewConstraint];
//    [self addSubmitConstraint];
//    [self addCancelButtonConstraint];
//    
//}

#pragma mark - setter 

/**
 设置教练头像

 @param coachAvatarUrl 教练头像
 */
- (void) setCoachAvatarUrl:(NSString *)coachAvatarUrl {

    if (![_coachAvatarUrl isEqualToString:coachAvatarUrl]) {
        _coachAvatarUrl = coachAvatarUrl;
        
        [self.coachAvatarImageView sd_setImageWithURL:[NSURL URLWithString:_coachAvatarUrl] placeholderImage:[UIImage imageNamed:@"头像-空"]];
    }
}

/**
 设置教练名称

 @param coachName 教练名称
 */
- (void) setCoachName:(NSString *)coachName {
    if (![_coachName isEqualToString:coachName]) {
        _coachName = coachName;
        [self.coachNameLabel setText:_coachName];
    }
}


/**
 设置课程日期

 @param courseDate 课程日期
 */
- (void) setCourseDate:(NSString *)courseDate {
    if (![_courseDate isEqualToString:courseDate]) {
        _courseDate = courseDate;
        [self.courseDateLabel setText:_courseDate];
    }
}

/**
 设置课程名称

 @param courseName 课程名称
 */
- (void) setCourseName:(NSString *)courseName {

    if (![_courseName isEqualToString:courseName]) {
        _courseName = courseName;
        [self.courseNameLabel setText:_courseName];
    }
}

/**
 设置星级，显示对应的星级评价

 @param rate 星级
 */
- (void) setRate:(NSInteger)rate {
    
    if (_rate != rate) {
        _rate = rate;
        
        [self.ratingbar displayRating:rate];
        [self.feedbackLabel setText:[self rateString:rate]];
    }
}

#pragma mark - getter

- (UIView *) panelView {

    if (!_panelView) {
        _panelView = [[UIView alloc]init];
        _panelView.backgroundColor = [UIColor clearColor];
    }
    
    return _panelView;
}

- (UIImageView *) panelImageView {
    
    if (!_panelImageView) {
        _panelImageView = [[UIImageView alloc]init];
        _panelImageView.image = [UIImage imageNamed:@"弹出框背景"];
    }
    
    return _panelImageView;
}

/**
 教练头像ImageView，显示授课教练的头像

 @return coachAvatarImageView
 */
- (UIImageView *) coachAvatarImageView {
    
    if (!_coachAvatarImageView) {
        _coachAvatarImageView = [[UIImageView alloc]init];
        _coachAvatarImageView.image = [UIImage imageNamed:@"头像-空"];
    }
    
    return _coachAvatarImageView;
}


/**
 教练名称label，显示这个可授课教练的名称

 @return coachNameLabel
 */
- (UILabel *) coachNameLabel {
    if (!_coachNameLabel) {
        _coachNameLabel = [[UILabel alloc]init];
        _coachNameLabel.font = [UIFont systemFontOfSize:16];
        _coachNameLabel.textColor = [UIColor whiteColor];
        _coachNameLabel.textAlignment = NSTextAlignmentCenter;
        [_coachNameLabel sizeToFit];
        
        // test words
        _coachNameLabel.text = @"教练名称";
    }
    
    return _coachNameLabel;
}


/**
 课程日期label，显示这节课的上课日期

 @return courseDateLabel
 */
- (UILabel *) courseDateLabel {
    if (!_courseDateLabel) {
        _courseDateLabel = [[UILabel alloc]init];
        _courseDateLabel.font = [UIFont systemFontOfSize:16];
        _courseDateLabel.textColor = [UIColor whiteColor];
        _courseDateLabel.textAlignment = NSTextAlignmentCenter;
        [_courseDateLabel sizeToFit];
        
        // test words
        _courseDateLabel.text = @"教练名称";
    }
    
    return _courseDateLabel;
}


/**
 课程名称label，显示要评价的这节课的名称

 @return courseNameLabel
 */
- (UILabel *) courseNameLabel {
    if (!_courseNameLabel) {
        _courseNameLabel = [[UILabel alloc]init];
        _courseNameLabel.font = [UIFont systemFontOfSize:16];
        _courseNameLabel.textColor = [UIColor whiteColor];
        _courseNameLabel.textAlignment = NSTextAlignmentCenter;
        [_courseNameLabel sizeToFit];
        
        // test words
        _courseNameLabel.text = @"课程名称";
    }
    
    return _courseNameLabel;
}


/**
 反馈提示label

 @return tipsLabel
 */
- (UILabel *) tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc]init];
        _tipsLabel.font = [UIFont systemFontOfSize:16];
        _tipsLabel.textColor = [UIColor whiteColor];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        [_tipsLabel sizeToFit];
        
        // test words
        _tipsLabel.text = @"这节课您的感受如何？";
    }
    
    return _tipsLabel;
}


/**
 课程反馈label，显示内容为对应星级评价的文字

 @return feedbackLabel
 */
- (UILabel *) feedbackLabel {
    if (!_feedbackLabel) {
        _feedbackLabel = [[UILabel alloc]init];
        _feedbackLabel.font = [UIFont systemFontOfSize:16];
        _feedbackLabel.textColor = [UIColor whiteColor];
        _feedbackLabel.textAlignment = NSTextAlignmentCenter;
        [_feedbackLabel sizeToFit];
        
        _feedbackLabel.text = @"还可以啦";
    }
    
    return _feedbackLabel;
}



/**
 显示星级评价控件（自定义）

 @return ratingbar
 */
- (FTRatingBar *) ratingbar {
    
    if (!_ratingbar) {
        _ratingbar = [[FTRatingBar alloc]init];
        _ratingbar.fullSelectedImage = [UIImage imageNamed:@"火苗-红"];
        _ratingbar.unSelectedImage = [UIImage imageNamed:@"火苗-灰"];
        
        _ratingbar.isIndicator = NO;//设置为非指示器，这样就可以触碰改变星级评价
        [_ratingbar displayRating:3.0f];//默认显示三颗星
    }
    return _ratingbar;
}

/**
 取消按钮

 @return cancelButton
 */
- (UIButton *) cancelButton {
    
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setImage:[UIImage imageNamed:@"取消X"] forState:UIControlStateNormal];
        [_cancelButton setImage:[UIImage imageNamed:@"取消Xpre"] forState:UIControlStateHighlighted];
        [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _cancelButton;
}


/**
 提交按钮，点击后提交对这个可的评价

 @return submitButton
 */
- (UIButton *) submitButton {
    
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:@"是的，就是这样" forState:UIControlStateNormal];
        [_submitButton setBackgroundImage:[UIImage imageNamed:@"课程详情"] forState:UIControlStateNormal];
        [_submitButton setBackgroundImage:[UIImage imageNamed:@"课程详情pre"] forState:UIControlStateHighlighted];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_submitButton addTarget:self action:@selector(submitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _submitButton;
}

#pragma mark - private


/**
 返回星级对应的评价语

 @param rate 星级
 @return 评价
 */
- (NSString *) rateString:(NSInteger) rate {
    
    NSString *feedbackString;
    if (rate == 1) {
        feedbackString = @"真的不怎么样";
    }else if (rate == 2) {
        feedbackString = @"感觉差点意思";
    }else if (rate == 3) {
        feedbackString = @"还可以啦";
    }else if (rate == 4) {
        feedbackString = @"教的不错哦";
    }else if (rate == 5) {
        feedbackString = @"神级体验，完美无瑕！";
    }
    
    return feedbackString;
}

#pragma mark - response

- (void) cancelButtonAction:(id) sender {
    
    [self removeFromSuperview];
}

- (void) submitButtonAction:(id) sender {

}

@end

//
//  FTTraineeFeedbackView.m
//  fighter
//
//  Created by kang on 2016/11/22.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTTraineeFeedbackView.h"
#import "FTRatingBar.h"


@interface FTTraineeFeedbackView () <RatingBarDelegate>

@property (nonatomic, strong) UIView *panelView; //容器view
@property (nonatomic, strong) UIImageView *panelImageView; //容器边框图View

@property (nonatomic, strong) UIImageView *coachAvatarImageView; //教练头像

@property (nonatomic, strong) UILabel *coachNameLabel;  //教练名称
@property (nonatomic, strong) UILabel *courseDateLabel; //课程日期
@property (nonatomic, strong) UILabel *courseSectionLabel; //课程时间段
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
        
        self.rate = 3;//默认三颗星
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
//        [self setNotification];
        [self setSubviews];
        self.rate = 3;//默认三颗星
    }
    return self;
}
//
- (void) setSubviews {
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    [self addSubview:self.panelImageView];
    [self addSubview:self.coachAvatarImageView];
    
    [self addSubview:self.coachNameLabel];
    
    [self addSubview:self.panelView];
    [self addSubview:self.courseDateLabel];
    [self addSubview:self.courseSectionLabel];
    
    [self addSubview:self.courseNameLabel];
    [self addSubview:self.tipsLabel];
    [self addSubview:self.feedbackLabel];
    
    [self addSubview:self.ratingbar];
    
    [self addSubview:self.submitButton];
    [self addSubview:self.cancelButton];
    
    [self addSubviewsConstraint];
    
}


- (void) addSubviewsConstraint {
    
    [self addPaneImageViewConstraint];
    
    [self addCoachAvatarImageViewConstraint];
    [self addCoachNameLabelConstaint];
    
    [self addPanelViewConstraint];
    [self addCourseDateLabelConstaint];
    [self addCourseSectionLabelConstaint];
    
    [self addCourseNameLabelConstraint];
    [self addTipsLabelConstraint];
    [self addRatingBarConstraint];
    [self addFeedbackLabelConstraint];
    
    [self addSubmitConstraint];
    [self addCancelButtonConstraint];
    
}

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
        [self.coachNameLabel setText:[_coachName stringByAppendingString:@"  教练"]];
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
 设置课程时间段

 @param courseSectionTime 课程时间段
 */
- (void) setCourseTimeSection:(NSString *)courseTimeSection {
    if (![_courseTimeSection isEqualToString:courseTimeSection]) {
        _courseTimeSection = courseTimeSection;
        [self.courseSectionLabel setText:_courseTimeSection];
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
- (void) setRate:(int) rate {
    
    if (_rate != rate) {
        
        if (rate <= 1 && rate > 0) {
            _rate = 1;
        }else if (rate <= 2 && rate > 1) {
            _rate = 2;
        }else if (rate <= 3 && rate > 2) {
            _rate = 3;
        }else if (rate <= 4 && rate > 3) {
            _rate = 4;
        }else if ( rate > 4) {
            _rate = 5;
        }
        
        [self.feedbackLabel setText:[self rateString:rate]];
    }
}

#pragma mark - getter

- (UIView *) panelView {

    if (!_panelView) {
        _panelView = [[UIView alloc]init];
        _panelView.backgroundColor = [UIColor clearColor];
//        _panelView.backgroundColor = [UIColor whiteColor];
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
        _coachNameLabel.font = [UIFont systemFontOfSize:14];
        _coachNameLabel.textColor = [UIColor whiteColor];
        _coachNameLabel.textAlignment = NSTextAlignmentCenter;
        [_coachNameLabel sizeToFit];
        
        // test words
        _coachNameLabel.text = @"教练名称  教练";
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
        _courseDateLabel.textAlignment = NSTextAlignmentLeft;
        [_courseDateLabel sizeToFit];
        
        // test words
        _courseDateLabel.text = @"课程日期";
    }
    
    return _courseDateLabel;
}



/**
 课程时间段label，显示这节课当天上课时间段

 @return courseSectionLabel
 */
- (UILabel *) courseSectionLabel {
    
    if (!_courseSectionLabel) {
        _courseSectionLabel = [[UILabel alloc]init];
        _courseSectionLabel.font = [UIFont systemFontOfSize:16];
        _courseSectionLabel.textColor = [UIColor whiteColor];
        _courseSectionLabel.textAlignment = NSTextAlignmentRight;
        [_courseSectionLabel sizeToFit];
        
        // test words
        _courseSectionLabel.text = @"课程时间段";
    }
    
    return _courseSectionLabel;
}

/**
 课程名称label，显示要评价的这节课的名称

 @return courseNameLabel
 */
- (UILabel *) courseNameLabel {
    if (!_courseNameLabel) {
        _courseNameLabel = [[UILabel alloc]init];
        _courseNameLabel.font = [UIFont systemFontOfSize:14];
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
        _tipsLabel.font = [UIFont systemFontOfSize:12];
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
        _feedbackLabel.font = [UIFont systemFontOfSize:14];
        _feedbackLabel.textColor = [UIColor colorWithHex:0x828287];
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
        _ratingbar.delegate = self;
        _ratingbar.isIndicator = NO;//设置为非指示器，这样就可以触碰改变星级评价
        [_ratingbar displayRating:3.0f];//默认显示颗星
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
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_submitButton setBackgroundImage:[UIImage imageNamed:@"课程详情"] forState:UIControlStateNormal];
        [_submitButton setBackgroundImage:[UIImage imageNamed:@"课程详情pre"] forState:UIControlStateHighlighted];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_submitButton addTarget:self action:@selector(submitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _submitButton;
}




#pragma mark - constraints

- (void) addPaneImageViewConstraint {
    
    [self.panelImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self.panelImageView
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeCenterX
                                                                        multiplier:1.0
                                                                          constant:0];
    
    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:self.panelImageView
                                                      attribute:NSLayoutAttributeCenterY
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeCenterY
                                                     multiplier:1.0
                                                       constant:0];
    
    NSLayoutConstraint *widthtConstraint = [NSLayoutConstraint constraintWithItem:self.panelImageView
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0
                                                                         constant:280*SCALE];
    
    [self addConstraint:centerXConstraint];
    [self addConstraint:centerYConstraint];
    [self addConstraint:widthtConstraint];
    
}




- (void) addCoachAvatarImageViewConstraint {
    
    [self.coachAvatarImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.coachAvatarImageView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.panelImageView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:10];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.coachAvatarImageView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0
                                                                         constant:80 *SCALE];
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.coachAvatarImageView
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0
                                                                         constant:80 *SCALE];
    
    
    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self.coachAvatarImageView
                                                                      attribute:NSLayoutAttributeCenterX
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.panelImageView
                                                                      attribute:NSLayoutAttributeCenterX
                                                                     multiplier:1.0
                                                                       constant:0];
    
    
    
    [self addConstraint:topConstraint];
    [self addConstraint:heightConstraint];
    [self addConstraint:widthConstraint];
    [self addConstraint:centerXConstraint];
}

- (void) addCoachNameLabelConstaint {
    
    [self.coachNameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.coachNameLabel
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.coachAvatarImageView
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:10];
    
    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self.coachNameLabel
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.panelImageView
                                                                         attribute:NSLayoutAttributeCenterX
                                                                        multiplier:1.0
                                                                          constant:0];
    
    [self addConstraint:topConstraint];
    [self addConstraint:centerXConstraint];
}


- (void) addPanelViewConstraint {
    
    [self.panelView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.panelView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.coachNameLabel
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:15];
    
    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self.panelView
                                                                     attribute:NSLayoutAttributeCenterX
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.panelImageView
                                                                     attribute:NSLayoutAttributeCenterX
                                                                    multiplier:1.0
                                                                      constant:0];
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.panelView
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.courseDateLabel
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:0];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.panelView
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.courseSectionLabel
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0
                                                                        constant:0];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.panelView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0
                                                                         constant:18];

    
    
    
    [self addConstraint:topConstraint];
    [self addConstraint:centerXConstraint];
    [self addConstraint:leftConstraint];
    [self addConstraint:rightConstraint];
    [self addConstraint:heightConstraint];
    
}


- (void) addCourseDateLabelConstaint {
    
    [self.courseDateLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.courseDateLabel
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.panelView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:0];
    

    
    [self addConstraint:topConstraint];
}

- (void) addCourseSectionLabelConstaint {
    
    [self.courseSectionLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.courseSectionLabel
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.panelView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:0];
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.courseSectionLabel
                                                                       attribute:NSLayoutAttributeLeft
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.courseDateLabel
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0
                                                                        constant:15];
    
    [self addConstraint:topConstraint];
    [self addConstraint:leftConstraint];

}

- (void) addCourseNameLabelConstraint {

    [self.courseNameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.courseNameLabel
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.courseDateLabel
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:10];
    
    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self.courseNameLabel
                                                                       attribute:NSLayoutAttributeCenterX
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.panelImageView
                                                                       attribute:NSLayoutAttributeCenterX
                                                                      multiplier:1.0
                                                                        constant:0];
    
    [self addConstraint:topConstraint];
    [self addConstraint:centerXConstraint];
}


- (void) addTipsLabelConstraint {

    [self.tipsLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.tipsLabel
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.courseNameLabel
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:27.5];
    
    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self.tipsLabel
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.panelImageView
                                                                         attribute:NSLayoutAttributeCenterX
                                                                        multiplier:1.0
                                                                          constant:0];
    
    [self addConstraint:topConstraint];
    [self addConstraint:centerXConstraint];
}


- (void) addRatingBarConstraint {

    [self.ratingbar setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.ratingbar
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.tipsLabel
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:12];
    
    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self.ratingbar
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.panelImageView
                                                                         attribute:NSLayoutAttributeCenterX
                                                                        multiplier:1.0
                                                                          constant:0];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.ratingbar
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0
                                                                         constant:28];
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.ratingbar
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0
                                                                         constant:155];
    
    [self addConstraint:topConstraint];
    [self addConstraint:centerXConstraint];
    [self addConstraint:heightConstraint];
    [self addConstraint:widthConstraint];
    
}



- (void) addFeedbackLabelConstraint {

    [self.feedbackLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.feedbackLabel
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.ratingbar
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:12];
    
    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self.feedbackLabel
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.panelImageView
                                                                         attribute:NSLayoutAttributeCenterX
                                                                        multiplier:1.0
                                                                          constant:0];
    
    [self addConstraint:topConstraint];
    [self addConstraint:centerXConstraint];
}


- (void) addSubmitConstraint {
    
    [self.submitButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.submitButton
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.feedbackLabel
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:15];
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.submitButton
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.panelImageView
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:16];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.submitButton
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.panelImageView
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0
                                                                        constant:-16];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.submitButton
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0
                                                                         constant:30];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.panelImageView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.submitButton
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0
                                                                         constant:18];
    
    [self addConstraint:topConstraint];
    [self addConstraint:leftConstraint];
    [self addConstraint:rightConstraint];
    [self addConstraint:heightConstraint];
    
    [self addConstraint:bottomConstraint];
    
}

- (void) addCancelButtonConstraint {
    
    [self.cancelButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *centerXCnstraint = [NSLayoutConstraint constraintWithItem:self.cancelButton
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.panelImageView
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0
                                                                         constant:20];
    
    NSLayoutConstraint *centerYCnstraint = [NSLayoutConstraint constraintWithItem:self.cancelButton
                                                                        attribute:NSLayoutAttributeCenterX
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.panelImageView
                                                                        attribute:NSLayoutAttributeCenterX
                                                                       multiplier:1.0
                                                                         constant:0];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.cancelButton
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0
                                                                         constant:35];
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.cancelButton
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.0
                                                                        constant:35];
    
    
    
    [self addConstraint:centerXCnstraint];
    [self addConstraint:centerYCnstraint];
    [self addConstraint:widthConstraint];
    [self addConstraint:heightConstraint];
    
}


#pragma mark - private


/**
 返回星级对应的评价语

 @param rate 星级
 @return 评价
 */
- (NSString *) rateString:(int) rate {
    
    NSString *feedbackString;
    if (rate <= 1 && rate > 0) {
        feedbackString = @"真的不怎么样";
    }else if (rate <= 2 && rate > 1) {
        feedbackString = @"感觉差点意思";
    }else if (rate <= 3 && rate > 2) {
        feedbackString = @"还可以啦";
    }else if (rate <= 4 && rate > 3) {
        feedbackString = @"教的不错哦";
    }else if ( rate > 4) {
        feedbackString = @"神级体验，完美无瑕！";
    }
    
    return feedbackString;
}

#pragma mark - delegate

- (void) ratingChanged:(float) rating {

    [self setRate:rating];
}

#pragma mark - response

- (void) cancelButtonAction:(id) sender {
    
    [self removeFromSuperview];
}

- (void) submitButtonAction:(id) sender {

    NSDictionary *params = @{@"coachUserId":self.coachUserId,
                             @"coach":self.coachName,
                             @"courseOnceId":self.courseOnceId,
                             @"evaluation":self.feedbackLabel.text,
                             @"score":[NSNumber numberWithInt:self.rate],
                             };
    
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [NetWorking commentCoachByParamDic:params option:^(NSDictionary *dict) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        if (dict == nil) {
            [self showMessage:@"网络异常，请稍后再试~"];
            return;
        }
        BOOL status = [dict[@"status"] isEqualToString:@"success"];
        if (status) {
            if(self.bloack) {
                _bloack(self.rate);
            }
            [self removeFromSuperview];
        }else {
            [self showMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
    }];
}

@end

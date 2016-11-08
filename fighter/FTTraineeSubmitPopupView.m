//
//  FTTraineeSubmitPopupView.m
//  fighter
//
//  Created by kang on 2016/11/8.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTTraineeSubmitPopupView.h"
#import "UIPlaceHolderTextView.h"

@interface FTTraineeSubmitPopupView ()
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIImageView *panelImageView;
@property (nonatomic, strong) UIImageView *textImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIPlaceHolderTextView *textView;

@property (nonatomic, strong) UIView *panelView;
@end

@implementation FTTraineeSubmitPopupView

- (id) init {
    
    self = [super init];
    
    if (self) {
        [self setSubviews];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setSubviews];
    }
    return self;
}


- (void) setSubviews {

    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    [self addSubview:self.panelImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.panelView];
    [self addSubview:self.textImageView];
    [self addSubview:self.textView];
    [self addSubview:self.submitButton];
    [self addSubview:self.cancelButton];
    
    [self addSubviewsConstraint];
    
}


- (void) addSubviewsConstraint {
    
    [self addPanelViewConstraint];
    [self addTitleLabelConstraint];
    [self addPanelViewConstraint];
    [self addTextImageViewConstraint];
    [self addTextViewConstraint];
    [self addSubmitConstraint];
    [self addCancelButtonConstraint];
    
}

#pragma mark - getter

- (UIButton *) submitButton {

    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:@"是的，就是这样" forState:UIControlStateNormal];
        [_submitButton setImage:[UIImage imageNamed:@"课程详情"] forState:UIControlStateNormal];
        [_submitButton setImage:[UIImage imageNamed:@"课程详情pre"] forState:UIControlStateHighlighted];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    }
    
    return _submitButton;
}

- (UIImageView *) panelImageView {

    if (!_panelImageView) {
        _panelImageView = [[UIImageView alloc]init];
        _panelImageView.image = [UIImage imageNamed:@"弹出框背景"];
    }
    
    return _panelImageView;
}

- (UIImageView *) textImageView {
    
    if (!_textImageView) {
        _textImageView = [[UIImageView alloc]init];
        _textImageView.image = [UIImage imageNamed:@"评论输入框ios"];
    }
    
    return _textImageView;
}

- (UILabel *) titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel sizeToFit];
    }
    
    return _titleLabel;
}

- (UIPlaceHolderTextView *) textView {

    if (!_textView) {
        _textView = [[UIPlaceHolderTextView alloc]init];
        _textView.textColor = [UIColor whiteColor];
        _textView.font = [UIFont systemFontOfSize:12];
        _textView.placeholder = @"一句话点评：";
    }
    return _textView;
}

- (UIView *) panelView {

    if (!_panelView) {
        _panelView = [[UIView alloc] init];
        _panelView.backgroundColor = [UIColor clearColor];
    }
    return _panelView;
}

- (UIButton *) cancelButton {

    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setImage:[UIImage imageNamed:@"取消X"] forState:UIControlStateNormal];
        [_cancelButton setImage:[UIImage imageNamed:@"取消Xpre"] forState:UIControlStateHighlighted];
        [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _cancelButton;
}

#pragma mark - response
- (void) cancelButtonAction:(id) sender {

    [self removeFromSuperview];
}
#pragma mark - constraint 

- (void) addPaneImageVIewConstraint {

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
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.panelImageView
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0
                                                                       constant:280*SCALE];
    
    [self addConstraint:centerXConstraint];
    [self addConstraint:centerYConstraint];
    [self addConstraint:heightConstraint];
    
}

- (void) addTitleLabelConstraint {

    [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.panelImageView
                                                                         attribute:NSLayoutAttributeTop
                                                                        multiplier:1.0
                                                                          constant:20];
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.panelImageView
                                                                         attribute:NSLayoutAttributeLeft
                                                                        multiplier:1.0
                                                                          constant:16];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel
                                                                        attribute:NSLayoutAttributeRight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.panelImageView
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1.0
                                                                         constant:-16];
    
    [self addConstraint:topConstraint];
    [self addConstraint:leftConstraint];
    [self addConstraint:rightConstraint];
}

- (void) addPanelViewConstraint {

    [self.panelView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.panelView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.titleLabel
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:15];
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.panelView
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.panelImageView
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:16];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.panelView
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.panelImageView
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0
                                                                        constant:-16];
    
    [self addConstraint:topConstraint];
    [self addConstraint:leftConstraint];
    [self addConstraint:rightConstraint];
}


- (void) addTextImageViewConstraint {

    [self.textImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.textImageView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.panelView
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:20];
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.textImageView
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.panelImageView
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:16];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.textImageView
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.panelImageView
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0
                                                                        constant:-16];
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.textImageView
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.0
                                                                        constant:100 *SCALE];
    
    [self addConstraint:topConstraint];
    [self addConstraint:leftConstraint];
    [self addConstraint:rightConstraint];
    [self addConstraint:heightConstraint];
}


- (void) addTextViewConstraint {

    [self.textView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.textView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.textImageView
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:5];
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.textView
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.textImageView
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:15];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.textView
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.textImageView
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0
                                                                        constant:-15];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.textView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.textImageView
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0
                                                                         constant:-5];
    
    [self addConstraint:topConstraint];
    [self addConstraint:leftConstraint];
    [self addConstraint:rightConstraint];
    [self addConstraint:bottomConstraint];

}

- (void) addSubmitConstraint {

    [self.submitButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.submitButton
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.textImageView
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:10];
    
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
                                                                     attribute:NSLayoutAttributeCenterX
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeCenterX
                                                                    multiplier:1.0
                                                                      constant:0];
    
    NSLayoutConstraint *centerYCnstraint = [NSLayoutConstraint constraintWithItem:self.cancelButton
                                                                      attribute:NSLayoutAttributeCenterY
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeCenterY
                                                                     multiplier:1.0
                                                                       constant:0];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.cancelButton
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.0
                                                                        constant:30];
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.cancelButton
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0
                                                                         constant:30];
    
    
    
    [self addConstraint:centerXCnstraint];
    [self addConstraint:centerYCnstraint];
    [self addConstraint:widthConstraint];
    [self addConstraint:heightConstraint];

}
@end

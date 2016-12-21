//
//  FTInvitationCodePopUpView.m
//  fighter
//
//  Created by kang on 2016/12/20.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTInvitationCodePopUpView.h"

@interface FTInvitationCodePopUpView ()
{
   
}
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIImageView *panelImageView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *gymLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *detailLabel;


@end


@implementation FTInvitationCodePopUpView

#pragma mark - 初始化界面
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
    [self addSubview:self.gymLabel];
    [self addSubview:self.typeLabel];
    [self addSubview:self.detailLabel];
    
    [self addSubview:self.submitButton];
    [self addSubview:self.cancelButton];
    
    [self addSubviewsConstraint];
    
}


- (void) addSubviewsConstraint {
    
    [self addPaneImageViewConstraint];
    [self addTitleLabelConstraint];
    [self addGymLabelConstraint];
    [self addTypeLabelConstraint];
    [self addDetailLabelConstraint];
    
    [self addSubmitButtonConstraint];
    [self addCancelButtonConstraint];
    
}


#pragma mark - setter
- (void) setGymName:(NSString *)gymName {

    if (![_gymName isEqualToString:gymName]) {
        _gymName = gymName;
        self.gymLabel.text = _gymName;
    }
}


- (void) setMemberType:(FTMemberType)memberType {

    if (_memberType != memberType) {
        _memberType = memberType;
        self.typeLabel.text = [self typeText:_memberType];
    }
}

- (void) setTimes:(NSString *)times{
    
    if (![_times isEqualToString:times]) {
        _times = times;
        self.detailLabel.text = [NSString stringWithFormat:@"可预约 %@ 次 小班课",_times];
    }
    
}

- (void) setdeadline:(NSString *)deadline {
    
    if (![_deadline isEqualToString:deadline]) {
        _deadline = deadline;
        self.detailLabel.text = [NSString stringWithFormat:@"截止日期为 %@",_deadline];
    }
    
}

- (void) setBalance:(NSString *)balance {
    
    if (![_balance isEqualToString:balance]) {
        _balance = balance;
        self.detailLabel.text = [NSString stringWithFormat:@"账户余额为 %@ 元",_balance];
    }
}

- (NSString *) typeText:(FTMemberType) memberType {

    if (memberType == FTMemberTypeMoney) {
        return @"的会员";
    }else if (memberType == FTMemberTypeTimes) {
        return @"的次卡会员";
    }else if (memberType == FTMemberTypeDate) {
        return @"的时间卡会员";
    }
    
    return nil;
}

#pragma mark - getter

- (UIImageView *) panelImageView {
    
    if (!_panelImageView) {
        _panelImageView = [[UIImageView alloc]init];
        _panelImageView.image = [UIImage imageNamed:@"弹出框背景"];
    }
    
    return _panelImageView;
}


- (UILabel *) titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel sizeToFit];
        
        // test words
        _titleLabel.text = @"您成为了";
    }
    
    return _titleLabel;
}


- (UILabel *) gymLabel {
    if (!_gymLabel) {
        _gymLabel = [[UILabel alloc]init];
        _gymLabel.font = [UIFont systemFontOfSize:18];
        _gymLabel.textColor = [UIColor whiteColor];
        _gymLabel.textAlignment = NSTextAlignmentCenter;
        [_gymLabel sizeToFit];
        
        // test words
        _gymLabel.text = @"格斗俱乐部名称";
    }
    
    return _gymLabel;
}



- (UILabel *) typeLabel {
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc]init];
        _typeLabel.font = [UIFont systemFontOfSize:18];
        _typeLabel.textColor = [UIColor whiteColor];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        [_typeLabel sizeToFit];
        
        // test words
        _typeLabel.text = @"会员种类";
    }
    
    return _typeLabel;
}



- (UILabel *) detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc]init];
        _detailLabel.font = [UIFont systemFontOfSize:12];
        _detailLabel.textColor = [UIColor redColor];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        [_detailLabel sizeToFit];
        
        // test words
        _detailLabel.text = @"会员可用资源详情";
    }
    
    return _detailLabel;
}


- (UIButton *) submitButton {
    
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:@"立即约课" forState:UIControlStateNormal];
        [_submitButton setBackgroundImage:[UIImage imageNamed:@"课程详情"] forState:UIControlStateNormal];
        [_submitButton setBackgroundImage:[UIImage imageNamed:@"课程详情pre"] forState:UIControlStateHighlighted];
        [_submitButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [_submitButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_submitButton addTarget:self action:@selector(submitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _submitButton;
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



#pragma mark - constraint

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

- (void) addGymLabelConstraint {
    
    [self.gymLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.gymLabel
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.titleLabel
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:15];
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.gymLabel
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.panelImageView
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:16];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.gymLabel
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


- (void) addTypeLabelConstraint {
    
    [self.typeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.typeLabel
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.gymLabel
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:6];
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.typeLabel
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.panelImageView
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:16];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.typeLabel
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



- (void) addDetailLabelConstraint {
    
    [self.detailLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.detailLabel
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.typeLabel
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:18];
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.detailLabel
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.panelImageView
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:16];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.detailLabel
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

- (void) addSubmitButtonConstraint {
    
    [self.submitButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.submitButton
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.detailLabel
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:20];
    
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


#pragma mark - response

- (void) cancelButtonAction:(id) sender {
    
    [self removeFromSuperview];
}

- (void) submitButtonAction:(id) sender {
    
    [FTNotificationTools postCloseDrawerNoti];
    [FTNotificationTools postTabBarIndex:2 dic:nil];
    [self removeFromSuperview];
    if (self.dismissBlock) {
        _dismissBlock ();
    }
}


@end

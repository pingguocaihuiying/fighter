//
//  FTTraineeSkillSectionHeaderView.m
//  fighter
//
//  Created by kang on 2016/11/3.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTTraineeSkillSectionHeaderView.h"

@interface FTTraineeSkillSectionHeaderView ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *detailLabel;

@property (strong, nonatomic) UIView *topLine;
@property (strong, nonatomic) UIView *bottomLine;

@end

@implementation FTTraineeSkillSectionHeaderView
@synthesize titleColor = _titleColor;
@synthesize detailColor = _detailColor;
@synthesize titleFont = _titleFont;
@synthesize detailFont = _detailFont;

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



#pragma mark -

- (void) setSubviews {
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.detailLabel];
    [self addSubview:self.topLine];
    [self addSubview:self.bottomLine];
    
    [self addTitleLabelConstraint];
    [self addDetailLabelConstraint];
    [self addTopLineConstraint];
    [self addBottomLineConstraint];
}

#pragma mark - constraint

/**
 add title label constraint
 */
- (void) addTitleLabelConstraint {
    
    [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.topLine
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:15];
    
    
    
    
    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeCenterX
                                                                        multiplier:1.0
                                                                          constant:0];
    
    [self addConstraint:topConstraint];
    [self addConstraint:centerXConstraint];

}


/**
 add detail label constraint
 */
- (void) addDetailLabelConstraint {

    [self.detailLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.detailLabel
                                                                           attribute:NSLayoutAttributeTop
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.titleLabel
                                                                           attribute:NSLayoutAttributeBottom
                                                                          multiplier:1.0
                                                                            constant:15];
    
    NSLayoutConstraint *rightConstriant = [NSLayoutConstraint constraintWithItem:self.detailLabel
                                                                             attribute:NSLayoutAttributeRight
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self
                                                                             attribute:NSLayoutAttributeRight
                                                                            multiplier:1.0
                                                                              constant:-15];
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.detailLabel
                                                                            attribute:NSLayoutAttributeLeft
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self
                                                                            attribute:NSLayoutAttributeLeft
                                                                           multiplier:1.0
                                                                             constant:15];
    
    [self addConstraint:topConstraint];
    [self addConstraint:rightConstriant];
    [self addConstraint:leftConstraint];
}



/**
 add top line constraint
 */
- (void) addTopLineConstraint {

    [self.topLine setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.topLine
                                                                           attribute:NSLayoutAttributeTop
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self
                                                                           attribute:NSLayoutAttributeTop
                                                                          multiplier:1.0
                                                                            constant:0];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.topLine
                                                                             attribute:NSLayoutAttributeRight
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self
                                                                             attribute:NSLayoutAttributeRight
                                                                            multiplier:1.0
                                                                              constant:0];
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.topLine
                                                                            attribute:NSLayoutAttributeLeft
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self
                                                                            attribute:NSLayoutAttributeLeft
                                                                           multiplier:1.0
                                                                             constant:0];
    
//    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.topLine
//                                                                      attribute:NSLayoutAttributeBottom
//                                                                      relatedBy:NSLayoutRelationEqual
//                                                                         toItem:self.topLine
//                                                                      attribute:NSLayoutAttributeTop
//                                                                     multiplier:1.0
//                                                                       constant:0.5];

    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.topLine
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0
                                                                         constant:0.5];
    [self addConstraint:topConstraint];
    [self addConstraint:rightConstraint];
    [self addConstraint:leftConstraint];
    [self addConstraint:heightConstraint];
}



/**
 add Bottom line constraint
 */
- (void) addBottomLineConstraint {
    
    [self.bottomLine setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.bottomLine
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.detailLabel
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:15];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.bottomLine
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0
                                                                        constant:0];
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.bottomLine
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:0];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.bottomLine
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0
                                                                         constant:0];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.topLine
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0
                                                                         constant:0.5];
    
    [self addConstraint:topConstraint];
    [self addConstraint:rightConstraint];
    [self addConstraint:leftConstraint];
    [self addConstraint:bottomConstraint];
    
    [self addConstraint:heightConstraint];
    
}

#pragma mark - setter
- (void) setTitle:(NSString *)title {

    if (![_title isEqualToString: title]) {
        _title = [title copy];
        
        self.titleLabel.text = _title;
    }
}

- (void) setDetailAttributeString:(NSAttributedString *)detailAttributeString {
    
    if (![_detailAttributeString isEqualToAttributedString:detailAttributeString]) {
        _detailAttributeString = detailAttributeString;
        [self.detailLabel setAttributedText:_detailAttributeString];
    }
}


- (void) setDetail:(NSString *)detail {
    
    if (![_detail isEqualToString: detail]) {
        _detail = [detail copy];
        
        self.detailLabel.text = _detail;
    }
}

- (void) setTitleColor:(UIColor *)titleColor {

    if (_titleColor != titleColor) {
        _titleColor = titleColor;
        self.titleLabel.textColor = self.titleColor;
    }
}

- (void) setDetailColor:(UIColor *)detailColor {
    if (_detailColor != detailColor) {
        _detailColor = detailColor;
        self.detailLabel.textColor = _detailColor;
    }
}


- (void) setTitleFont:(UIFont *)titleFont {

    if (_titleFont != titleFont) {
        _titleFont = titleFont;
        self.titleLabel.font = _titleFont;
    }
}


- (void) setDetailFont:(UIFont *)detailFont {

    if (_detailFont != detailFont) {
        _detailFont = detailFont;
        self.detailLabel.font = _detailFont;
    }
}


#pragma mark - getter
- (UILabel *) titleLabel {

    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = self.titleColor;
        _titleLabel.font = self.titleFont;
        [_titleLabel sizeToFit];
    }
    
    return _titleLabel;
}

- (UILabel *) detailLabel {

    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc]init];
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.textColor = self.detailColor;
        _detailLabel.font = self.detailFont;
        _detailLabel.numberOfLines = 0;
        [_detailLabel sizeToFit];
    }
    
    return _detailLabel;
}


- (UIColor *) titleColor {
    
    if (!_titleColor) {
        _titleColor = [UIColor whiteColor];
    }
    return _titleColor;
}

- (UIColor *) detailColor {

    if (!_detailColor) {
        _detailColor = [UIColor colorWithHex:0xb4b4b4];
    }
    return _detailColor;
}


- (UIFont *) titleFont {
    if (!_titleFont) {
        _titleFont = [UIFont systemFontOfSize:18];
    }
    return _titleFont;
}


- (UIFont *) detailFont {
    if (!_detailFont) {
        _detailFont = [UIFont systemFontOfSize:12];
    }
    return _detailFont;
}

- (UIView *) topLine {
    if (!_topLine) {
        _topLine = [[UIView alloc]init];
        _topLine.backgroundColor = Cell_Space_Color;
    }
    
    return _topLine;
}

- (UIView *) bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc]init];
        _bottomLine.backgroundColor = Cell_Space_Color;
    }
    
    return _bottomLine;
}

@end

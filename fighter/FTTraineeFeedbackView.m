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

@property (nonatomic, strong) UIView *panelView;
@property (nonatomic, strong) UIImageView *panelImageView;
@property (nonatomic, strong) UIImageView *coachAvatarImageView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSLayoutConstraint *centerYConstraint;

@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) FTRatingBar *ratingbar;

@end

@implementation FTTraineeFeedbackView

- (id) init {
    
    self = [super init];
    
    if (self) {
        [self setNotification];
        [self setSubviews];
        keyBoardHidden = NO;
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setNotification];
        [self setSubviews];
        keyBoardHidden = NO;
    }
    return self;
}

- (void) setSubviews {
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    [self addSubview:self.panelImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.panelView];
    [self addSubview:self.submitButton];
    [self addSubview:self.cancelButton];
    
    [self addSubviewsConstraint];
    
}


- (void) addSubviewsConstraint {
    
    [self addPaneImageViewConstraint];
    [self addTitleLabelConstraint];
    [self addPanelViewConstraint];
    [self addTextImageViewConstraint];
    [self addTextViewConstraint];
    [self addSubmitConstraint];
    [self addCancelButtonConstraint];
    
}

@end

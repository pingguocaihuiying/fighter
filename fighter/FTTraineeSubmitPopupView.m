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
{
    BOOL keyBoardHidden;
}
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIImageView *panelImageView;
@property (nonatomic, strong) UIImageView *textImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIPlaceHolderTextView *textView;
@property (nonatomic, strong) NSLayoutConstraint *centerYConstraint;
@property (nonatomic, strong) UIView *panelView;

@end

@implementation FTTraineeSubmitPopupView

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


- (void) setNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(keyBoardFrameWillChanged:)
    //                                                 name:UIKeyboardWillChangeFrameNotification
    //                                               object:nil];
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
    
    [self addPaneImageViewConstraint];
    [self addTitleLabelConstraint];
    [self addPanelViewConstraint];
    [self addTextImageViewConstraint];
    [self addTextViewConstraint];
    [self addSubmitConstraint];
    [self addCancelButtonConstraint];
    
}

#pragma mark - setter 

- (void) setTitle:(NSString *)title {

    if (![_title isEqualToString:title]) {
        _title = title;
        self.titleLabel.text = _title;
    }
}

- (void) setSkillGradeDic:(NSMutableDictionary *)skillGradeDic {

    if (_skillGradeDic != skillGradeDic) {
        _skillGradeDic = skillGradeDic;
        [self setSkillLabels:_skillGradeDic];
    }
}

#pragma mark - getter

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
        
        // test words
        _titleLabel.text = @"李小龙  通过本节课";
    }
    
    return _titleLabel;
}

- (UIPlaceHolderTextView *) textView {

    if (!_textView) {
        _textView = [[UIPlaceHolderTextView alloc]init];
        _textView.textColor = [UIColor whiteColor];
        _textView.font = [UIFont systemFontOfSize:12];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.placeholder = @"一句话点评：";
        _textView.placeholderColor = [UIColor colorWithHex:0x505050];
        
        // test words
//        _textView.text = @"李小龙  通过本节课李小龙  通过本节课李小龙  通过本节课李小龙  通过本节课";
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

- (void) submitButtonAction:(id) sender {
    
    if (self.textView.text.length == 0) {
        [self showMessage:@"学员点评不能为空~"];
        return;
    }
    
    
//    if (self.textView.text.length < 10) {
//        [self showMessage:@"评论不能少于10个字"];
//        return;
//    }
    
    
//    NSMutableArray *increases = [[NSMutableArray alloc]init];
//    NSMutableArray *skills = [[NSMutableArray alloc]init];
//    
//    
//    for (NSString *key in self.skillGradeDic.allKeys) {
//        NSString *value = self.skillGradeDic[key];
//        
//        [increases addObject:value];
//        [skills addObject:key];
//        
//    }
 
    
    NSString *increases = @"";
    NSString *skills = @"";
    
    
    for (NSString *key in self.skillGradeDic.allKeys) {
        NSString *value = self.skillGradeDic[key];
        [[skills stringByAppendingString:key] stringByAppendingString:@","];
        [[increases stringByAppendingString:value] stringByAppendingString:@","];
    }

    NSDictionary *paramDic = @{
                               @"increases":increases,
                               @"skills":skills,
                               @"evaluation":_textView.text,
                               @"bookId":_bookId
                               };
    
    
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [NetWorking saveSkillVersion:paramDic option:^(NSDictionary *dic) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        
        if (!dic) {
            [self showMessage:@"网络繁忙，请稍后再试~"];
            return ;
        }
        SLog(@"dic:%@",dic);
        SLog(@"message:%@",[dic[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
        BOOL status = [dic[@"status"] isEqualToString:@"success"]? YES:NO;
        if (!status) {
            [self showMessage:[dic[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }else {
            
            [self removeFromSuperview];
        }
    }];
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
    
    _centerYConstraint = [NSLayoutConstraint constraintWithItem:self.panelImageView
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
    [self addConstraint:_centerYConstraint];
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
                                                                        constant:50 *SCALE];
    
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
                                                                     attribute:NSLayoutAttributeTop
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

#pragma mark - 

- (void) setSkillLabels:(NSDictionary *) dic {

    NSInteger i = 0;
    for (NSString *key in dic.allKeys) {
        NSString *value = [dic objectForKey:key];
        
        UILabel *keyLabel = [[UILabel alloc]init];
        keyLabel.font = [UIFont systemFontOfSize:12];
        keyLabel.textColor = [UIColor whiteColor];
        keyLabel.textAlignment = NSTextAlignmentRight;
        [keyLabel sizeToFit];
        keyLabel.text = key;
        [self.panelView addSubview:keyLabel];
        [self addKeyLabelConstraint:keyLabel index:i];
        
        UILabel *valueLabel = [[UILabel alloc]init];
        valueLabel.font = [UIFont systemFontOfSize:12];
        valueLabel.textColor = [UIColor colorWithHex:0xbe1e1e];
        valueLabel.textAlignment = NSTextAlignmentLeft;
        [valueLabel sizeToFit];
        valueLabel.text = value;
        [self.panelView addSubview:valueLabel];
        [self addValueLabelConstraint:valueLabel index:i];
        i++;
    }
}

- (void) addKeyLabelConstraint:(UILabel *) keylabel index:(NSInteger) indexline {

    [keylabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:keylabel
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.panelView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:23*indexline];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:keylabel
                                                                      attribute:NSLayoutAttributeRight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.panelView
                                                                      attribute:NSLayoutAttributeCenterX
                                                                     multiplier:1.0
                                                                       constant:-12];
    
//    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:keylabel
//                                                                       attribute:NSLayoutAttributeRight
//                                                                       relatedBy:NSLayoutRelationEqual
//                                                                          toItem:self.panelImageView
//                                                                       attribute:NSLayoutAttributeRight
//                                                                      multiplier:1.0
//                                                                        constant:-16];
    
    [self.panelView addConstraint:topConstraint];
    [self.panelView addConstraint:rightConstraint];
    
    if (indexline == _skillGradeDic.allKeys.count - 1) {
        
        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.panelView
                                                                           attribute:NSLayoutAttributeBottom
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:keylabel
                                                                           attribute:NSLayoutAttributeBottom
                                                                          multiplier:1.0
                                                                            constant:0];
        [self.panelView addConstraint:bottomConstraint];
    }
//    [self.panelView addConstraint:rightConstraint];
}

- (void) addValueLabelConstraint:(UILabel *) valuelabel index:(NSInteger) indexline {
    
    [valuelabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:valuelabel
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.panelView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:23*indexline];
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:valuelabel
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.panelView
                                                                      attribute:NSLayoutAttributeCenterX
                                                                     multiplier:1.0
                                                                       constant:12];
    
    //    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:keylabel
    //                                                                       attribute:NSLayoutAttributeRight
    //                                                                       relatedBy:NSLayoutRelationEqual
    //                                                                          toItem:self.panelImageView
    //                                                                       attribute:NSLayoutAttributeRight
    //                                                                      multiplier:1.0
    //                                                                        constant:-16];
    
    [self.panelView addConstraint:topConstraint];
    [self.panelView addConstraint:leftConstraint];
    //    [self.panelView addConstraint:rightConstraint];
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (keyBoardHidden == NO) {
        [self.textView resignFirstResponder];
    }else {
        CGPoint point = [[touches anyObject] locationInView:self];
        CGRect frame = [self convertRect:self.panelImageView.frame toView:self];
        
        if (CGRectContainsPoint(frame, point)) {
            return;
        }else {
            [self removeFromSuperview];
        }
    }
    
}


#pragma mark - notification Action

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    keyBoardHidden = NO;
    //获取键盘的动画时间
    CGFloat duration = [aNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    //创建自带来获取穿过来的对象的info配置信息
//    NSDictionary *userInfo = [aNotification userInfo];
//    NSLog(@"userInfo:%@",userInfo);
//    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //改变底部工具条的底部约束
    self.centerYConstraint.constant =   - 100;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        [weakSelf layoutIfNeeded];//刷新布局，使得工具条随键盘frame改变有动画
    }];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    
    keyBoardHidden = YES;
    //获取键盘的动画时间
    CGFloat duration = [aNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    //创建自带来获取穿过来的对象的info配置信息
//    NSDictionary *userInfo = [aNotification userInfo];
//    NSLog(@"userInfo:%@",userInfo);
//    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //改变底部工具条的底部约束
   self.centerYConstraint.constant = 0;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        [weakSelf layoutIfNeeded];//刷新布局，使得工具条随键盘frame改变有动画
    }];
}

@end

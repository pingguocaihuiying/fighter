//
//  FTCameraAndAlbum.m
//  fighter
//
//  Created by kang on 16/9/13.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTCameraAndAlbum.h"
#import "Masonry.h"
#import "NetWorking.h"
#import "FTUserBean.h"
#import "MBProgressHUD.h"
#import "UIWindow+MBProgressHUD.h"

@interface FTCameraAndAlbum ()

@property (nonatomic ,strong) UIView *panelView;
@property (nonatomic ,strong) UIImageView *backImgView;
@property (nonatomic, strong) UIButton *cancelBtn;

@end


@implementation FTCameraAndAlbum

- (id) init {
    
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithHex:0x191919 alpha:0.5];
        self.opaque = NO;
        [self setFrame:[UIScreen mainScreen].bounds];
        
        [self setSubviews];
    }
    
    return self;
}



- (void) setSubviews {
    
    //面板
    _panelView = [[UIView alloc] init];
    _panelView.backgroundColor = [UIColor clearColor];
    _panelView.opaque = NO;
    [self addSubview:_panelView];
    
   
    
    CGRect frame = self.frame;
    
    //边框
    _backImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width-20, frame.size.height/3)];
    [_backImgView setImage:[UIImage imageNamed:@"金属边框-改进ios"]];
    [_backImgView setBackgroundColor:[UIColor colorWithHex:0x191919]];
    [_panelView addSubview:_backImgView];
    
    __weak UIView *weakPanel= _panelView;
    [_backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakPanel.mas_bottom).with.offset(0);
        make.right.equalTo(weakPanel.mas_right).with.offset(0);
        make.left.equalTo(weakPanel.mas_left).with.offset(0);
        make.top.equalTo(weakPanel).with.offset(5);;
        
    }];
    
    
    
    //完成按钮
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setTitle:@"取    消" forState:UIControlStateNormal];
    [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"主要按钮背景ios"] forState:UIControlStateNormal];
    [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"主要按钮背景ios-pre"] forState:UIControlStateHighlighted];
    [_cancelBtn addTarget:self  action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_panelView addSubview:_cancelBtn];
    
    //picker
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakPanel.mas_bottom).with.offset(-20);
        make.right.equalTo(weakPanel.mas_right).with.offset(-40);
        make.left.equalTo(weakPanel.mas_left).with.offset(40);
        make.height.equalTo(@45);
    }];
    
    
    __weak UIButton *weakCancelBtn = _cancelBtn;
    
    self.cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [self.maleBtn setBackgroundColor:[UIColor greenColor]];
    [self.cameraBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.cameraBtn setImage:[UIImage imageNamed:@"拍照"] forState:UIControlStateNormal];
    [self.cameraBtn setImage:[UIImage imageNamed:@"拍照pre"] forState:UIControlStateHighlighted];
    [self.cameraBtn setTitleColor:[UIColor colorWithHex:0xb4b4b4] forState:UIControlStateNormal];
    [self.panelView addSubview:self.cameraBtn];
    
    [self.cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakPanel.mas_centerX).with.offset(0);
        make.left.equalTo(weakPanel.mas_left).with.offset(40);
        make.bottom.equalTo(weakCancelBtn.mas_top).with.offset(-20);
        make.height.equalTo(@80);
        
    }];
    
    self.albumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.albumBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.albumBtn setImage:[UIImage imageNamed:@"相册"] forState:UIControlStateNormal];
    [self.albumBtn setImage:[UIImage imageNamed:@"相册pre"] forState:UIControlStateHighlighted];
    [self.albumBtn setTitleColor:[UIColor colorWithHex:0xb4b4b4] forState:UIControlStateNormal];
    [self.panelView addSubview:self.albumBtn];
    
    [self.albumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakPanel.mas_right).with.offset(-40);
        make.left.equalTo(weakPanel.mas_centerX ).with.offset(0);
        make.bottom.equalTo(weakCancelBtn.mas_top).with.offset(-20);
        make.height.equalTo(@80);
        
    }];
    
    
    
    __weak UIButton *weakBtn= _albumBtn;
    __weak __typeof(self) weakSelf = self;
    //添加_panelView 约束
    [_panelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.mas_bottom).with.offset(-74);
        make.right.equalTo(weakSelf.mas_right).with.offset(-6);
        make.left.equalTo(weakSelf.mas_left).with.offset(6);
        make.top.equalTo(weakBtn.mas_top).with.offset(-20);
        
    }];
    
    //动画
    [self displayPanelViewAnimation];
}


#pragma mark - button responser

- (void) cancelBtnAction:(id) sender {

    [self hiddenPanelViewAnimation];
    
}

#pragma mark - touch responser

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    if (touches.count >1) {
        return ;
    }
    
    UITouch *touch = [touches.allObjects objectAtIndex:0];
    CGPoint point = [touch locationInView:self];
    CGRect frame = [self convertRect:_panelView.frame toView:self];
    if (!CGRectContainsPoint(frame, point)) {

        [self hiddenPanelViewAnimation];
    }
}

#pragma mark - 动画

/**
 *  显示视图动画
 */
- (void) displayPanelViewAnimation {
    
    [self layoutIfNeeded];
    
    CGRect pframe = _panelView.frame;
    CGPoint pCenter = _panelView.center;
    _panelView.center = CGPointMake(pCenter.x, pCenter.y+pframe.size.height);
    
    [UIView animateWithDuration:0.2
                          delay:0.0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         
                         _panelView.center = CGPointMake(pCenter.x, pCenter.y);
                     }
                     completion:nil];
    
}

/**
 *  隐藏视图动画
 */
- (void) hiddenPanelViewAnimation {
    
    //设定剧本
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.5];
    scaleAnimation.fillMode=kCAFillModeForwards ;//保持动画玩后的状态
    scaleAnimation.removedOnCompletion = NO;
    //    scaleAnimation.autoreverses = YES;
    //    scaleAnimation.repeatCount = MAXFLOAT;
    scaleAnimation.duration = 0.2;
    
    //设定剧本
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:_panelView.layer.position];
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(_panelView.layer.position.x, _panelView.layer.position.y + _panelView.layer.frame.size.height)];
    positionAnimation.fillMode=kCAFillModeForwards ;//保持动画玩后的状态
    positionAnimation.removedOnCompletion = NO;
    //    scaleAnimation.autoreverses = YES;
    //    scaleAnimation.repeatCount = MAXFLOAT;
    positionAnimation.duration = 0.2;
    
    
    CAAnimationGroup *groupAnnimation = [CAAnimationGroup animation];
    groupAnnimation.duration =  0.2;
    //    groupAnnimation.autoreverses = YES;
    groupAnnimation.fillMode=kCAFillModeForwards ;//保持动画玩后的状态
    groupAnnimation.removedOnCompletion = NO;
    //    groupAnnimation.animations = @[scaleAnimation];
    groupAnnimation.animations = @[scaleAnimation,positionAnimation];
    //    groupAnnimation.repeatCount = MAXFLOAT;
    //开演
    [_panelView.layer addAnimation:groupAnnimation forKey:@"groupAnnimation"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}


@end
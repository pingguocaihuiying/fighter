//
//  FTShareView.m
//  fighter
//
//  Created by kang on 16/5/31.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTShareView.h"
#import "Masonry.h"

@interface FTShareView ()
{
    NSInteger selectNum;
    
}

@property (nonatomic ,strong) UIView *panelView;
@property (nonatomic ,strong) UIImageView *backImgView;
@property (nonatomic, strong) UIPickerView *pickerView;



@end

@implementation FTShareView

- (id) init {
    
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithHex:0x191919 alpha:0.5];
        self.opaque = NO;
        [self setFrame:[UIScreen mainScreen].bounds];
        
        [self setSubviews];
        [self setTouchEvent];
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
    __weak __typeof(self) weakSelf = self;
    [_panelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.mas_bottom).with.offset(-10);
        make.right.equalTo(weakSelf.mas_right).with.offset(0);
        make.left.equalTo(weakSelf.mas_left).with.offset(0);
        make.height.equalTo(@250);
        
    }];
    
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
    
    
    //显示label
    _hintLabel = [[UILabel alloc]init];
    _hintLabel.font=[UIFont systemFontOfSize:16];
    _hintLabel.textAlignment = NSTextAlignmentCenter;
    _hintLabel.textColor = [UIColor colorWithHex:0x828287];;
    _hintLabel.text = @"修改头像";
    [_panelView addSubview:_hintLabel];
    
    [_hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakPanel.mas_top).with.offset(20);
        make.right.equalTo(weakPanel.mas_right).with.offset(-40);
        make.left.equalTo(weakPanel.mas_left).with.offset(40);
        make.height.equalTo(@20);
    }];
    
    
    //完成按钮
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setTitle:@"取   消" forState:UIControlStateNormal];
    [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"主要按钮背景ios"] forState:UIControlStateNormal];
    [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"主要按钮背景ios-pre"] forState:UIControlStateHighlighted];
    [_cancelBtn addTarget:self  action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [_panelView addSubview:_cancelBtn];
    
    //picker
    __weak UIImageView *weakBackImg= _backImgView;
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakBackImg.mas_bottom).with.offset(-20);
        make.right.equalTo(weakBackImg.mas_right).with.offset(-15);
        make.left.equalTo(weakBackImg.mas_left).with.offset(15);
        make.height.equalTo(@45);
    }];
}

- (void) setButtons {

    CALayer *layer = [CALayer layer];
    
}

- (void) setTouchEvent {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    
    [self addGestureRecognizer:tap];
    
}


#pragma mark - response methods

- (void) cancelAction:(id) sender {


}

- (void) tapAction:(UITapGestureRecognizer *)gesture {
    
    CGPoint point = [gesture locationInView:self];
    CGRect frame = [self convertRect:_panelView.frame toView:self];
    if (!CGRectContainsPoint(frame, point)) {
        [self removeFromSuperview];
    }
    
}





@end

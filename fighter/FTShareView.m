//
//  FTShareView.m
//  fighter
//
//  Created by kang on 16/5/31.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTShareView.h"


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
    
    
    
}


- (void) setTouchEvent {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    
    [self addGestureRecognizer:tap];
    
}


- (void) tapAction:(UITapGestureRecognizer *)gesture {
    
    CGPoint point = [gesture locationInView:self];
    CGRect frame = [self convertRect:_panelView.frame toView:self];
    if (!CGRectContainsPoint(frame, point)) {
        [self removeFromSuperview];
    }
    
}



@end

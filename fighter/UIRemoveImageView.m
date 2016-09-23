//
//  UIRemoveImageView.m
//  fighter
//
//  Created by kang on 16/9/13.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "UIRemoveImageView.h"
@interface UIRemoveImageView ()
@property (nonatomic, strong) UIButton *removeBtn;
//@property (nonatomic, assign) BOOL removeButtonHidden;

@end
@implementation UIRemoveImageView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.removeBtnWidth = 18;
    self.removeBtnHeight = 18;
    [self setRemoveBtn];
    
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.removeBtnWidth = 18;
        self.removeBtnHeight = 18;
        [self setRemoveBtn];
    }
    
    return self;
}


//- (void) drawRect:(CGRect)rect {
//
//    [self setRemoveBtn];
//    
//    [super drawRect:rect];
//}
//
////- (void) layoutSubviews {
////
////    [super layoutSubviews];
////    
////    [self setRemoveBtn];
////}

- (void) setRemoveBtn {
    
    NSLog(@"set remove button ");
    if (self.removeBtn == nil) {
        
        self.removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.removeBtn.frame = CGRectMake(self.frame.size
                                          .width - self.removeBtnWidth-2,
                                          2,
                                          self.removeBtnWidth,
                                          self.removeBtnHeight);
        
        [self.removeBtn setImage:[UIImage imageNamed:@"选择分类-减"] forState:UIControlStateNormal];
        [self.removeBtn setImage:[UIImage imageNamed:@"选择分类-减pre"] forState:UIControlStateHighlighted];
        
        [self.removeBtn addTarget:self action:@selector(removeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.removeBtn setHidden:YES];
        [self addSubview:self.removeBtn];
        
        
        
        // 长按手势
        UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        longPressGr.minimumPressDuration = 1.0;
        [self addGestureRecognizer:longPressGr];
        
        // 单击手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction:)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tapGesture];
        
        self.userInteractionEnabled =YES;
    }
}

- (void) setVedioImage {

    UIImageView *videoImage = [[UIImageView alloc]init];
    videoImage.frame = CGRectMake(0, 0, 30, 24);
    videoImage.image = [UIImage imageNamed:@"详情用视频播放"];
    videoImage.center = self.center;
    videoImage.userInteractionEnabled = YES;
    [self addSubview:videoImage];
}


- (void) removeBtnAction:(UIButton *)sender {
    NSLog(@"removeBtnAction");
    
    if (self.delegate) {
        [self.delegate removeImage:self.image];
    }
    
    [self removeFromSuperview];
}


- (void) showButton {

    [self.removeBtn setHidden:NO];
//    if (self.removeButtonHidden == YES) {
//        [self.removeBtn setHidden:NO];
//        self.removeButtonHidden = NO;
//    }
}

- (void) hideButton {
    
     [self.removeBtn setHidden:YES];
    
//    if (self.removeButtonHidden == NO) {
//        [self.removeBtn setHidden:YES];
//        self.removeButtonHidden = YES;
//    }
}


-(void) longPressAction:(UIGestureRecognizer *) gesture {
    
    [self.delegate showRemoveButton];
}


- (void) singleTapAction:(UIGestureRecognizer *) gesture {

    [self.delegate hideRemoveButton];
//    CGPoint point = [gesture locationInView:self];
//    CGRect frame = [self convertRect:_removeBtn.frame toView:self];
//    if (!CGRectContainsPoint(frame, point)) {
//       
//    }else {
//        [self removeBtnAction:self.removeBtn];
//    }
}

@end

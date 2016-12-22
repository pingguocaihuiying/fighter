//
//  FTSegmentButtonView.m
//  fighter
//
//  Created by 李懿哲 on 24/11/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTSegmentButtonView.h"

@implementation FTSegmentButtonView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib{
    [super awakeFromNib];
    [_buttonLeft setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [_buttonRight setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
}


/**
 左边的按钮被点击

 @param sender sender
 */
- (IBAction)leftButtonClicked:(id)sender {
    _buttonLeft.selected = YES;
    _buttonMiddle.selected = NO;
    _buttonRight.selected = NO;
    NSLog(@"left button clicked.");
    [_delegate leftButtonClicked];
}

/**
 中间的按钮被点击
 
 @param sender sender
 */
- (IBAction)middleButtonClicked:(id)sender {
    _buttonLeft.selected = NO;
    _buttonMiddle.selected = YES;
    _buttonRight.selected = NO;
    NSLog(@"middle button clicked.");
    [_delegate middleButtonClicked];
}

/**
 右边的按钮被点击
 
 @param sender sender
 */
- (IBAction)rightButtonClicked:(id)sender {
    _buttonLeft.selected = NO;
    _buttonMiddle.selected = NO;
    _buttonRight.selected = YES;
    NSLog(@"right button clicked.");
    [_delegate rightButtonClicked];
}

- (void)setButtonCount:(int)buttonCount{
    switch (buttonCount) {
        case 3:
        {
            _buttonMiddle.hidden = NO;//将中间按钮设置为可见
            _middleButtonWidth.constant = 100;//将中间按钮的宽度设置为100
        }
            break;
            
        default:
            break;
    }
}

@end

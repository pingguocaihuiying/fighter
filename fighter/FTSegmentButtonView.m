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

- (IBAction)leftButtonClicked:(id)sender {
    _buttonLeft.selected = YES;
    _buttonRight.selected = NO;
    NSLog(@"left button clicked.");
    [_delegate leftButtonClicked];
}
- (IBAction)rightButtonClicked:(id)sender {
    _buttonLeft.selected = NO;
    _buttonRight.selected = YES;
    NSLog(@"right button clicked.");
    [_delegate rightButtonClicked];
}

@end

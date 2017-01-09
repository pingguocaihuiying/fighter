//
//  FTQuitGymViewAlertView.m
//  fighter
//
//  Created by 李懿哲 on 06/01/2017.
//  Copyright © 2017 Mapbar. All rights reserved.
//
#define TITLE @"确认退出吗？"
#define SUB_TITLE @"退出拳馆后将不再是该拳馆会员，将不能享受该拳馆的权益，拳馆余额也将清零"
#import "FTQuitGymViewAlertView.h"

@interface FTQuitGymViewAlertView()
@property (strong, nonatomic) IBOutlet UIView *dividingLine;

@end

@implementation FTQuitGymViewAlertView
- (void)awakeFromNib{
    [super awakeFromNib];
    _titleLabel.text = TITLE;
    _subTitleLabel.text = SUB_TITLE;
    _dividingLine.backgroundColor = Cell_Space_Color;
}
//cancel
- (IBAction)cancelButtonClicked:(id)sender {
    [self removeFromSuperview];
}
- (IBAction)confirmButtonClicked:(id)sender {
    [self removeFromSuperview];
}

@end

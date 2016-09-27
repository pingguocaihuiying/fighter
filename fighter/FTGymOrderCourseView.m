//
//  FTGymOrderCourseView.m
//  fighter
//
//  Created by 李懿哲 on 26/09/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTGymOrderCourseView.h"

@interface FTGymOrderCourseView()
@property (strong, nonatomic) IBOutlet UIView *seperatorView1;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel1;
@property (strong, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIButton *button2;


@end

@implementation FTGymOrderCourseView

- (void)awakeFromNib{
    [super awakeFromNib];
    _seperatorView1.backgroundColor = Cell_Space_Color;
}
- (IBAction)courseDetailButtonClicked:(id)sender {
    
    if (_status == FTGymCourseStatusCanOrder || _status == FTGymCourseStatusCantOrder) {
        NSLog(@"课程详情");
    } else if (_status == FTGymCourseStatusCancelOrder) {
        NSLog(@"点错了");
        [self removeFromSuperview];
    }
}

- (IBAction)confirmButtonClicked:(id)sender {
    if (_status == FTGymCourseStatusCanOrder) {
        NSLog(@"确定预约");
        self.status = FTGymCourseStatusHasOrder;
    } else if (_status == FTGymCourseStatusCancelOrder) {
        NSLog(@"确定取消预约");
        [self removeFromSuperview];
    }else if (_status == FTGymCourseStatusCancelOrder) {
        NSLog(@"不可预约下，点击了确定");
        [self removeFromSuperview];
    }
}

- (IBAction)cancelOrderButtonClicked:(id)sender {
    NSLog(@"取消预约");
    self.status = FTGymCourseStatusCancelOrder;
}

- (IBAction)iSeeButtonClicked:(id)sender {
    NSLog(@"我知道了");
    [self removeFromSuperview];
}

- (void)setStatus:(FTGymCourseStatus)status{
    _status = status;
    switch (status) {
        case FTGymCourseStatusHasOrder:
        {
            NSLog(@"已经预约");
            [self showBelowView2];
        }
        break;
        case FTGymCourseStatusCanOrder:
        {
            NSLog(@"可以预约");
            _messageLabel1.textColor = [UIColor colorWithHex:0x24b33c];
            _messageLabel1.text = @"8 / 15 可预约";
            [_button1 setTitle:@"课程详情" forState:UIControlStateNormal];
            [_button2 setTitle:@"确定预约" forState:UIControlStateNormal];
            [self showBelowView1];
        }
            break;
        case FTGymCourseStatusCantOrder:
        {
            NSLog(@"不可以预约");
            _messageLabel1.textColor = [UIColor redColor];
            _messageLabel1.text = @"15 / 15 已经满员";
            [_button1 setTitle:@"课程详情" forState:UIControlStateNormal];
            [_button2 setTitle:@"确定" forState:UIControlStateNormal];
            [self showBelowView1];
        }
        case FTGymCourseStatusCancelOrder:
        {
            NSLog(@"取消预约确认");
            _messageLabel1.textColor = [UIColor redColor];
            _messageLabel1.text = @"请确认取消该预约";
            [_button1 setTitle:@"点错了" forState:UIControlStateNormal];
            [_button2 setTitle:@"确定" forState:UIControlStateNormal];
            [self showBelowView1];
            
        }
            break;
        default:
            break;
    }
}

- (void)showBelowView1{
    _belowView1.hidden = NO;
    _belowView2.hidden = YES;
    _belowView1Height.constant = 88;//88
    _belowView2Height.constant = 0;//143
}

- (void)showBelowView2{
    _belowView1.hidden = YES;
    _belowView2.hidden = NO;
    _belowView1Height.constant = 0;//88
    _belowView2Height.constant = 143;//143
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self removeFromSuperview];
}


@end

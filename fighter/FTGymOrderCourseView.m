//
//  FTGymOrderCourseView.m
//  fighter
//
//  Created by 李懿哲 on 26/09/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTGymOrderCourseView.h"
#import "FTMatchPreViewController.h"

@interface FTGymOrderCourseView()
@property (strong, nonatomic) IBOutlet UIView *seperatorView1;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel1;
@property (strong, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIButton *button2;
@property (strong, nonatomic) IBOutlet UILabel *timeLabelFoo;
@property (strong, nonatomic) IBOutlet UILabel *courserNameLabelFoo;


@end

@implementation FTGymOrderCourseView

- (void)awakeFromNib{
    [super awakeFromNib];
    _seperatorView1.backgroundColor = Cell_Space_Color;
}
- (IBAction)courseDetailButtonClicked:(id)sender {
    
    if (_status == FTGymCourseStatusCanOrder || _status == FTGymCourseStatusCantOrder || _status == FTGymCourseStatusIsFull) {
        NSLog(@"课程详情");
        FTMatchPreViewController *matchPreVC = [FTMatchPreViewController new];
        matchPreVC.webViewURL = _webViewURL;
        matchPreVC.title = @"课程详情";
        UIViewController *vc = (UIViewController *)_delegate;
        [vc.navigationController pushViewController:matchPreVC animated:YES];
    } else if (_status == FTGymCourseStatusCancelOrder) {
        NSLog(@"点错了");
        [self removeFromSuperview];
    }
}

- (IBAction)confirmButtonClicked:(id)sender {
    if (_status == FTGymCourseStatusCanOrder) {
        NSLog(@"确定预约");
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setObject:_gymId forKey:@"gymId"];
        [dic setObject:_courserCellDic[@"timeId"] forKey:@"timeId"];
        [dic setObject:_courserCellDic[@"courseId"] forKey:@"courseId"];//date
        [dic setObject:_dateTimeStamp forKey:@"date"];
        [dic setObject:@"0" forKey:@"type"];
        [dic setObject:@"save" forKey:@"bookType"];
        [dic setObject:_courserCellDic[@"timeSection"] forKey:@"timeSection"];
        
        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
       [NetWorking orderCourseWithParamsDic:(NSMutableDictionary *)dic andOption:^(NSDictionary *dic) {
           [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
            NSLog(@"dic : %@", dic);
            NSString *status = dic[@"status"];
            NSString *message = dic[@"message"];
            if ([status isEqualToString:@"success"]) {
                NSLog(@"约课成功");
                _messageLabel1.text = @"预约成功！";
                
                if ([_delegate respondsToSelector:@selector(bookSuccess)]) {
                    [_delegate bookSuccess];//刷新课程信息
                }
                self.status = FTGymCourseStatusHasOrder;
            } else {
                NSLog(@"约课失败，message  %@", message);
                [[[UIApplication sharedApplication] keyWindow] showHUDWithMessage:message];
            }
        }];
        
        
    } else if (_status == FTGymCourseStatusCancelOrder) {
        NSLog(@"确定取消预约");
        
        if (_courseType == FTOrderCourseTypeGym) {
            NSMutableDictionary *dic = [NSMutableDictionary new];
            [dic setObject:_gymId forKey:@"gymId"];
            [dic setObject:_courserCellDic[@"timeId"] forKey:@"timeId"];
            [dic setObject:_courserCellDic[@"courseId"] forKey:@"courseId"];//date
            [dic setObject:_dateTimeStamp forKey:@"date"];
            [dic setObject:@"0" forKey:@"type"];
            [dic setObject:@"delete" forKey:@"bookType"];
            [dic setObject:_courserCellDic[@"timeSection"] forKey:@"timeSection"];
            
            [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
            [NetWorking orderCourseWithParamsDic:(NSMutableDictionary *)dic andOption:^(NSDictionary *dic) {
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
                NSLog(@"dic : %@", dic);
                NSString *status = dic[@"status"];
                NSString *message = dic[@"message"];
                if ([status isEqualToString:@"success"]) {
                    NSLog(@"取消约课成功");
                    [[[UIApplication sharedApplication] keyWindow] showHUDWithMessage:@"取消成功"];
                    if ([_delegate respondsToSelector:@selector(bookSuccess)]) {
                        [_delegate bookSuccess];//刷新课程信息
                    }
                    [self removeFromSuperview];
                } else {
                    NSLog(@"取消约课失败，message  %@", message);
                    [[[UIApplication sharedApplication] keyWindow] showHUDWithMessage:message];
                }
            }];
        } else if (_courseType == FTOrderCourseTypeCoach) {
            NSMutableDictionary *dic = [NSMutableDictionary new];
            [dic setObject:_gymId forKey:@"gymId"];
            [dic setObject:_timeSectionId forKey:@"timeId"];
            [dic setObject:_dateTimeStamp forKey:@"date"];
            [dic setObject:@"2" forKey:@"type"];
            [dic setObject:@"delete" forKey:@"bookType"];
            [dic setObject:_timeSection forKey:@"timeSection"];//
            [dic setObject:_coachUserId forKey:@"coachUserId"];
            
            //    NSString *fenString = [NSString stringWithFormat:@"%.0lf", [_price doubleValue] * 100];
            [dic setObject:_price forKey:@"price"];
            
            
            [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
            [NetWorking orderCourseWithParamsDic:(NSMutableDictionary *)dic andOption:^(NSDictionary *dic) {
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
                NSLog(@"dic : %@", dic);
                NSString *status = dic[@"status"];
                NSString *message = dic[@"message"];
                if ([status isEqualToString:@"success"]) {
                    NSLog(@"取消约课成功");
                    [[[UIApplication sharedApplication] keyWindow] showHUDWithMessage:@"取消约课成功"];
                    
                    [self removeFromSuperview];
                    
                    if ([_delegate respondsToSelector:@selector(bookSuccess)]) {
                        [_delegate bookSuccess];//刷新课程信息
                    }
                    
                } else {
                    NSLog(@"约课失败，message  %@", message);
                    [[[UIApplication sharedApplication] keyWindow] showHUDWithMessage:message];
                }
            }];

        }
        


        
        
    }else if (_status == FTGymCourseStatusCancelOrder) {
        NSLog(@"不可预约下，点击了确定");
        [self removeFromSuperview];
    }else if (_status == FTGymCourseStatusIsFull) {
        NSLog(@"满员，点击了确定");
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
            _messageLabel1.textColor = [UIColor colorWithHex:0x25b33c];
            _messageLabel1.text = @"预约成功";
            [self showBelowView2];
        }
        break;
        case FTGymCourseStatusCanOrder:
        {
            NSLog(@"可以预约");
            _messageLabel1.textColor = [UIColor colorWithHex:0x24b33c];
            _messageLabel1.text = [NSString stringWithFormat:@"%@ / %@ 可预约", _courserCellDic[@"hasOrderCount"], _courserCellDic[@"topLimit"]];
            [_button1 setTitle:@"课程详情" forState:UIControlStateNormal];
            [_button2 setTitle:@"确定预约" forState:UIControlStateNormal];
            [self showBelowView1];
        }
            break;
            
        case FTGymCourseStatusIsFull:
        {
            NSLog(@"满员无法预约");
            _messageLabel1.textColor = [UIColor redColor];
            _messageLabel1.text = [NSString stringWithFormat:@"%@ / %@ 已经满员", _courserCellDic[@"hasOrderCount"], _courserCellDic[@"topLimit"]];
            [_button1 setTitle:@"课程详情" forState:UIControlStateNormal];
            [_button2 setTitle:@"确定" forState:UIControlStateNormal];
            [self showBelowView1];
            
        }
            break;
        case FTGymCourseStatusCantOrder:
        {
            NSLog(@"不可以预约");
            _messageLabel1.textColor = [UIColor redColor];
            _messageLabel1.text = @"不可预约";
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

- (void)setCourserCellDic:(NSDictionary *)courserCellDic{
    _courserCellDic = courserCellDic;
    NSString *timeSection = _courserCellDic[@"timeSection"];
    if (!timeSection) {
        timeSection = _timeSection;
    }
    _timeLabelFoo.text = [NSString stringWithFormat:@"%@ %@", _dateString, timeSection];
    _courserNameLabelFoo.text = _courserCellDic[@"label"];
}


@end

//
//  FTGymCoachStateSwitcher.m
//  fighter
//
//  Created by kang on 2016/9/27.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTGymCoachStateSwitcher.h"

@interface FTGymCoachStateSwitcher ()



@end

@implementation FTGymCoachStateSwitcher

-(void) awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorWithHex:0x191919 alpha:0.5];
    self.opaque = NO;
    
    self.segmentedButton.imageEdgeInsets = UIEdgeInsetsMake(0, 112, 0, 0);
    self.segmentedButton.titleEdgeInsets = UIEdgeInsetsMake(0, -112, 0, 112);
    
}


- (IBAction)segmentedButtonAction:(id)sender {
    _canOrder = !_canOrder;
    [self updateStatus];
}

- (void)updateDisplay{
    //更新时间信息
    _dateLabel.text = [NSString stringWithFormat:@"%@ %@", _dateString, _timeSection];
    
    [self updateStatus];
}
- (void)updateStatus{
    if (_canOrder) {
        [self.segmentedButton setTitle:@"可预约" forState:UIControlStateNormal];
        [self.segmentedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.segmentedButton setBackgroundImage:[UIImage imageNamed:@"切换状态-红bg"] forState:UIControlStateNormal];
        
        self.segmentedButton.imageEdgeInsets = UIEdgeInsetsMake(0, 112, 0, 0);
        self.segmentedButton.titleEdgeInsets = UIEdgeInsetsMake(0, -112, 0, 112);
    }else {
        [self.segmentedButton setTitle:@"不可预约" forState:UIControlStateNormal];
        [self.segmentedButton setTitleColor:Main_Text_Color forState:UIControlStateNormal];
        [self.segmentedButton setBackgroundImage:[UIImage imageNamed:@"切换状态-灰bg"] forState:UIControlStateNormal];
        
        self.segmentedButton.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 30);
        self.segmentedButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
}
- (IBAction)confirmButtonClicked:(id)sender {
    
    if(_canOrder == _canOrderOriginal){//如果修改的状态和原状态一样，直接返回
        NSLog(@"修改的状态和原状态一样");
        return;
    }else{
        NSLog(@"确认更改状态");
        
            
            NSMutableDictionary *dic = [NSMutableDictionary new];
            [dic setObject:_corporationid forKey:@"gymId"];
            [dic setObject:_timeSectionId forKey:@"timeId"];
            [dic setObject:_dateTimeStamp forKey:@"date"];
            [dic setObject:@"2" forKey:@"type"];
            [dic setObject:@"save" forKey:@"bookType"];
            [dic setObject:_timeSection forKey:@"timeSection"];
        
            NSString *isDelated = @"";//值为1-设置不可约，0-设置可约
        if (_canOrder) {
            isDelated = @"0";
        } else {
            isDelated = @"1";
        }
            [dic setObject:isDelated forKey:@"isDelated"];
            
            [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
            [NetWorking changeCourseStatusWithParamsDic:(NSMutableDictionary *)dic andOption:^(NSDictionary *dic) {
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
                NSLog(@"dic : %@", dic);
                NSString *status = dic[@"status"];
                NSString *message = dic[@"message"];
                if ([status isEqualToString:@"success"]) {
                    [[[UIApplication sharedApplication] keyWindow] showHUDWithMessage:@"更改状态成功！"];
                    [_delegate changeCourseStatusSuccess];
                    [self removeFromSuperview];
                }else {
                    NSLog(@"约课失败，message  %@", message);
                    [[[UIApplication sharedApplication] keyWindow] showHUDWithMessage:message];
                        //更改失败，把状态改为原状态
                        _canOrder = _canOrderOriginal;
                        [self updateStatus];
                }
            }];
        
    }
}
- (IBAction)cancelButtonClicked:(id)sender {
    NSLog(@"取消更改状态");
    [self removeFromSuperview];
}

@end

//
//  FTGymOrderCoachView.m
//  fighter
//
//  Created by kang on 2016/9/27.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTGymOrderCoachView.h"
#import "FTGymOrderCourseView.h"
#import "FTOrderCoachViewController.h"
#import "FTGymRechargeViewController.h"
#import "FTBaseNavigationViewController.h"

@implementation FTGymOrderCoachView

#pragma mark - response

- (void)awakeFromNib{
    [super awakeFromNib];
    //注册通知，用于接收充值成功的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(rechargeMoney:) name:RechargeMoneytNoti object:nil];
    
}

- (void)rechargeMoney:(id)info{
    NSString *msg = [info object];
    if ([msg isEqualToString:@"SUCESS"]){
        [self getVIPInfo];
    }
}



/**
 获取会员信息
 */
- (void)getVIPInfo{
    
    [NetWorking getVIPInfoWithGymId:[NSString stringWithFormat:@"%@", _gymId] andOption:^(NSDictionary *dic) {
        
        //无数据：非会员
        //"type"为会员类型： 0准会员 1会员 2往期会员
        
        NSString *status = dic[@"status"];
        NSLog(@"status : %@", status);
        FTGymVIPType gymVIPType;
        if ([status isEqualToString:@"success"]) {
            NSString *type = dic[@"data"][@"type"];
            gymVIPType = [type integerValue];
            if (gymVIPType == FTGymVIPTypeYep) {//如果已经是会员，更新会员信息的展示
//                [self updateVIPInfoUIWithDic:dic[@"data"]];
                //更新余额
                NSString *balance = dic[@"data"][@"money"];
                if (!balance) {
                    balance = @"0";
                }
                _balance = [NSString stringWithFormat:@"%@", balance];
                
                
                //更新余额start
                if (!_balance) {
                    _balance = @"-1";
                }
                
                balance = [NSString stringWithFormat:@"%.0lf", [balance doubleValue] / 100];
                NSMutableDictionary *dic4 = [NSMutableDictionary new];
                dic4[NSForegroundColorAttributeName] = Custom_Red;
                dic4[NSFontAttributeName] = [UIFont systemFontOfSize:16];
                NSAttributedString *attSTr4 = [[NSAttributedString alloc]initWithString:balance attributes:dic4];
                
                
                NSMutableDictionary *dic5 = [NSMutableDictionary new];
                dic5[NSForegroundColorAttributeName] = Custom_Red;
                dic5[NSFontAttributeName] = [UIFont systemFontOfSize:12];
                NSAttributedString *attSTr5 = [[NSAttributedString alloc]initWithString:@"元" attributes:dic5];
                
                
                NSMutableAttributedString *mutaAttrString2 = [[NSMutableAttributedString alloc]init];
                [mutaAttrString2 appendAttributedString:attSTr4];
                [mutaAttrString2 appendAttributedString:attSTr5];
                
                _balanceLabel.attributedText = mutaAttrString2;
                //更新余额end
                
            }else if (gymVIPType == FTGymVIPTypeApplying){
                
            }
        }else{
            gymVIPType = FTGymVIPTypeNope;
            
        }
        
    }];
}

- (IBAction)rechargeButtonAction:(id)sender {
    FTGymRechargeViewController *gymRechargeViewController = [FTGymRechargeViewController new];
    gymRechargeViewController.corporationId = [_gymId integerValue];
    FTBaseNavigationViewController *nav = [[FTBaseNavigationViewController alloc]initWithRootViewController:gymRechargeViewController];
    UIViewController *fatherVierController = (UIViewController *)_delegate;
    [fatherVierController.navigationController presentViewController:nav animated:YES completion:nil];
}

- (IBAction)confirmButtonAction:(id)sender {
    NSLog(@"确定");
    
    if (_bookedByOthers) {
        [self cancelButtonAction:nil];
    } else {
        
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setObject:_gymId forKey:@"gymId"];
        [dic setObject:_timeSectionId forKey:@"timeId"];
        [dic setObject:_dateTimeStamp forKey:@"date"];
        [dic setObject:@"2" forKey:@"type"];
        [dic setObject:@"save" forKey:@"bookType"];
        [dic setObject:_timeSection forKey:@"timeSection"];
        [dic setObject:_coachUserId forKey:@"coachUserId"];
        [dic setObject:_price forKey:@"price"];
        
        
        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [NetWorking orderCourseWithParamsDic:(NSMutableDictionary *)dic andOption:^(NSDictionary *dic) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
            NSLog(@"dic : %@", dic);
            NSString *status = dic[@"status"];
            NSString *message = dic[@"message"];
            if ([status isEqualToString:@"success"]) {
                NSLog(@"约课成功");
                [[[UIApplication sharedApplication] keyWindow] showHUDWithMessage:@"约课成功"];
                
                [self removeFromSuperview];
                if ([_delegate respondsToSelector:@selector(bookCoachSuccess)]) {
                    [_delegate bookCoachSuccess];//刷新课程信息
                }
                
                //约课成功后，显示约课成功提示框
                FTGymOrderCourseView *gymOrderCourseView = [[[NSBundle mainBundle]loadNibNamed:@"FTGymOrderCourseView" owner:nil options:nil] firstObject];
                gymOrderCourseView.frame = CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT);
                gymOrderCourseView.courseType = FTOrderCourseTypeCoach;
                gymOrderCourseView.dateString = _dateString;
                gymOrderCourseView.dateTimeStamp = _dateTimeStamp;
                
                gymOrderCourseView.price = _price;
                gymOrderCourseView.coachName = _coachName;
                gymOrderCourseView.courserCellDic = _courserCellDic;
                gymOrderCourseView.timeSection = _timeSection;
                gymOrderCourseView.timeSectionId = _timeSectionId;
                gymOrderCourseView.balance = _balance;
                gymOrderCourseView.gymId = _gymId;
                gymOrderCourseView.coachUserId = _coachUserId;
                
                NSLog(@"已经预约");
                
                NSDictionary *courseCellDic = _courserCellDic;
                gymOrderCourseView.courserCellDic = courseCellDic;
                FTOrderCoachViewController *orderCoachViewController = (FTOrderCoachViewController *)_delegate;
                gymOrderCourseView.delegate = orderCoachViewController;
                gymOrderCourseView.status = FTGymCourseStatusHasOrder;
                [orderCoachViewController.view addSubview:gymOrderCourseView];
                
                
                
                
            } else {
                NSLog(@"约课失败，message  %@", message);
                [[[UIApplication sharedApplication] keyWindow] showHUDWithMessage:message];
            }
        }];
    }
 
}

- (IBAction)cancelButtonAction:(id)sender {
    [self removeFromSuperview];
}

- (void)setDisplay{
    _titleLabel.text = [NSString stringWithFormat:@"确定预约 %@ 的课吗？", _coachName];
    _dateLabel.text = [NSString stringWithFormat:@"%@ %@", _dateString, _timeSection];
    
    //价格start
    NSMutableDictionary *dic1 = [NSMutableDictionary new];
    dic1[NSForegroundColorAttributeName] = [UIColor whiteColor];
    dic1[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    NSAttributedString *attSTr1 = [[NSAttributedString alloc]initWithString:@"本次预约消耗：" attributes:dic1];
    
    if (!_price) {
        _price = @"-1";
    }
    NSMutableDictionary *dic2 = [NSMutableDictionary new];
    dic2[NSForegroundColorAttributeName] = Custom_Red;
    dic2[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    NSAttributedString *attSTr2 = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%d", [_price intValue] / 100 ] attributes:dic2];
    
    NSMutableDictionary *dic3 = [NSMutableDictionary new];
    dic3[NSForegroundColorAttributeName] = Custom_Red;
    dic3[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    NSAttributedString *attSTr3 = [[NSAttributedString alloc]initWithString:@"元" attributes:dic3];
    
    NSMutableAttributedString *mutaAttrString = [[NSMutableAttributedString alloc]init];
    [mutaAttrString appendAttributedString:attSTr1];
    [mutaAttrString appendAttributedString:attSTr2];
    [mutaAttrString appendAttributedString:attSTr3];
    
    _consumeLabel.attributedText = mutaAttrString;
    //价格end
    
    //余额start
    if (!_balance) {
        _balance = @"-1";
    }
    NSString *balance = [NSString stringWithFormat:@"%@", _balance];
    balance = [NSString stringWithFormat:@"%.0lf", [balance doubleValue] / 100];
    NSMutableDictionary *dic4 = [NSMutableDictionary new];
    dic4[NSForegroundColorAttributeName] = Custom_Red;
    dic4[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    NSAttributedString *attSTr4 = [[NSAttributedString alloc]initWithString:balance attributes:dic4];
    

    NSMutableDictionary *dic5 = [NSMutableDictionary new];
    dic5[NSForegroundColorAttributeName] = Custom_Red;
    dic5[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    NSAttributedString *attSTr5 = [[NSAttributedString alloc]initWithString:@"元" attributes:dic5];

    
    NSMutableAttributedString *mutaAttrString2 = [[NSMutableAttributedString alloc]init];
    [mutaAttrString2 appendAttributedString:attSTr4];
    [mutaAttrString2 appendAttributedString:attSTr5];
    
    _balanceLabel.attributedText = mutaAttrString2;
    //余额end
}
- (void)setDisplayWithInfo{
    _titleLabel.text = [NSString stringWithFormat:@"%@ 老师", _coachName];
    _dateLabel.text = [NSString stringWithFormat:@"在这个时间段已经被预约啦~"];
    
    //隐藏消耗多少金额的label
    _consumeLabel.hidden = YES;
    
    //余额start
    if (!_balance) {
        _balance = @"-1";
    }
    NSString *balance = [NSString stringWithFormat:@"%@", _balance];
    balance = [NSString stringWithFormat:@"%.0lf", [balance doubleValue] / 100];
    
    NSMutableDictionary *dic4 = [NSMutableDictionary new];
    dic4[NSForegroundColorAttributeName] = Custom_Red;
    dic4[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    NSAttributedString *attSTr4 = [[NSAttributedString alloc]initWithString:balance attributes:dic4];
    
    
    NSMutableDictionary *dic5 = [NSMutableDictionary new];
    dic5[NSForegroundColorAttributeName] = Custom_Red;
    dic5[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    NSAttributedString *attSTr5 = [[NSAttributedString alloc]initWithString:@"元" attributes:dic5];
    
    
    NSMutableAttributedString *mutaAttrString2 = [[NSMutableAttributedString alloc]init];
    [mutaAttrString2 appendAttributedString:attSTr4];
    [mutaAttrString2 appendAttributedString:attSTr5];
    
    _balanceLabel.attributedText = mutaAttrString2;
    //余额end
}

@end

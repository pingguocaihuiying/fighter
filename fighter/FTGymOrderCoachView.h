//
//  FTGymOrderCoachView.h
//  fighter
//
//  Created by kang on 2016/9/27.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTGymOrderCoachView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *consumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *rechargeButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;


@property (nonatomic, strong) NSDictionary *courserCellDic;//存放一小段课程
@property (nonatomic, copy) NSString *dateTimeStamp;//课程那一天的时间戳
@property (nonatomic, copy) NSString *dateString;//课程那一天的日期，eg：7月8日
@property (nonatomic, copy) NSString *gymId;//拳馆id
@property (nonatomic, copy) NSString *coachName;//拳馆id
@property (nonatomic, copy) NSString *price;//拳馆id
@property (nonatomic, copy) NSString *timeSection;//拳馆id
@property (nonatomic, copy) NSString *balance;//余额

- (void)setDisplay;

@end

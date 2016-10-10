//
//  FTGymOrderCoachView.h
//  fighter
//
//  Created by kang on 2016/9/27.
//  Copyright © 2016年 Mapbar. All rights reserved.
//
@protocol FTCoachOrderCourseViewDelegate <NSObject>
- (void)bookCoachSuccess;
@end


#import <UIKit/UIKit.h>



@interface FTGymOrderCoachView : UIView

@property (nonatomic, weak) id<FTCoachOrderCourseViewDelegate> delegate;

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
@property (nonatomic, copy) NSString *coachName;//教练名字
@property (nonatomic, copy) NSString *price;//预约的私教的价格
@property (nonatomic, copy) NSString *timeSection;//时间段
@property (nonatomic, copy) NSString *timeSectionId;//时间段id
@property (nonatomic, copy) NSString *balance;//余额
@property (nonatomic, copy) NSString *coachUserId;//教练id

@property (nonatomic, assign) BOOL bookedByOthers;//是否已经被其他人预约


- (void)setDisplay;//预约时的展示方法
- (void)setDisplayWithInfo;//提示已经被别人预约的展示方法


@end

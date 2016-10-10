//
//  FTGymCoachStateSwitcher.h
//  fighter
//
//  Created by kang on 2016/9/27.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

@protocol FTCoachChangeCourseStatusDelegate <NSObject>

- (void) changeCourseStatusSuccess;

@end

#import <UIKit/UIKit.h>

@interface FTGymCoachStateSwitcher : UIView

@property (nonatomic, weak) id<FTCoachChangeCourseStatusDelegate> delegate;

@property (nonatomic, assign) BOOL canOrder;//是否可约（当前的状态）
@property (nonatomic, assign) BOOL canOrderOriginal;//原（可约不可约）状态

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *segmentedButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

- (void)updateDisplay;
- (void)updateStatus;

@property (nonatomic, copy) NSString *dateTimeStamp;//课程那一天的时间戳
@property (nonatomic, copy) NSString *dateString;//课程那一天的日期，eg：7月8日
@property (nonatomic, copy) NSString *timeSection;//时间段
@property (nonatomic, copy) NSString *timeSectionId;//时间段id
@property (nonatomic, copy) NSString *corporationid;//时间段id

@end

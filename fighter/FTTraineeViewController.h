//
//  FTCourseViewController.h
//  fighter
//
//  Created by kang on 2016/10/31.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTBaseViewController2.h"
#import "FTTraineeBaseViewController.h"
#import "FTCourseHistoryBean.h"

typedef NS_ENUM(NSInteger, FTTraineeCourseState) {
    FTTraineeCourseStateComplete,//历史课程
    FTTraineeCourseStateWaiting,//计划课程
};

typedef NS_ENUM(NSInteger, FTCoachCourseType) {
    FTCoachCourseTypePublic,
    FTCoachCourseTypePersonal
};

/**
 教练端页面，展示上课学员
 */
@interface FTTraineeViewController : FTTraineeBaseViewController

@property (nonatomic, strong) FTCourseHistoryBean *bean;
@property (nonatomic, assign) FTTraineeCourseState courseState;
@property (nonatomic, assign) FTCoachCourseType courseType;
@end

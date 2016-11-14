//
//  FTCourseViewController.h
//  fighter
//
//  Created by kang on 2016/10/31.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTBaseViewController2.h"
#import "FTTraineeBaseViewController.h"
#import "FTHistoryCourseBean.h"
#import "FTCourseBean.h"
#import "FTCourseHeaderFile.h"

/**
 教练端页面，展示上课学员
 */
@interface FTTraineeViewController : FTTraineeBaseViewController

@property (nonatomic, strong) id bean;
@property (nonatomic, assign) FTCourseState courseState;
@property (nonatomic, assign) FTCourseType courseType;
@end

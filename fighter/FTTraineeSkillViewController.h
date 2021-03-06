//
//  FTTraineeSkillViewController.h
//  fighter
//
//  Created by kang on 2016/11/1.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTTraineeBaseViewController.h"
#import "FTHistoryCourseBean.h"
#import "FTCourseHeaderFile.h"
#import "FTTraineeBean.h"
/**
 学员技能项展示页
 */
@interface FTTraineeSkillViewController : FTTraineeBaseViewController

@property (nonatomic, strong) FTHistoryCourseBean *bean;
@property (nonatomic, strong) NSMutableDictionary *notificationDic;
@end

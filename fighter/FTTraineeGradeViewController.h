//
//  FTTraineeGradeViewController.h
//  fighter
//
//  Created by kang on 2016/11/1.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTTraineeBaseViewController.h"
#import "FTHistoryCourseBean.h"
#import "FTTraineeSkillBean.h"
#import "FTCourseHeaderFile.h"

@interface FTTraineeGradeViewController : FTTraineeBaseViewController

@property (nonatomic, strong) FTHistoryCourseBean *bean;
@property (nonatomic, strong) FTTraineeSkillBean *parentBean;
@property (assign, nonatomic) NSInteger shouldEditNum;
@property (nonatomic, copy) TransmitParamsBlock paramsBlock;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

//
//  FTUserCourseCommentViewController.h
//  fighter
//
//  Created by 李懿哲 on 10/11/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//
typedef NS_ENUM(NSInteger, FTUserSkillType){
    FTUserSkillTypeCoachComment = 0, //教练评论
    FTUserSkillTypeChildSkill = 1 //技能子项提升详情
} ;
#import "FTTraineeBaseViewController.h"
#import "FTUserSkillBean.h"

@interface FTUserCourseCommentViewController : FTTraineeBaseViewController

@property (nonatomic, copy) NSString *courseRecordVersion;

@property (nonatomic, assign) FTUserSkillType type;//类型
@property (nonatomic, strong) FTUserSkillBean *fatherSkillBean;//母项技能，用于展示上方的技能概览
@property (nonatomic, strong) NSMutableArray *skillArray;//最新的子项技能array
@property (nonatomic, strong) NSMutableArray *skillArrayOld;//原来的的子项技能array（用于和新的对比技能值变化）

@property (nonatomic, copy) NSString *courseName;
@end

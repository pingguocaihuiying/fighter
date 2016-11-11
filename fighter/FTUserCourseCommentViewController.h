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

@interface FTUserCourseCommentViewController : FTTraineeBaseViewController
@property (nonatomic, assign) FTUserSkillType *type;//类型
@end

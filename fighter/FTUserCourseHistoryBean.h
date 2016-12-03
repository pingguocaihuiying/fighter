//
//  FTUserCourseHistoryBean.h
//  fighter
//
//  Created by 李懿哲 on 08/11/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTBaseBean.h"

@interface FTUserCourseHistoryBean : FTBaseBean

@property (nonatomic, assign) NSString *version;//版本号

@property (nonatomic, copy) NSString *date;//上课日期
@property (nonatomic, copy) NSString *coachName;//教练名
@property (nonatomic, copy) NSString *courseName;//团课名
@property (nonatomic, copy) NSString *timeSection;//时间段，例如："9:00~10:00"
@property (nonatomic, copy) NSString *label;//项目类型名称，例如："综合格斗(MMA)"
@property (nonatomic, copy) NSString *courseType;//0-团课，2-私教

- (void)setWithCourseDic:(NSDictionary *)dic;//根据课程字典设置bean

@end

//
//  FTUserCourseHistoryBean.m
//  fighter
//
//  Created by 李懿哲 on 08/11/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTUserCourseHistoryBean.h"

@implementation FTUserCourseHistoryBean

//根据课程字典设置bean
- (void)setWithCourseDic:(NSDictionary *)dic{
    
    //版本
    NSString *version = dic[@"versions"];
    if (version) {
        _version = [NSString stringWithFormat:@"%@", version];
    }
    
    //日期
    NSString *date = dic[@"date"];
    if (date) {
        _date = [NSString stringWithFormat:@"%@", date];
    }
    
    //教练名字
    NSString *coachName = dic[@"coachName"];
    if (coachName) {
        _coachName = [NSString stringWithFormat:@"%@", coachName];
    }
    
    //团课名字
    NSString *courseName = dic[@"name"];
    if (courseName) {
        _courseName = [NSString stringWithFormat:@"%@", courseName];
    }
    
    //时间段
    NSString *timeSection = dic[@"timeSection"];
    if (timeSection) {
        _timeSection = [NSString stringWithFormat:@"%@", timeSection];
    }
    
    //课程类型：0-团课，2-私教
    NSString *courseType = dic[@"type"];
    if (courseType) {
        _courseType = [NSString stringWithFormat:@"%@", courseType];
    }
    
    //项目类型
    NSString *label = dic[@"label"];
    if (label) {
        _label = [NSString stringWithFormat:@"%@", label];
    }
}

- (void)setValuesWithDic:(NSDictionary *)dic{
    [self setWithCourseDic:dic];
}

@end

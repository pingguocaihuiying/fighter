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
    }else{
        _version = @"0";
    }
    
    //日期
    NSString *date = dic[@"date"];
    if (date) {
        _date = [NSString stringWithFormat:@"%@", date];
    }else{
        _date = @"0";
    }
    
    //教练名字
    NSString *coachName = dic[@"coachName"];
    if (coachName) {
        _coachName = [NSString stringWithFormat:@"%@", coachName];
    }else{
        _coachName = @"孙悟空";
    }
    
    //团课名字
    NSString *courseName = dic[@"name"];
    if (courseName) {
        _courseName = [NSString stringWithFormat:@"%@", courseName];
    }else{
        _courseName = @"天马流星拳入门";
    }
    
    //时间段
    NSString *timeSection = dic[@"timeSection"];
    if (timeSection) {
        _timeSection = [NSString stringWithFormat:@"%@", timeSection];
    }else{
        _timeSection = @"0:00~24:00";
    }
    
    //课程类型：0-团课，2-私教
    NSString *courseType = dic[@"type"];
    if (courseType) {
        _courseType = [NSString stringWithFormat:@"%@", courseType];
    }else{
        _courseType = @"-1";
    }
    
    //项目类型
    NSString *label = dic[@"label"];
    if (label) {
        _label = [NSString stringWithFormat:@"%@", label];
    }else{
        _label = @"";
    }
}

- (void)setValuesWithDic:(NSDictionary *)dic{
    [self setWithCourseDic:dic];
}

@end

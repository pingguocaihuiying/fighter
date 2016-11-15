//
//  FTHistoryCourseBean.h
//  fighter
//
//  Created by kang on 2016/10/10.
//  Copyright © 2016年 Mapbar. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "FTBaseBean.h"

@interface FTHistoryCourseBean : FTBaseBean

@property (nonatomic, assign) NSInteger updateTime;

@property (nonatomic, assign) NSInteger corporationid;

@property (nonnull, nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger statu;

@property (nonatomic, assign) NSInteger courseId;

@property (nonnull, nonatomic, copy) NSString *coachUserId;

@property (nonatomic, assign) NSInteger placeId;

@property (nonatomic, assign) NSInteger createTime;

@property (nonatomic, assign) NSInteger date;

@property (nonatomic, assign) NSInteger timeId;

@property (nonnull, nonatomic, copy) NSString *updateName;

@property (nonnull, nonatomic, copy) NSString *label;

@property (nonnull, nonatomic, copy) NSString *updateTimeTamp;

@property (nonnull, nonatomic, copy) NSString *createTimeTamp;

@property (nonnull, nonatomic, copy) NSString *type;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, assign) NSInteger bookId;

@property (nonnull, nonatomic, copy) NSString *createName; // 私课学员名称

@property (nonnull, nonatomic, copy) NSString *timeSection;

@property (nullable, nonatomic, copy) NSString *dateString; // 记录日期

@property (nonnull, nonatomic, copy) NSString *memberUserId;// 私课学员userId

@property (nonatomic, assign) NSInteger hasGradeCount;//已评分人数

@property (nonatomic, assign) NSInteger attendCount;//签到（上课）人数

@property (nonatomic, assign) NSInteger hasOrderCount;//预约人数

@property (nonatomic, assign) NSInteger topLimit;//团课允许最大人数

- (_Nonnull instancetype)initWithFTHistoryCourseBeanDic:(NSDictionary * _Nonnull)infoDic;

@end

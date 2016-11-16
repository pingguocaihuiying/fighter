//
//  FTCourseBean
//  fighter
//
//  Created by kang on 2016/11/10.
//  Copyright © 2016年 Mapbar. All rights reserved.
//
#import <Foundation/Foundation.h>

/**
 私教 课程表课程
 */
@interface FTSchedulePrivateBean : NSObject

@property (nonatomic, assign) NSInteger myIsOrd;

@property (nonatomic, assign) long updateTime;

@property (nonnull, nonatomic, copy) NSString *timeSection;

@property (nonatomic, assign) NSInteger corporationid;

@property (nonatomic, assign) NSInteger courseId;

@property (nonnull, nonatomic, copy) NSString *coachUserId;

@property (nonnull, nonatomic, copy) NSString *userId;

@property (nonatomic, assign) NSInteger timeId;

@property (nonatomic, assign) long createTime;

@property (nonnull, nonatomic, copy) NSString *createTimeTamp;

@property (nonatomic, assign) long date;

@property (nonatomic, assign) NSInteger theDate;

@property (nonatomic, assign) NSInteger placeId;

@property (nonnull, nonatomic, copy) NSString *updateName;

@property (nonnull, nonatomic, copy) NSString *updateTimeTamp;

@property (nonnull, nonatomic, copy) NSString *coachName;

@property (nonnull, nonatomic, copy) NSString *label;

@property (nonnull, nonatomic, copy) NSString *type;

@property (nonatomic, assign) NSInteger id;

@property (nonnull, nonatomic, copy) NSString *createName;

- (_Nonnull instancetype)initWithFTCourseBeanDic:(NSDictionary * _Nonnull)infoDic;

@end

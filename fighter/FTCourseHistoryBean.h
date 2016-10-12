//
//  FTCourseHistoryBean.h
//  fighter
//
//  Created by kang on 2016/10/10.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTBaseBean.h"

@interface FTCourseHistoryBean : FTBaseBean

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *coachUserId;
@property (nonatomic, assign) NSInteger corporationid;

@property (nonatomic, copy) NSString *coachName;
@property (nonatomic, copy) NSString *createName;
@property (nonatomic, copy) NSString *updateName;


@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *createTimeTamp;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *updateTimeTamp;
@property (nonatomic, copy) NSString *date;

@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) NSInteger signStatus;

@property (nonatomic, assign) NSInteger theDate;
@property (nonatomic, assign) NSInteger timeId;

@property (nonatomic, copy) NSString *timeSection;


@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *dateString;
@end

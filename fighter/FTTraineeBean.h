//
//  FTTraineeBean.h
//  fighter
//
//  Created by kang on 2016/11/9.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTTraineeBean : NSObject

@property (nonatomic, assign) long updateTime;

@property (nonnull, nonatomic, copy) NSString *timeSection;

@property (nonatomic, assign) NSInteger corporationid;

@property (nonatomic, assign) NSInteger courseId;

@property (nonnull, nonatomic, copy) NSString *userId;

@property (nonnull, nonatomic, copy) NSString *sex;

@property (nonatomic, assign) NSInteger newMember;

@property (nonatomic, assign) NSInteger timeId;

@property (nonnull, nonatomic, copy) NSString *updateTimeTamp;

@property (nonnull, nonatomic, copy) NSString *label;

@property (nonatomic, assign) NSInteger id;

@property (nonnull, nonatomic, copy) NSString *createTimeTamp;

@property (nonnull, nonatomic, copy) NSString *coachName;

@property (nonatomic, assign) NSInteger signStatus;

@property (nonnull, nonatomic, copy) NSString *type;

@property (nonatomic, assign) NSInteger hasGrade;

@property (nonnull, nonatomic, copy) NSString *updateName;

@property (nonatomic, assign) NSInteger date;

@property (nonatomic, assign) long createTime;

@property (nonnull, nonatomic, copy) NSString *headUrl;

@property (nonnull, nonatomic, copy) NSString *createName;

@property (nonnull, nonatomic, copy) NSString *coachUserId;

@property (nonatomic, assign) NSInteger placeId;

@property (nonatomic, assign) NSInteger theDate;

- (_Nonnull instancetype)initWithFTTraineeBeanDic:(NSDictionary * _Nonnull)infoDic;

@end

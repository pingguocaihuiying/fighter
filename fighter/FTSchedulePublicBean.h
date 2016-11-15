/*!
 *	producted by oc_json_plugin.py
 *	auth: w6
*/
#import <Foundation/Foundation.h>



/**
 团课 课程表课程
 */
@interface FTSchedulePublicBean : NSObject

@property (nonatomic, assign) NSInteger myIsOrd; // 当前用户是否预约该课程

@property (nonnull, nonatomic, copy) NSString *timeSection; //时间段

@property (nonatomic, assign) NSInteger courseId; // 课程id

@property (nonatomic, assign) NSInteger topLimit; //课程最大允许人数

@property (nonnull, nonatomic, copy) NSString *coachUserId; //教练用户编号 DD7F3F52C06BD63820C05F49094BD26E
@property (nonatomic, assign) NSInteger theDate; // 周几

@property (nonnull, nonatomic, copy) NSString *label; // 标签

@property (nonnull, nonatomic, copy) NSString *courseName; //课程名

@property (nonatomic, assign) NSInteger timeId; // 时间段id

@property (nonnull, nonatomic, copy) NSString *coach; //教练名

@property (nonnull, nonatomic, copy) NSString *nonGradeNumber; //未评人数，若为0表示全部已评价

@property (nonatomic, assign) NSInteger hasOrderCount; //已经报名人数

@property (nonnull, nonatomic, copy) NSString *type; //课程类型，0-团课，2-私课

@property (nonatomic, assign) NSInteger id;

@property (nonnull, nonatomic, copy) NSString *subject;

@property (nonatomic, assign) NSInteger timestamp; // 日期时间戳

@property (nonnull, nonatomic, copy) NSString *dateString; // 格式化后的日期

- (_Nonnull instancetype)initWithFTSchedulePublicBeanDic:(NSDictionary * _Nonnull)infoDic;

@end

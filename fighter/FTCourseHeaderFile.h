//
//  FTCourseHeaderFile.h
//  fighter
//
//  Created by kang on 2016/11/14.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#ifndef FTCourseHeaderFile_h
#define FTCourseHeaderFile_h

typedef NS_ENUM(NSInteger, FTCourseState) {
    
    FTCourseStateDone,//历史课程
    FTCourseStateWaiting,//计划课程
    FTCourseStateTeaching,//进行中课程
};

typedef NS_ENUM(NSInteger, FTCourseType) {
    FTCourseTypePublic, //团课
    FTCourseTypePrivate //私课
};

typedef BOOL(^EditSkillBlock)(NSString *key, NSString *value);
typedef void(^TransmitParamsBlock)(NSMutableDictionary *dic);



#endif /* FTCourseHeaderFile_h */

//
//  NSDate+Tool.h
//  fighter
//
//  Created by kang on 2016/9/23.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Tool)


/**
 生成日期时间字符串，用下划线间隔日期和时间

 @return 日期字符串
 */
+ (NSString *) dateTimeStringWithUnderlineSpace;


/**
  生成日期时间字符串，用空格间隔日期和时间

 @return 日期字符串
 */
+ (NSString *) dateTimeStringWithBlankSpace;


/**
 根据时间戳生成相对应格式的日期字符串
 
 @param timestamp 时间戳
 
 @return 日期字符串
 */
+(NSString *) dateString:(NSInteger) timestamp;


/**
 根据时间戳生成指定格式的日期字符串
 
 @param timestamp 时间戳字符串
 @param formatter  指定的日期格式
 
 @return 指定格式的日期字符串
 */
+ (NSString *) formatTimestamp:(NSString *)timestamp formatter:(NSString *)formatter ;


/**
 将时间戳字符串 转换成NSDate对象
 
 @param timestamp 日期时间戳字符串
 
 @return NSDate对象
 */
+ (NSDate *) dateWithTimestamp:(NSString *)timestamp ;

/**
 根日期NSDate对象 生成制定格式的日期字符串比如“2016-9-23”
 
 @param date      日期对象
 @param formatter 日期字符串格式
 
 @return 返回制定格式的字符串
 */
+ (NSString *) stringOfDate:(NSDate *)date formatter:(NSString *)formatter;

@end

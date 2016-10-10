//
//  NSDate+Tool.m
//  fighter
//
//  Created by kang on 2016/9/23.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "NSDate+Tool.h"

@implementation NSDate (Tool)

/**
 生成日期时间字符串，用下划线间隔日期和时间
 
 @return 日期字符串
 */
+ (NSString *) dateTimeStringWithUnderlineSpace
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd_HH:mm:ss"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}


/**
 生成日期时间字符串，用空格间隔日期和时间
 
 @return 日期字符串
 */
+ (NSString *) dateTimeStringWithBlankSpace
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}


/**
 根据时间戳生成相对应格式的日期字符串
 
 @param timestamp 时间戳
 
 @return 日期字符串
 */
+(NSString *) dateString:(NSInteger) timestamp  {
    
    NSString *timeTemp = [NSString stringWithFormat:@"%ld",(long)timestamp];
    NSDate *currentDate = [NSDate date];
    NSDate *targetDate = [self dateWithTimestamp:timeTemp];
    
    
    NSInteger dateNum = [[self stringOfDate:currentDate formatter:@"YYYYMMdd"] integerValue];
    NSInteger dateNum2  = [[self stringOfDate:targetDate formatter:@"YYYYMMdd"] integerValue];
    
    NSString *dateTimeString;
    if ((dateNum - dateNum2) > 2) {
        
        dateTimeString = [self formatTimestamp:timeTemp formatter:@"YYYY-MM-dd HH:mm"];
        
    }else if ((dateNum - dateNum2) == 1) {
        
        NSString *tempString = [self formatTimestamp:timeTemp formatter:@"HH:mm"];
        dateTimeString = [NSString stringWithFormat:@"昨天 %@",tempString];
        
    }else {
        
        dateTimeString = [self formatTimestamp:timeTemp formatter:@"HH:mm"];
        
    }
    
    return dateTimeString;
}

#pragma mark -
/**
 根据时间戳生成指定格式的日期字符串
 
 @param timestamp 时间戳字符串
 @param formatter  指定的日期格式
 
 @return 指定格式的日期字符串
 */
+ (NSString *) formatTimestamp:(NSString *)timestamp formatter:(NSString *)formatter {
    
    NSDate *date ;
    if (timestamp.length == 10) {
        date = [NSDate dateWithTimeIntervalSince1970:[timestamp floatValue]];
        
    }else if (timestamp.length == 13) {
        date = [NSDate dateWithTimeIntervalSince1970:[timestamp floatValue]/1000];
        
    }
    
    return [self  stringOfDate:date formatter:formatter];
}



/**
 将时间戳字符串 转换成NSDate对象
 
 @param timestamp 日期时间戳字符串
 
 @return NSDate对象
 */

+ (NSDate *) dateWithTimestamp:(NSString *)timestamp {
    
    NSDate *date ;
    if (timestamp.length == 10) {
        date = [NSDate dateWithTimeIntervalSince1970:[timestamp floatValue]];
        
    }else if (timestamp.length == 13) {
        date = [NSDate dateWithTimeIntervalSince1970:[timestamp floatValue]/1000];
        
    }
    
    return date;
}


/**
 根日期NSDate对象 生成制定格式的日期字符串比如“2016-9-23”
 
 @param date      日期对象
 @param formatter 日期字符串格式
 
 @return 返回制定格式的字符串
 */
+ (NSString *) stringOfDate:(NSDate *)date formatter:(NSString *)formatter {
    
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:formatter];
    
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}


/**
 将下划线间隔日期字符串修改为年月日间隔的日期字符串

 @param dateString 下划线间隔日期字符串

 @return 年月日间隔字符串
 */
+ (NSString *) changeUnderlineDateToWordDate:(NSString *) dateString {
    
    if (dateString.length >=10) {
        NSString *year = [dateString substringToIndex:4];
        NSString *month= [dateString substringWithRange:NSMakeRange(5, 2)];
        NSString *day = [dateString substringWithRange:NSMakeRange(8, 2)];
        
        return [NSString stringWithFormat:@"%@年%@月%@日",year,month,day];
    }
    
    
    return @"";
    
}


#pragma mark -
+ (NSString *) currentYearString {
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *year = [dateFormatter stringFromDate:date];
    
    return year;
}

+ (NSString *) yearString:(NSInteger)timestamp {
    
    NSDate *date;
    if (timestamp > 9999999999) {
        date = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    }else {
        date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    }
   
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *year = [dateFormatter stringFromDate:date];
    
    return year;
}


+ (NSString *) currentMonthString {

    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"MM"];
    NSString *month = [dateFormatter stringFromDate:date];
    
    return month;
}

+ (NSString *) monthString:(NSInteger) timestamp {
    
    NSDate *date;
    if (timestamp > 9999999999) {
        date = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    }else {
        date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"MM"];
    NSString *month = [dateFormatter stringFromDate:date];
    
    return month;
}


+ (NSString *) currentDayString {

    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"dd"];
    NSString *day = [dateFormatter stringFromDate:date];
    
    return day;
}


+ (NSString *) dayString:(NSInteger) timestamp {
    
    NSDate *date;
    if (timestamp > 9999999999) {
        date = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    }else {
        date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"dd"];
    NSString *day = [dateFormatter stringFromDate:date];
    
    return day;
}


#pragma mark -
+ (NSString *) currentYearMonthString {
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSString *day = [dateFormatter stringFromDate:date];
    
    return day;
}


+ (NSString *)yearMonthString:(NSInteger) timestamp {
    
    NSDate *date;
    if (timestamp > 9999999999) {
        date = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    }else {
        date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSString *day = [dateFormatter stringFromDate:date];
    
    return day;
}

#pragma mark - 


/**
 根据时间戳生成日期字符创，格式：2016年10月10日
 
 @param timestamp 时间戳
 
 @return 日期字符串
 */
+ (NSString *) dateStringWithWordSpace:(NSInteger) timestamp {
    
    NSDate *date;
    if (timestamp > 9999999999) {
        date = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    }else {
        date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}



/**
 根据时间戳生成日期字符创，格式：10月10日

 @param timestamp 时间戳

 @return 日期字符串
 */
+ (NSString *) monthDayStringWithWordSpace:(NSInteger) timestamp {
    
    NSDate *date;
    if (timestamp > 9999999999) {
        date = [NSDate dateWithTimeIntervalSince1970:timestamp/1000.0];
    }else {
        date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"MM月dd日"];
    NSString *monthDay = [dateFormatter stringFromDate:date];
    
    return monthDay;
}

@end

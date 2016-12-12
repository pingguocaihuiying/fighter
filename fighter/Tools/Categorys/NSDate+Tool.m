//
//  NSDate+Tool.m
//  fighter
//
//  Created by kang on 2016/9/23.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "NSDate+Tool.h"

@implementation NSDate (Tool)

#pragma mark  - date time string from current date
/**
 生成日期时间字符串，用下划线间隔日期和时间
 
 @return 日期字符串 精确到秒
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
 生成日期时间字符串，用下划线间隔日期和时间
 
 @return 日期字符串 精确到毫秒
 */
+ (NSString *) dateTimeStringAccurateToMillisecondWithUnderlineSpace
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd_HH:mm:ss:SSS"];
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


#pragma mark -

/**
 将时间戳字符串 转换成NSDate对象
 
 @param timestamp 日期时间戳字符串
 
 @return NSDate对象
 */

+ (NSDate *) dateWithTimestamp:(NSString *) timestamp {
    
    NSDate *date ;
    if (timestamp.length == 13) {
        date = [NSDate dateWithTimeIntervalSince1970:[timestamp longLongValue]/1000];
    }else if (timestamp.length == 10)  {
        date = [NSDate dateWithTimeIntervalSince1970:[timestamp longLongValue] ];
    }
    
    return date;
}


/**
 根据时间戳生成指定格式的日期字符串
 
 @param timestamp 时间戳字符串
 @param formatter  指定的日期格式
 
 @return 指定格式的日期字符串
 */
+ (NSString *) formatTimestamp:(NSString *) timestamp formatter:(NSString *)formatter {
    
    NSDate *date = [self dateWithTimestamp:timestamp];
    
    return [self  stringOfDate:date formatter:formatter];
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

+ (NSString *) currentYearMonthString2 {
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy年MM月"];
    NSString *yearMonth = [dateFormatter stringFromDate:date];
    
    return yearMonth;
}

+ (NSString *) yearString:(NSString *)timestamp {
    
    NSDate *date = [self dateWithTimestamp:timestamp];
    
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

+ (NSString *) monthString:(NSString *) timestamp {
    
    NSDate *date = [self dateWithTimestamp:timestamp];
    
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


+ (NSString *) dayString:(NSString *) timestamp {
    
   NSDate *date = [self dateWithTimestamp:timestamp];
    
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


+ (NSString *)yearMonthString:(NSString *) timestamp {
    
    NSDate *date = [self dateWithTimestamp:timestamp];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSString *day = [dateFormatter stringFromDate:date];
    
    return day;
}

#pragma mark - date string from timestamp


/**
 根据时间戳生成日期字符串，格式：2016年10月10日
 
 @param timestamp 时间戳
 
 @return 日期字符串
 */
+ (NSString *) dateStringWithWordSpace:(NSString *) timestamp {
    
    NSDate *date = [self dateWithTimestamp:timestamp];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}
+ (NSString *) dateStringWithYearMonth:(NSString *) timestamp {
    
    NSDate *date = [self dateWithTimestamp:timestamp];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy年MM月"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}

/**
 根据时间戳生成日期字符串，格式：2016_10_10
 
 @param timestamp 时间戳
 
 @return 日期字符串
 */
+ (NSString *) dateStringWithUnderLineSpace:(NSString *) timestamp {
    
    NSDate *date = [self dateWithTimestamp:timestamp];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy_MM_dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}


#pragma mark - month day string from timestamp

/**
 根据时间戳生成日期字符创，格式：10月10日

 @param timestamp 时间戳

 @return 日期字符串
 */
+ (NSString *) monthDayStringWithWordSpace:(NSString *) timestamp {
    
    NSDate *date = [self dateWithTimestamp:timestamp];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"MM月dd日"];
    NSString *monthDay = [dateFormatter stringFromDate:date];
    
    return monthDay;
}

#pragma mark - time string from timestamp
/**
 根据时间戳生成日期字符串，格式：15:30
 
 @param timestamp 时间戳
 
 @return 日期字符串
 */
+ (NSString *) timeStringWithHM:(NSString *) timestamp {
    
    NSDate *date = [self dateWithTimestamp:timestamp];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *timeString = [dateFormatter stringFromDate:date];
    
    return timeString;
}

/**
 根据时间戳生成日期字符串，格式：15:30:58
 
 @param timestamp 时间戳
 
 @return 日期字符串
 */
+ (NSString *) timeStringWithHMS:(NSString *) timestamp {
    
    NSDate *date = [self dateWithTimestamp:timestamp];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *timeString = [dateFormatter stringFromDate:date];
    
    return timeString;
}

#pragma mark - 根据时间戳生成相应的字符串

/**
 根据时间戳生成相对应格式的日期字符串
 
 @param timestamp 时间戳
 
 @return 日期字符串
 */
+(NSString *) dateString:(NSString *) timestamp  {
    
    NSDate *currentDate = [NSDate date];
    NSDate *targetDate = [self dateWithTimestamp:timestamp];
    
    long long  dateNum = [[self stringOfDate:currentDate formatter:@"YYYYMMdd"] longLongValue];
    long long dateNum2  = [[self stringOfDate:targetDate formatter:@"YYYYMMdd"] longLongValue];
    
    NSLog(@"dateNUm2:%lld",dateNum2);
    NSLog(@"currentDate:%@",[self stringOfDate:currentDate formatter:@"YYYY-MM-dd HH:mm:ss"] );
    NSLog(@"targetDate:%@",[self stringOfDate:targetDate formatter:@"YYYY-MM-dd HH:mm:ss"] );
    
    NSString *dateTimeString;
    if ((dateNum - dateNum2) >= 2) {
        
        dateTimeString = [self formatTimestamp:timestamp formatter:@"YYYY-MM-dd"];
        
    }else if ((dateNum - dateNum2) == 1) {
        
        NSString *tempString = [self formatTimestamp:timestamp formatter:@"HH:mm"];
        dateTimeString = [NSString stringWithFormat:@"昨天 %@",tempString];
        
    }else {
        
        NSInteger interval = [currentDate timeIntervalSince1970] - [timestamp longLongValue]/1000;
        
//        NSInteger timeNum = [[self stringOfDate:currentDate formatter:@"HHmm"] integerValue];
//        NSInteger stampNum  = [[self stringOfDate:targetDate formatter:@"HHmm"] integerValue];
        
        if (interval < 60) {
            dateTimeString = @"刚刚";
        }else if (interval < 60 *60) {
            dateTimeString = [NSString stringWithFormat:@"%d分钟前",interval/60];
        }else {
            dateTimeString = [NSString stringWithFormat:@"%d小时前",interval/60/60];
        }
        
//        if (timeNum == stampNum) {
//            dateTimeString = [self formatTimestamp:timestamp formatter:@"刚刚"];
//        }else if (timeNum - stampNum < 60) {
//            dateTimeString = [NSString stringWithFormat:@"%ld分钟前",timeNum - stampNum];
//        }else {
//            dateTimeString = [NSString stringWithFormat:@"%ld小时前",(timeNum - stampNum)/60];
//        }
        //        dateTimeString = [self formatTimestamp:timestamp formatter:@"HH:mm"];
        
    }
    
    return dateTimeString;
}


#pragma mark -

/**
 根据时间戳返回正确的时间字符串格式
 如果是该年的日期择返回 月日格式
 如果不是该年则返回年月日格式

 @param timestamp 时间戳
 @return
 */
+ (NSString *) recordDateString:(NSTimeInterval) timestamp {

    NSString *currentYearMonthString = [self currentYearString];
    
    NSString *date = [NSString stringWithFormat:@"%.0f",timestamp];
    
    NSString *yearString = [NSDate yearString:date];
    
    if ([yearString isEqualToString:currentYearMonthString]) {
        return  [NSDate monthDayStringWithWordSpace:date];
    }else {
        return [NSDate dateStringWithWordSpace:date];
    }
}

@end

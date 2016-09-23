//
//  NSDate+TaskDate.m
//  fighter
//
//  Created by kang on 16/8/23.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "NSDate+TaskDate.h"

@implementation NSDate (TaskDate)

+(NSDate *) taskDate {

    //获取系统当前时间
    NSDate *currentDate = [NSDate date];
    
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
    
    
    NSString *dateString = [NSString stringWithFormat:@"%@ 6:10:00",currentDateString];
    
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSString转NSDate
    NSDate *date = [formatter dateFromString:dateString];
    
    return date;
}



@end

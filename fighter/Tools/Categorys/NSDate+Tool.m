//
//  NSDate+Tool.m
//  fighter
//
//  Created by kang on 2016/9/23.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "NSDate+Tool.h"

@implementation NSDate (Tool)


+(NSString *) dateString:(NSInteger) timestamp  {
    
    NSString *timeTemp = [NSString stringWithFormat:@"%ld",timestamp];
    NSDate *currentDate = [NSDate date];
    NSDate *targetDate = [self dateWithTimestamp:timeTemp];
    
    
    NSInteger dateNum = [[self stringOfDate:currentDate formatter:@"YYYYMMdd"] integerValue];
    NSInteger dateNum2  = [[self stringOfDate:targetDate formatter:@"YYYYMMdd"] integerValue];
    
    NSString *dateTimeString;
    if ((dateNum - dateNum2) > 2) {
        
        dateTimeString = [self formatTimestamp:timeTemp formatter:@"YYYY-MM-dd HH:mm:ss"];
        
    }else if ((dateNum - dateNum2) == 1) {
        
        NSString *tempString = [self formatTimestamp:timeTemp formatter:@"HH:mm"];
        dateTimeString = [NSString stringWithFormat:@"昨天 %@",tempString];
        
    }else {
        
        dateTimeString = [self formatTimestamp:timeTemp formatter:@"HH:mm"];
        
    }
    
    return dateTimeString;
}


+ (NSString *) formatTimestamp:(NSString *)timestamp formatter:(NSString *)formatter {
    
    NSDate *date ;
    if (timestamp.length == 10) {
        date = [NSDate dateWithTimeIntervalSince1970:[timestamp floatValue]];
        
    }else if (timestamp.length == 13) {
        date = [NSDate dateWithTimeIntervalSince1970:[timestamp floatValue]/1000];
        
    }
    
    return [self  stringOfDate:date formatter:formatter];
}


+ (NSDate *) dateWithTimestamp:(NSString *)timestamp {
    
    NSDate *date ;
    if (timestamp.length == 10) {
        date = [NSDate dateWithTimeIntervalSince1970:[timestamp floatValue]];
        
    }else if (timestamp.length == 13) {
        date = [NSDate dateWithTimeIntervalSince1970:[timestamp floatValue]/1000];
        
    }
    
    return date;
}


+ (NSString *) stringOfDate:(NSDate *)date formatter:(NSString *)formatter {
    
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:formatter];
    
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}


@end

//
//  FTTools.h
//  fighter
//
//  Created by Liyz on 5/19/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTTools : NSObject

+ (NSString *)getChLabelNameWithEnLabelName:(NSString *)labelNameEn;
+ (void)showHUDWithMessage:(NSString *)message andView:(UIView *)view;
+ (NSString *)fixStringForDate:(NSString *)timestampString;//日期转换 “年月日时间”
+ (NSString *)fixStringForDateWithoutTime:(NSString *)timestampString;//“年月日“
+ (BOOL)isNumText:(NSString *)str;//判断字符串是否是数字
+ (int)getOneDay:(int)day;
+ (int)getDaysInMonth:(int)year month:(int)imonth;// 获取某年某月总共多少天
//获取今天是周几
+ (NSInteger )getWeekdayOfToday;//返回1234567

/**
 *  根据“某天”的任意时间戳和“时间段”，确定实际时间
 *
 *  @param timestamp   时间戳
 *  @param timeSection 时间段，eg：“10：00〜11：00”
 *
 *  @return 时间字符串 格式如：“2016－06－20 17：00“
 */
+ (NSString *)getDateStringWith:(NSTimeInterval)timestamp andTimeSection:(NSString *)timeSection;//
@end

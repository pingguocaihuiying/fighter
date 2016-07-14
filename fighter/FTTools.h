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
@end

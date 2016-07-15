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

/**
 *  根据支持设施的英文标识，返回对应的图片名字
 *
 *  @param itemNameEn 对应标志，eg：“sup_bathe”
 *
 *  @return 对应的图片名字 eg：“拳馆功能ico-安保”
 */
+ (NSString *)getGymSupportItemImageNameWithItemNameEn:(NSString *)itemNameEn;

/**
 *  根据支持设施的英文标识，返回对应的中文名字
 *
 *  @param itemNameEn 对应标志，eg：“sup_bathe”
 *
 *  @return 对应的中文名字 eg：“安保”
 */
+ (NSString *)getGymSupportItemNameWithItemNameEn:(NSString *)itemNameEn;

/**
 *  将英文标签转换为中文标签
 *
 *  @param labelNameEn 英文标签
 *
 *  @return 中文标签
 */
+ (NSString *)getNameCHWithEnLabelName:(NSString *)labelNameEn;
@end

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

/**
 *
 *
 *  @param timestampString 时间戳
 *
 *  @return 返回时间，格式：“yyyy.MM.dd HH:mm”
 */
+ (NSString *)fixStringForDate:(NSString *)timestampString;//日期转换 “年月日时间”

/**
 *  根据时间戳返回日期
 *
 *  @param timestampString 时间戳
 *
 *  @return 返回时间，格式："yyyy.MM.dd"
 */
+ (NSString *)fixStringForDateWithoutTime:(NSString *)timestampString;//“年月日“


/**
 获取当前月份

 @return 月份，eg：1、2、3
 */
+ (NSString *)getCurrentMonth;//获取当前月份

/**
 *  根据时间戳返回日期
 *
 *  @param timestamp 时间戳
 *
 *  @return 返回时间，格式："yyyy-MM-dd"
 */
+ (NSString *)getDateStringWith:(NSTimeInterval)timestamp;


+ (BOOL)isNumText:(NSString *)str;//判断字符串是否是数字
+ (int)getOneDay:(int)day;
+ (int)getDaysInMonth:(int)year month:(int)imonth;// 获取某年某月总共多少天
//获取今天是周几
+ (NSInteger )getWeekdayOfToday;//返回1234567

/**
 获取某天后是周几

 @param offsetDay 今天后的第几天今天 offset为0，明天offset为1

 @return 周几：1、2、3、4、5、6、7
 */
+ (NSInteger )getWeekdayOfTodayAfterToday:(NSInteger)offsetDay;
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

/**
 *  将str追加至可变数组，如果这个str已经存在，则不追加
 *
 *  @param str          传入的字符串
 *  @param mutableArray 可变数组
 */
+ (void)saveDateStr:(NSString *)str ToMutableArray:(NSMutableArray *)mutableArray;

/**
 *  根据某天的任一时间戳，和类似“9：00”的时间点返回一个准确的时间戳
 *
 *  @param anyTimeIntervalOfDay 某天任一时间戳
 *  @param timeString           类似“9：00”的时间段
 *
 *  @return 由两个参数确定的准确时间戳
 */
+(NSTimeInterval)getTimeIntervalWithAnyTimeIntervalOfDay:(NSTimeInterval)anyTimeIntervalOfDay andTimeString:(NSString *)timeString;

//加密方法
+(NSString *)md5Dictionary:(NSDictionary *)dic withCheckKey:(NSString *)checkKey;

//登录方法
+ (void)loginwithVC:(UIViewController *) vc;

//检查是否登录，没有登录就跳转到登录界面，并返回假
+(BOOL)hasLoginWithViewController:(UIViewController *) vc;

#pragma -mark 更新评分view
+ (void)updateScoreView:(UIView *)scoreView withScore:(float)scoreFloat;

@end

//
//  FTTools.m
//  fighter
//
//  Created by Liyz on 5/19/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTTools.h"
#import "FTNWGetCategory.h"
#import "MBProgressHUD.h"
#import "FTBaseNavigationViewController.h"
#import "FTLoginViewController.h"

@implementation FTTools


+ (NSString *)getNameCHWithEnLabelName:(NSString *)labelNameEn{
    NSString *labelNameCh = @"";
    if ([labelNameEn isEqualToString:@"Boxing"]) {
        labelNameCh = @"拳击";
    }else if ([labelNameEn isEqualToString:@"MMA"]) {
        labelNameCh = @"综合格斗(MMA)";
    }else if ([labelNameEn isEqualToString:@"ThaiBoxing"]) {
        labelNameCh = @"泰拳";
    }else if ([labelNameEn isEqualToString:@"Taekwondo"]) {
        labelNameCh = @"跆拳道";
    }else if ([labelNameEn isEqualToString:@"Judo"]) {
        labelNameCh = @"柔道";
    }else if ([labelNameEn isEqualToString:@"Wrestling"]) {
        labelNameCh = @"摔跤";
    }else if ([labelNameEn isEqualToString:@"Sumo"]) {
        labelNameCh = @"相扑";
    }else if ([labelNameEn isEqualToString:@"FemaleWrestling"]) {
        labelNameCh = @"女子格斗";
    }else if([labelNameEn isEqualToString:@"StreetFight"]){
        labelNameCh = @"街斗";
    }else if([labelNameEn isEqualToString:@"Others"]){
        labelNameCh = @"其他";
    }else if([labelNameEn isEqualToString:@"Train"]){
        labelNameCh = @"训练";
    }else if([labelNameEn isEqualToString:@"Match"]){
        labelNameCh = @"比赛";
    }else if([labelNameEn isEqualToString:@"News"]){
        labelNameCh = @"新闻";
    }

    
    return labelNameCh;
}

+ (NSString *)getChLabelNameWithEnLabelName:(NSString *)labelNameEn{
    NSString *labelNameCh = @"";
    if ([labelNameEn isEqualToString:@"Boxing"]) {
        labelNameCh = @"格斗标签-拳击";
    }else if ([labelNameEn isEqualToString:@"MMA"]) {
        labelNameCh = @"格斗标签-综合格斗";
    }else if ([labelNameEn isEqualToString:@"ThaiBoxing"]) {
        labelNameCh = @"格斗标签-泰拳";
    }else if ([labelNameEn isEqualToString:@"Taekwondo"]) {
        labelNameCh = @"格斗标签-跆拳道";
    }else if ([labelNameEn isEqualToString:@"Judo"]) {
        labelNameCh = @"格斗标签-柔道";
    }else if ([labelNameEn isEqualToString:@"Wrestling"]) {
        labelNameCh = @"格斗标签-摔跤";
    }else if ([labelNameEn isEqualToString:@"Sumo"]) {
        labelNameCh = @"格斗标签-相扑";
    }else if ([labelNameEn isEqualToString:@"FemaleWrestling"]) {
        labelNameCh = @"格斗标签-女子格斗";
    }else if([labelNameEn isEqualToString:@"StreetFight"]){
        labelNameCh = @"格斗标签-街斗";
    }else if([labelNameEn isEqualToString:@"Others"]){
        labelNameCh = @"格斗标签-其他";
    }else if([labelNameEn isEqualToString:@"Train"]){
        labelNameCh = @"格斗标签-训练";
    }else if([labelNameEn isEqualToString:@"Match"]){
        labelNameCh = @"格斗标签-比赛";
    }else if([labelNameEn isEqualToString:@"News"]){
        labelNameCh = @"格斗标签-新闻";
    }
    
    return labelNameCh;
}


+ (NSString *)getChNameWithEnLabelName:(NSString *)labelNameEn{
    NSString *labelNameCh = @"";
    if ([labelNameEn isEqualToString:@"Boxing"]) {
        labelNameCh = @"拳击";
    }else if ([labelNameEn isEqualToString:@"MMA"]) {
        labelNameCh = @"综合格斗";
    }else if ([labelNameEn isEqualToString:@"ThaiBoxing"]) {
        labelNameCh = @"泰拳";
    }else if ([labelNameEn isEqualToString:@"Taekwondo"]) {
        labelNameCh = @"跆拳道";
    }else if ([labelNameEn isEqualToString:@"Judo"]) {
        labelNameCh = @"柔道";
    }else if ([labelNameEn isEqualToString:@"Wrestling"]) {
        labelNameCh = @"摔跤";
    }else if ([labelNameEn isEqualToString:@"Sumo"]) {
        labelNameCh = @"相扑";
    }else if ([labelNameEn isEqualToString:@"FemaleWrestling"]) {
        labelNameCh = @"女子格斗";
    }else if([labelNameEn isEqualToString:@"StreetFight"]){
        labelNameCh = @"街斗";
    }else if([labelNameEn isEqualToString:@"Others"]){
        labelNameCh = @"其他";
    }else if([labelNameEn isEqualToString:@"Train"]){
        labelNameCh = @"训练";
    }else if([labelNameEn isEqualToString:@"Match"]){
        labelNameCh = @"比赛";
    }else if([labelNameEn isEqualToString:@"News"]){
        labelNameCh = @"新闻";
    }else{
        labelNameCh = labelNameEn;//如果没找到匹配的，原样返回
    }
    
    return labelNameCh;
}

+ (NSString *)fixStringForDate:(NSString *)timestampString{
    timestampString = [timestampString substringToIndex:timestampString.length - 3];
    NSTimeInterval timeInterval = [timestampString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:kCFDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm"];
    NSString *fixString = [dateFormatter stringFromDate:date];
    return fixString;
}

+ (NSString *)fixStringForDateWithoutTime:(NSString *)timestampString{
    timestampString = [timestampString substringToIndex:timestampString.length - 3];
    NSTimeInterval timeInterval = [timestampString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:kCFDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    NSString *fixString = [dateFormatter stringFromDate:date];
    return fixString;
}
+ (NSString *)fixStringForDateWithoutTime2:(NSString *)timestampString{
    timestampString = [NSString stringWithFormat:@"%@", timestampString];
    timestampString = [timestampString substringToIndex:timestampString.length - 3];
    NSTimeInterval timeInterval = [timestampString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:kCFDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *fixString = [dateFormatter stringFromDate:date];
    return fixString;
}
+ (BOOL)isNumText:(NSString *)str{
    
    NSCharacterSet*cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString*filtered = [[str componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [str isEqualToString:filtered];
    if(!basicTest) {
        
        return NO;
        
    }
    return YES;
    
}


//+ (void)showHUDWithMessage:(NSString *)message andView:(UIView *)view{
//    
//    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
//    [view addSubview:HUD];
//    HUD.label.text = message;
//    HUD.mode = MBProgressHUDModeCustomView;
//    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
//    [HUD showAnimated:YES];
//    sleep(1.5);
//        [HUD removeFromSuperview];
//    
//}

/**
 *  获取几年几月几日后的日期，0表示当天，负数表示之前
 *  这里只要取到日就好了，年月置0，表示当年当月
 */
+ (int)getOneDay:(int)day {
    int year = 0, month = 0;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:year];
    [adcomps setMonth:month];
    [adcomps setDay:day];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
    
    NSDateFormatter  *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd"];
    NSString *  dayString = [formatter stringFromDate:newdate];
    return [dayString intValue];
}

// 获取某年某月总共多少天
+ (int)getDaysInMonth:(int)year month:(int)imonth {
    // imonth == 0的情况是应对在CourseViewController里month-1的情况
    if((imonth == 0)||(imonth == 1)||(imonth == 3)||(imonth == 5)||(imonth == 7)||(imonth == 8)||(imonth == 10)||(imonth == 12))
        return 31;
    if((imonth == 4)||(imonth == 6)||(imonth == 9)||(imonth == 11))
        return 30;
    if((year%4 == 1)||(year%4 == 2)||(year%4 == 3))
    {
        return 28;
    }
    if(year%400 == 0)
        return 29;
    if(year%100 == 0)
        return 28;
    return 29;
}

//获取今天是周几
+ (NSInteger )getWeekdayOfToday{
    NSInteger weekday;
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyy"];
    NSString *  yearString = [dateformatter stringFromDate:senddate];
    [dateformatter setDateFormat:@"MM"];
    NSString *  monthString = [dateformatter stringFromDate:senddate];
    [dateformatter setDateFormat:@"dd"];
    NSString *  dayString = [dateformatter stringFromDate:senddate];
    [dateformatter setDateFormat:@"EEE"];
    
    NSString *  weekString = [dateformatter stringFromDate:senddate];
//    NSLog(@"-%@",weekString);
    int year = [yearString intValue];
//    NSLog(@"-%d", year);
    int month = [monthString intValue];
//    NSLog(@"--%d", month);
    int day = [dayString intValue];
//    NSLog(@"---%d", day);
    
    // 判断当前天是周几，从而计算出当周的周一是几号（负数表示上个月月末）
    if ([weekString  isEqual: @"周一"] || [weekString  isEqual: @"Mon"]) {
        weekday = 1;
    } else if ([weekString isEqual:@"周二"] || [weekString  isEqual: @"Tue"]) {
        weekday = 2;
    } else if ([weekString isEqual:@"周三"] || [weekString  isEqual: @"Wed"]) {
        weekday = 3;
    } else if ([weekString isEqual:@"周四"] || [weekString  isEqual: @"Thu"]) {
        weekday = 4;
    } else if ([weekString isEqual:@"周五"] || [weekString  isEqual: @"Fri"]) {
        weekday = 5;
    } else if ([weekString isEqual:@"周六"] || [weekString  isEqual: @"Sat"]) {
        weekday = 6;
    } else if ([weekString isEqual:@"周日"] || [weekString  isEqual: @"Sun"]) {
        weekday = 7;
    }
    return weekday;
}


+ (NSInteger )getWeekdayOfTodayAfterToday:(NSInteger)offsetDay{
    NSInteger weekday;
    NSDate *  senddate= [NSDate dateWithTimeIntervalSinceNow:24 * 60 * 60 * offsetDay];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyy"];
    NSString *  yearString = [dateformatter stringFromDate:senddate];
    [dateformatter setDateFormat:@"MM"];
    NSString *  monthString = [dateformatter stringFromDate:senddate];
    [dateformatter setDateFormat:@"dd"];
    NSString *  dayString = [dateformatter stringFromDate:senddate];
    [dateformatter setDateFormat:@"EEE"];
    
    NSString *  weekString = [dateformatter stringFromDate:senddate];
    //    NSLog(@"-%@",weekString);
    int year = [yearString intValue];
    //    NSLog(@"-%d", year);
    int month = [monthString intValue];
    //    NSLog(@"--%d", month);
    int day = [dayString intValue];
    //    NSLog(@"---%d", day);
    
    // 判断当前天是周几，从而计算出当周的周一是几号（负数表示上个月月末）
    if ([weekString  isEqual: @"周一"] || [weekString  isEqual: @"Mon"]) {
        weekday = 1;
    } else if ([weekString isEqual:@"周二"] || [weekString  isEqual: @"Tue"]) {
        weekday = 2;
    } else if ([weekString isEqual:@"周三"] || [weekString  isEqual: @"Wed"]) {
        weekday = 3;
    } else if ([weekString isEqual:@"周四"] || [weekString  isEqual: @"Thu"]) {
        weekday = 4;
    } else if ([weekString isEqual:@"周五"] || [weekString  isEqual: @"Fri"]) {
        weekday = 5;
    } else if ([weekString isEqual:@"周六"] || [weekString  isEqual: @"Sat"]) {
        weekday = 6;
    } else if ([weekString isEqual:@"周日"] || [weekString  isEqual: @"Sun"]) {
        weekday = 7;
    }
    return weekday;
}

+ (NSString *)getDateStringWith:(NSTimeInterval)timestamp andTimeSection:(NSString *)timeSection{
    NSString *dateString = @"";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:kCFDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *fixString = [dateFormatter stringFromDate:date];
    [dateFormatter dateFromString:@""];
    
    NSArray *timeSectionArray = [timeSection componentsSeparatedByString:@"~"];
    NSString *startTimeString = [timeSectionArray firstObject];
    
    dateString = [NSString stringWithFormat:@"%@ %@", fixString, startTimeString];
    
    return dateString;
}

+(NSTimeInterval)getTimeIntervalWithAnyTimeIntervalOfDay:(NSTimeInterval)anyTimeIntervalOfDay andTimeString:(NSString *)timeString{
    NSString *dayString = [FTTools getDateStringWith:anyTimeIntervalOfDay];//"yyyy-MM-dd"
    dayString = [NSString stringWithFormat: @"%@ %@", dayString, timeString];
    
    //创建一个时间格式化的工具
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:kCFDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [dateFormatter dateFromString:dayString];
    NSTimeInterval result = [date timeIntervalSince1970];
    return result;
}

+ (NSString *)getDateStringWith:(NSTimeInterval)timestamp{
    NSString *dateString = @"";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:kCFDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *fixString = [dateFormatter stringFromDate:date];
    
    return fixString;
}

+ (NSString *)getGymSupportItemImageNameWithItemNameEn:(NSString *)itemNameEn{
    NSString *imageName = @"";
    if ([itemNameEn isEqualToString:@"sup_bathe"]) {
        imageName = @"拳馆功能ico-洗澡";
    } else if([itemNameEn isEqualToString:@"sup_prop"]) {
        imageName = @"拳馆功能ico-器械";
    }else if([itemNameEn isEqualToString:@"sup_security"]) {
        imageName = @"拳馆功能ico-安保";
    }else if([itemNameEn isEqualToString:@"sup_shoot"]) {
        imageName = @"拳馆功能ico-拍摄";
    }else if([itemNameEn isEqualToString:@"sup_wifi"]) {
        imageName = @"拳馆功能ico-wifi";
    }else if([itemNameEn isEqualToString:@"sup_referee"]) {
        imageName = @"拳馆功能ico-裁判";
    }else{
        NSLog(@"没找到对应设施的图片");
    }
    return imageName;
}

+ (NSString *)getGymSupportItemNameWithItemNameEn:(NSString *)itemNameEn{
    NSString *name = @"";
    if ([itemNameEn isEqualToString:@"sup_bathe"]) {
        name = @"-洗澡";
    } else if([itemNameEn isEqualToString:@"sup_prop"]) {
        name = @"器械";
    }else if([itemNameEn isEqualToString:@"sup_security"]) {
        name = @"安保";
    }else if([itemNameEn isEqualToString:@"sup_shoot"]) {
        name = @"拍摄";
    }else if([itemNameEn isEqualToString:@"sup_wifi"]) {
        name = @"Wi-Fi";
    }else if([itemNameEn isEqualToString:@"sup_referee"]) {
        name = @"裁判";
    }else{
        NSLog(@"没找到对应设施的名字");
    }
    return name;
}

+ (void)saveDateStr:(NSString *)str ToMutableArray:(NSMutableArray *)mutableArray{
    BOOL containStr = false;
    for (NSString *string in mutableArray) {
        if ([string isEqualToString:str]){
            containStr = true;
            break;
        }
    }
    if (!containStr) {
        [mutableArray addObject:str];
    }
}

//加密方法
+(NSString *)md5Dictionary:(NSDictionary *)dic withCheckKey:(NSString *)checkKey{
    
    //把keys按照字典顺序排列
    NSArray *keyArray =[[dic allKeys]sortedArrayUsingSelector:@selector(compare:)];
    
    NSString *result = @"";//返回的结果

    for(NSString * key in keyArray ){
        NSString *value = dic[key];
        if (!value) {
            value = @"";
        }
        result = [NSString stringWithFormat:@"%@%@", result, value];
    }
    NSLog(@"md5前的result：%@", result);
    result  = [NSString stringWithFormat:@"%@%@", result, checkKey];
    result = [MD5 md5:result];
    NSLog(@"md5后的result：%@", result);
    return result;
}


+ (void)loginwithVC:(UIViewController *) vc{
    FTLoginViewController *loginVC = [[FTLoginViewController alloc]init];
    loginVC.title = @"登录";
    FTBaseNavigationViewController *nav = [[FTBaseNavigationViewController alloc]initWithRootViewController:loginVC];
    [vc.navigationController presentViewController:nav animated:YES completion:nil];
}
#pragma -mark 更新评分view
+ (void)updateScoreView:(UIView *)scoreView withScore:(float)scoreFloat{
    NSArray *scoreImageViewsArray = [scoreView subviews];
//    float scoreFloat = 3.5;//原评分
    
    //校正评分值为0~5
    if (scoreFloat < 1) {
        scoreFloat = 1;
    }else if (scoreFloat > 5){
        scoreFloat = 5;
    }
    
    int scoreInteger = scoreFloat / 1;//评分的整数部分
    BOOL isIntegerScore;
    if (scoreFloat == scoreInteger) {
        NSLog(@"评分为整数");
        isIntegerScore = YES;
    } else {
        NSLog(@"评分为小数");
        isIntegerScore = NO;
    }
    
    for (int i = 0; i < 5; i++) {
        UIImageView *imageView = scoreImageViewsArray[i];
        if (i <= scoreInteger - 1) {
            imageView.image = [UIImage imageNamed:@"火苗-红"];
        } else {
            if (!isIntegerScore && i == scoreInteger) {
                imageView.image = [UIImage imageNamed:@"火苗-半-大宽边1"];
            } else {
                imageView.image = [UIImage imageNamed:@"火苗-灰"];
            }
        }
    }
}
+ (NSString *)getCurrentMonth{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyy"];
    NSString *  yearString = [dateformatter stringFromDate:senddate];
    [dateformatter setDateFormat:@"MM"];
    NSString *  monthString = [dateformatter stringFromDate:senddate];
    [dateformatter setDateFormat:@"dd"];
    NSString *  dayString = [dateformatter stringFromDate:senddate];
    [dateformatter setDateFormat:@"EEE"];
    
    NSString *  weekString = [dateformatter stringFromDate:senddate];
    NSLog(@"-%@",weekString);
    int year = [yearString intValue];
    NSLog(@"-%d", year);
    int month = [monthString intValue];
    NSLog(@"--%d", month);
    int day = [dayString intValue];
    NSLog(@"---%d", day);
    return monthString;
}

+(BOOL)hasLoginWithViewController:(UIViewController *) vc{
    BOOL hasLogin = NO;
    
    FTUserBean *user = [FTUserBean loginUser];
    if (user) {
        hasLogin = YES;
    }else{
        [FTTools loginwithVC:vc];
    }
    return hasLogin;
}

+ (NSString *)getAgeWithTimeStamp:(NSString *)timeStampString{
    NSString *age = @"0";
    timeStampString = [NSString stringWithFormat:@"%@", timeStampString];
    if (timeStampString) {
        timeStampString = [NSString stringWithFormat:@"%@", timeStampString];
        timeStampString = [timeStampString substringToIndex:timeStampString.length - 3];
    }else{
        return age;
    }
    
    
    NSDateFormatter *dateFormater = [NSDateFormatter new];
    [dateFormater setDateFormat:@"yyyy"];
    NSString *currentYear = [dateFormater stringFromDate:[NSDate date]];
    int currentYearInt = [currentYear intValue];
    
    NSString *birthYear = [dateFormater stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timeStampString doubleValue]]];
    int birthYearInt = [birthYear intValue];
    
    int ageInt = currentYearInt - birthYearInt;
    if (age < 0) {
        ageInt = 0;
    }
    age = [NSString stringWithFormat:@"%d", ageInt];
    return age;
}

+(int)getRandomNumber:(int)from to:(int)to{
    return (int)(from + (arc4random() % (to - from + 1)));
}
/**
 退出后清除缓存、配置
 */
+ (void)clearCacheWhenLogout{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:LoginUser];//清除用户的登录信息
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:COURSE_VERSION];//清除本地的历史课程版本信息 16-11-9 by lyz
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:TIPS_GYM_COURSE];//清除拳馆课程的tip
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:TIPS_COACH_COURSE];//清除预约私教课程的tip
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end

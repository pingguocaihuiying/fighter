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

@implementation FTTools
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
    NSLog(@"-%@",weekString);
    int year = [yearString intValue];
    NSLog(@"-%d", year);
    int month = [monthString intValue];
    NSLog(@"--%d", month);
    int day = [dayString intValue];
    NSLog(@"---%d", day);
    
    // 判断当前天是周几，从而计算出当周的周一是几号（负数表示上个月月末）
    if ([weekString  isEqual: @"周一"]) {
        weekday = 1;
    } else if ([weekString isEqual:@"周二"]) {
        weekday = 2;
    } else if ([weekString isEqual:@"周三"]) {
        weekday = 3;
    } else if ([weekString isEqual:@"周四"]) {
        weekday = 4;
    } else if ([weekString isEqual:@"周五"]) {
        weekday = 5;
    } else if ([weekString isEqual:@"周六"]) {
        weekday = 6;
    } else if ([weekString isEqual:@"周日"]) {
        weekday = 7;
    }
    return weekday;
}

@end

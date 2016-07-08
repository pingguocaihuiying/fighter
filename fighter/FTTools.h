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
@end

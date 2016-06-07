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
+ (NSString *)fixStringForDate:(NSString *)timestampString;//日期转换
@end

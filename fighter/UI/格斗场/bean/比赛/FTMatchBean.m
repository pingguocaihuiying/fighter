//
//  FTMatchBean.m
//  fighter
//
//  Created by Liyz on 25/07/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTMatchBean.h"
#import <Objc/runtime.h>

@implementation FTMatchBean

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _matchId = [NSString stringWithFormat:@"%@", value];
    }
//    else if ([key isEqualToString:@"follow"]){
//        _follow = [value boolValue];
//
//    }else if ([key isEqualToString:@"allowBet"]){
//        _allowBet = [value boolValue];
//    }
}

- (void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues{
    NSArray *keys = [keyedValues allKeys];
    for( NSString * key in keys){//处理5s以下32位机子上bool值设置的bug
        if ( [key isEqualToString:@"follow"]) {
            BOOL value = [keyedValues[key] boolValue];
            [keyedValues setValue:[NSNumber numberWithBool:value] forKey:key];
        } else if ( [key isEqualToString:@"allowBet"]){
            BOOL value = [keyedValues[key] boolValue];
            [keyedValues setValue:[NSNumber numberWithBool:value] forKey:key];
        }
    }

    [super setValuesForKeysWithDictionary:keyedValues];
}

//- (void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues{
//    [super setValuesForKeysWithDictionary:keyedValues];
//    
//    id matchBeanClass = objc_getClass("FTMatchBean");
//    unsigned int outCount, i;
//    objc_property_t *properties = class_copyPropertyList(matchBeanClass, &outCount);
//    for (i = 0; i < outCount; i++) {//循环读取self的属性列表
//        objc_property_t property = properties[i];
////        fprintf(stdout, "%s %s\n", property_getName(property), property_getAttributes(property));
//        
//        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
//        NSString *propertyValue = [self valueForKey:propertyName];
//        if (!propertyValue) {//如果值不存在，则赋值“”
//            propertyValue = @"";
//        }else{//格式化为字符串
//            propertyValue = [NSString stringWithFormat:@"%@", propertyValue];
//        }
//        
//        [self setValue:propertyValue forKey:propertyName];
//    }
//    
//    //处理胜、负、击倒属性，如果为空，赋值为0
//    if ([_win1 isEqualToString:@""]) {
//        _win1 = @"0";
//    }
//    if ([_fail1 isEqualToString:@""]) {
//        _fail1 = @"0";
//    }
//    if ([_draw1 isEqualToString:@""]) {
//        _draw1 = @"0";
//    }
//    if ([_knockout1 isEqualToString:@""]) {
//        _knockout1 = @"0";
//    }
//    
//    if ([_win2 isEqualToString:@""]) {
//        _win2 = @"0";
//    }
//    if ([_fail2 isEqualToString:@""]) {
//        _fail2 = @"0";
//    }
//    if ([_draw2 isEqualToString:@""]) {
//        _draw2 = @"0";
//    }
//    if ([_knockout2 isEqualToString:@""]) {
//        _knockout2 = @"0";
//    }
//    
//}

@end

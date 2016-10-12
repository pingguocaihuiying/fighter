//
//  NSString+Tool.m
//  fighter
//
//  Created by kang on 2016/10/12.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "NSString+Tool.h"

@implementation NSString (Tool)

+ (NSString *) gymNameAdapter:(NSString *)gymName {

    if ([gymName isEqualToString:@"综合格斗(MMA)"]) {
        gymName  = @"综合格斗";
    }
    
    return gymName;
}
@end

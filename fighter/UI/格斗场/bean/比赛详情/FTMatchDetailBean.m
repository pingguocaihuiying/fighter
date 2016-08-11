//
//  FTMatchDetailBean.m
//  fighter
//
//  Created by mapbar on 16/8/3.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTMatchDetailBean.h"

@implementation FTMatchDetailBean

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _matchId = [[NSNumber alloc]initWithInt:[value intValue]];
    }
}

@end

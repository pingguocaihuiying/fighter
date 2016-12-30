//
//  FTGymDetailBean.m
//  fighter
//
//  Created by 李懿哲 on 16/9/14.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTGymDetailBean.h"
#import "FTPlaceBean.h"

@implementation FTGymDetailBean


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"placeBeans"]) {
        
    }
}

- (void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues{
    [super setValuesForKeysWithDictionary:keyedValues];
    NSArray *placeArray = keyedValues[@"placeBeans"];
    if (placeArray) {
        NSMutableArray *placeBeanArray = [NSMutableArray new];
        for(NSDictionary *placeDic in placeArray){
            FTPlaceBean *placeBean = [FTPlaceBean new];
            [placeBean setValuesWithDic:placeDic];
            [placeBeanArray addObject:placeBean];
        }
        _placeBeans = placeBeanArray;        
    }
}

@end

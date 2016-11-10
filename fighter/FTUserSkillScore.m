//
//  FTUserSkillScore.m
//  fighter
//
//  Created by 李懿哲 on 10/11/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTUserSkillScore.h"

@implementation FTUserSkillScore

- (void)setValuesWithDic:(NSDictionary *)dic{
    _skill = dic[@"skill"];
    _score = [dic[@"score"] floatValue];
    _increase = _score = [dic[@"increase"] floatValue];
    _scoreOld = _score - _increase;
}

@end

//
//  FTUserSkillBean.m
//  fighter
//
//  Created by 李懿哲 on 11/11/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTUserSkillBean.h"

@implementation FTUserSkillBean

- (void)setValuesWithDic:(NSDictionary *)dic{
    //id
    NSString *id = dic[@"id"];
    if (id) {
        _id = [id intValue];
    }
    //子项个数
    NSString *subNumber = dic[@"subNumber"];
    if (subNumber) {
        _subNumber = [subNumber intValue];
    }
    //父项id
    NSString *parrentId = dic[@"parrent"];
    if (parrentId) {
        _parrentId = [parrentId intValue];
    }
    
    //如果父项id为0，说明自己为父项
    _isParrent = _parrentId == 0;
    
    //分值
    NSString *score = dic[@"score"];
    if (score) {
        _score = [score floatValue];
    }
    
    //技能名字
    NSString *name = dic[@"name"];
    if (name) {
        _name = name;
    }
    
    
    
}

@end

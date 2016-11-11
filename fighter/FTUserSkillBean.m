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
    NSString *parentId = dic[@"parent"];
    if (parentId) {
        _parentId = [parentId intValue];
    }
    
    //如果父项id为0，说明自己为父项
    _isParrent = _parentId == 0;
    
    //分值
    NSString *score = dic[@"score"];
    if (score) {
        
        float scoreFloat = [score floatValue];
        
        if(scoreFloat < 0){
            scoreFloat = 0;
        }else if (scoreFloat > 99){
            scoreFloat = 99;
        }
        
        _score = scoreFloat;
    }
    
    //技能名字
    NSString *name = dic[@"name"];
    if (name) {
        _name = name;
    }
    
    
    
}

@end

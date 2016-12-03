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

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:[NSString stringWithFormat:@"%d", _id] forKey:@"id"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%d", _subNumber] forKey:@"subNumber"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%f", _score] forKey:@"score"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%d", _parentId] forKey:@"parentId"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%d", _isParrent] forKey:@"isParrent"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {

        self.id = [[aDecoder decodeObjectForKey:@"id"] intValue];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.subNumber = [[aDecoder decodeObjectForKey:@"subNumber"] intValue];
        self.score = [[aDecoder decodeObjectForKey:@"score"] floatValue];
        self.parentId = [[aDecoder decodeObjectForKey:@"parentId"] intValue];
        self.isParrent = [[aDecoder decodeObjectForKey:@"subNumber"] boolValue];
    }
    return self;
}

@end

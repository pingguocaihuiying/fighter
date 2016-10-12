//
//  FTGymCommentBean.m
//  fighter
//
//  Created by kang on 16/9/21.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTGymCommentBean.h"

@implementation FTGymCommentBean

- (void)setValuesWithDic:(NSDictionary *)dic{
    
    _id = [dic[@"id"] intValue];
    
    _comfort = [dic[@"comfort"] intValue];
    _strength = [dic[@"strength"] floatValue];
    _teachLevel = [dic[@"teachLevel"] intValue];
    
    _commentCount = [dic[@"commentCount"] intValue];
    _voteCount = [dic[@"voteCount"] intValue];
    
    self.comment = dic[@"comment"];
    self.createName = dic[@"createName"];
    self.createTime = [NSString stringWithFormat:@"%@",dic[@"createTime"]];
    self.headUrl = dic[@"headUrl"];
    self.userId = dic[@"userId"];
    self.objId = dic[@"objId"];
    self.urls = dic[@"urls"];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}


@end

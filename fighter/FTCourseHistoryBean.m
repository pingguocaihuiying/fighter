//
//  FTCourseHistoryBean.m
//  fighter
//
//  Created by kang on 2016/10/10.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTCourseHistoryBean.h"

@implementation FTCourseHistoryBean

- (void)setValuesWithDic:(NSDictionary *)dic{
    
    self.id = [dic[@"id"] integerValue];
    
    self.coachUserId = dic[@"coachUserId"];
    self.corporationid = [dic[@"corporationid"] integerValue];
    
    self.coachName = dic[@"coachName"];
    self.createName = dic[@"createName"];
    self.updateName = dic[@"updateName"];
    
    self.date = [dic[@"date"] longLongValue];
    self.createTime = [dic[@"createTime"] longLongValue];
    self.createTimeTamp = [dic[@"createTimeTamp"] longLongValue];
    self.updateTime = [dic[@"updateTime"] longLongValue];
    self.updateTimeTamp = [dic[@"updateTimeTamp"] longLongValue];
    
    self.price = [dic[@"price"] integerValue];
    self.theDate = [dic[@"theDate"] integerValue];
    self.timeId = [dic[@"timeId"] integerValue];
    self.type = [dic[@"type"] integerValue];
    
    self.timeSection = dic[@"timeSection"];
    
    self.userId = dic[@"userId"];
}


@end

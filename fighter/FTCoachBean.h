//
//  FTCoachBean.h
//  fighter
//
//  Created by 李懿哲 on 09/10/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTBaseBean.h"

@interface FTCoachBean : FTBaseBean

@property (nonatomic, copy) NSString *id;//id
@property (nonatomic, copy) NSString *name;//姓名
@property (nonatomic, copy) NSString *sex;//性别
@property (nonatomic, copy) NSString *labels;//标签
@property (nonatomic, copy) NSString *brief;//简介
@property (nonatomic, copy) NSString *price;//预约价格
@property (nonatomic, copy) NSString *age;//预约价格 
@property (nonatomic, copy) NSString *headUrl;//头像
@property (nonatomic, copy) NSString *corporationid;//所在拳馆id userId
@property (nonatomic, copy) NSString *userId;//olduserId
- (void)setWithDic:(NSDictionary *)dic;

@end

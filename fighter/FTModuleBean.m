//
//  FTModuleBean.m
//  fighter
//
//  Created by 李懿哲 on 28/11/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTModuleBean.h"

@implementation FTModuleBean

- (void)setValuesWithDic:(NSDictionary *)dic{
    _id = [dic[@"id"] integerValue];
    _serial = [dic[@"serial"] integerValue];
    _followId = [dic[@"followId"] integerValue];
    
    _name = dic[@"name"];
    _category = dic[@"category"];
    
    _pict = dic[@"pict"];
    
    NSString *desc = dic[@"descr"];
    if (!desc) {
        desc = @"还没有添加描述信息";
    }
    _desc = desc;
}

@end

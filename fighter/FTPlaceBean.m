//
//  FTPlaceBean.m
//  fighter
//
//  Created by 李懿哲 on 30/12/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTPlaceBean.h"

@implementation FTPlaceBean

- (void)setValuesWithDic:(NSDictionary *)dic{
    _placeId = [dic[@"id"] integerValue];
    _serialId = [dic[@"serial"] integerValue];
    _name = dic[@"name"];
}

@end

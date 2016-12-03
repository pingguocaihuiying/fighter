//
//  FTCoachBean.m
//  fighter
//
//  Created by 李懿哲 on 09/10/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTCoachBean.h"

@implementation FTCoachBean

- (void)setWithDic:(NSDictionary *)dic{
    _id = dic[@"id"];
    _name = dic[@"name"];
    
    NSString *sexString = [NSString stringWithFormat:@"%@", dic[@"sex"]];
    if (sexString && [sexString isEqualToString:@"1"]) {
        _sex = @"女";
    }else{
        _sex = @"男";
    }
    
    _labels = [NSString stringWithFormat:@"%@", dic[@"labels"]];
    
    _brief = [NSString stringWithFormat:@"%@", dic[@"brief"]];
    
    if (dic[@"price"]) {
        _price = [NSString stringWithFormat:@"%@", dic[@"price"]];
    }else{
        _price = @"0";
    }
    
    
    NSString *timeStampString = [NSString stringWithFormat:@"%@", dic[@"birthday"]];
    
    _age = [FTTools getAgeWithTimeStamp:timeStampString];
    
    _headUrl = [NSString stringWithFormat:@"%@", dic[@"headUrl"]];
    
    _corporationid = [NSString stringWithFormat:@"%@", dic[@"corporationid"]];
    
    _userId = dic[@"userId"];
}



@end

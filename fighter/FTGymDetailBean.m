//
//  FTGymDetailBean.m
//  fighter
//
//  Created by 李懿哲 on 16/9/14.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTGymDetailBean.h"

@implementation FTGymDetailBean

- (void)setValuesWithDic:(NSDictionary *)dic{
    _id = [dic[@"id"] intValue];
    _commentcount = [dic[@"commentcount"] intValue];
    _gym_corporationid = [dic[@"gym_corporationid"] intValue];
    _corporationid = [dic[@"corporationid"] intValue];
    _grade = [dic[@"commentcount"] floatValue];
    _pictureCount = [dic[@"pictureCount"] intValue];
    _videoCount = [dic[@"videoCount"] intValue];
    
    self.gym_location = dic[@"gym_location"];
    self.gym_name = dic[@"gym_name"];
    self.picture = dic[@"picture"];
    self.gymImgs = [NSArray arrayWithObject:dic[@"gymImgs"]];
//    _gymImgs = [NSArray arrayWithObjects:<#(nonnull id), ...#>, nil]
    self.gymVideos = dic[@"gymVideos"];
    self.urlprefix = dic[@"urlprefix"];
    self.coachs = dic[@"coachs"];
    self.gym_tel = dic[@"gym_tel"];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"key : %@, value : %@", key, value);
}

@end

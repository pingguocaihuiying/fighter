//
//  FTCoachPhotoBean.m
//  fighter
//
//  Created by 李懿哲 on 20/12/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTCoachPhotoBean.h"

@implementation FTCoachPhotoBean

- (void)setValuesWithDic:(NSDictionary *)dic{
    _url = dic[@"url"];
    _type = [dic[@"type"] intValue];
    _title = [NSString stringWithFormat:@"%@", dic[@"title"]];
    if (dic[@"thumb"]) {
        _videoImageURL = dic[@"thumb"];
    }
}

@end

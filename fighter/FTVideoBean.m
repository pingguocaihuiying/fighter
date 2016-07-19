//
//  FTVideoBean.m
//  fighter
//
//  Created by Liyz on 5/3/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTVideoBean.h"

@implementation FTVideoBean

- (void)setValuesWithDic:(NSDictionary *)dic{
    
    self.summary = dic[@"summary"];
    self.author = dic[@"author"];
    self.img = dic[@"img"];
    self.url = dic[@"url"];
    self.videosTime = dic[@"videosTime"];
    self.title = dic[@"title"];
    self.videosId = dic[@"videosId"];
    self.videosType = dic[@"videosType"];
    self.voteCount = dic[@"voteCount"];
    self.commentCount = dic[@"commentCount"];
    self.videoLength = dic[@"videoLength"];
    self.viewCount = dic[@"viewCount"];
    self.coachid = dic[@"coachid"];
    self.boxerid = dic[@"boxerid"];
    self.isTeach = dic[@"isTeach"];
    self.boxinghallid = dic[@"boxinghallid"];
    self.price = dic[@"price"];
    //新增字段：
    //coachid 教练相关id，没有则为0
    //boxerid 拳手相关id，没有则为0
    //isTeach 是否为教学视频：0不是1是
    //boxinghallid 拳馆相关id，没有则为0
}

- (void)clear{
    
    self.summary = nil;
    self.author =nil;;
    self.img = nil;;
    self.url = nil;;
    self.videosTime =nil;;
    self.title =nil;;
    self.videosId = nil;;
    self.videosType = nil;;
    self.voteCount = nil;
    self.commentCount = nil;
    self.videoLength = nil;
    self.viewCount = nil;
    self.coachid = nil;
    self.boxerid = nil;
    self.isTeach = nil;
    self.boxinghallid = nil;
    self.price = nil;
    //新增字段：
    //coachid 教练相关id，没有则为0
    //boxerid 拳手相关id，没有则为0
    //isTeach 是否为教学视频：0不是1是
    //boxinghallid 拳馆相关id，没有则为0
}


@end

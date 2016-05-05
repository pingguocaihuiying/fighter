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
    self.vediosId = dic[@"vediosId"];
    self.videosType = dic[@"videosType"];
    self.voteCount = dic[@"voteCount"];
    self.commentCount = dic[@"commentCount"];
    self.videoLength = dic[@"videoLength"];
    self.viewCount = dic[@"viewCount"];
}

@end

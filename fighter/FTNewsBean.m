//
//  FTNewsBean.m
//  fighter
//
//  Created by Liyz on 4/13/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTNewsBean.h"

@implementation FTNewsBean

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"");
}

- (void)setValuesWithDic:(NSDictionary *)dic{
    
    self.layout = dic[@"layout"];
    self.newsTime = dic[@"newsTime"];
    self.img_small_three = dic[@"img_small_three"];
    self.img_small_one = dic[@"img_small_one"];
    self.author = dic[@"author"];
    self.url = dic[@"url"];
    self.title = dic[@"title"];
    self.img_big = dic[@"img_big"];
    self.summary = dic[@"summary"];
    self.img_small_two = dic[@"img_small_two"];
    self.newsType = dic[@"newsType"];
    self.commentCount = dic[@"commentCount"];
    self.voteCount = dic[@"voteCount"];
    self.layout = dic[@"layout"];
    self.newsId = dic[@"newsId"];
}

@end

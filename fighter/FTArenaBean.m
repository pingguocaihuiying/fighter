//
//  FTArenaBean.m
//  fighter
//
//  Created by Liyz on 5/19/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTArenaBean.h"

@implementation FTArenaBean

//@property (nonatomic,copy) NSString *uid;
//@property (nonatomic,copy) NSString *updateTime;
//@property (nonatomic,copy) NSString *createName;
//@property (nonatomic,copy) NSString *labels;
//@property (nonatomic,copy) NSString *videoUrlNames;
//@property (nonatomic,copy) NSString *title;
//@property (nonatomic,copy) NSString *userId;
//@property (nonatomic,copy) NSString *createTime;
//@property (nonatomic,copy) NSString *updateName;
//@property (nonatomic,copy) NSString *isDelated;
//@property (nonatomic,copy) NSString *pictureUrlNames;
//@property (nonatomic,copy) NSString *thumbUrl;
//@property (nonatomic,copy) NSString *urlPrefix;
//@property (nonatomic,copy) NSString *content;


- (void)setValuesWithDic:(NSDictionary *)dic{
    self.uid = dic[@"id"];
    self.updateTime = dic[@"updateTime"];
    self.createName = dic[@"createName"];
    self.labels = dic[@"labels"];
    self.videoUrlNames = dic[@"videoUrlNames"];
    self.title = dic[@"title"];
    self.userId = dic[@"userId"];
    self.createTime = dic[@"createTime"];
    self.updateName = dic[@"updateName"];
    self.isDelated = dic[@"isDelated"];
    self.pictureUrlNames = dic[@"pictureUrlNames"];
    self.thumbUrl = dic[@"thumbUrl"];
    self.urlPrefix = dic[@"urlPrefix"];
    self.content = dic[@"content"];
    self.headUrl = dic[@"headUrl"];
    self.commentCount = dic[@"commentCount"];
    self.voteCount = dic[@"voteCount"];
}

@end

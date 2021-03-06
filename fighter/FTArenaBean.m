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
    self.postsId = dic[@"id"];
    self.updateTime = dic[@"updateTime"];
    self.createName = dic[@"createName"];
    self.labels = dic[@"labels"];
    self.videoUrlNames = dic[@"videoUrlNames"];
    if (self.videoUrlNames == nil) {
        self.videoUrlNames = @"";
    }
    self.createTimeTamp = dic[@"createTimeTamp"];
    self.updateTimeTamp = dic[@"updateTimeTamp"];
    self.title = dic[@"title"];
    self.userId = dic[@"userId"];
    self.createTime = dic[@"createTime"];
    self.updateName = dic[@"updateName"];
    self.isDelated = dic[@"isDelated"];
    self.pictureUrlNames = dic[@"pictureUrlNames"];
    if (self.pictureUrlNames == nil) {
        self.pictureUrlNames = @"";
    }
    self.thumbUrl = dic[@"thumbUrl"];
    self.urlPrefix = dic[@"urlPrefix"];
    
    if (dic[@"content"]) {
        self.content = dic[@"content"];
    }else{
        self.content = @"";
    }
    
    self.headUrl = dic[@"headUrl"];
    self.commentCount = dic[@"commentCount"];
    self.createTimeTamp = dic[@"createTimeTamp"];
    self.updateTimeTamp = dic[@"updateTimeTamp"];
    
//    self.commentCount = [NSString stringWithFormat:@"%@", self.commentCount];
    if (self.commentCount == nil) {
        self.commentCount = @"0";
    }
    self.voteCount = dic[@"voteCount"];
//    self.voteCount = [NSString stringWithFormat:@"%@", self.voteCount];
    if (self.voteCount == nil) {
        self.voteCount = @"0";
    }
    self.nickname = dic[@"nickname"];
    self.viewCount = dic[@"viewCount"];
}

@end

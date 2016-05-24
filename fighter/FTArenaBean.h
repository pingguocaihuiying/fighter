//
//  FTArenaBean.h
//  fighter
//
//  Created by Liyz on 5/19/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTBaseBean.h"

@interface FTArenaBean : FTBaseBean

@property (nonatomic,copy) NSString *postsId;
@property (nonatomic,copy) NSString *updateTime;
@property (nonatomic,copy) NSString *createName;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *createTimeTamp;
@property (nonatomic,copy) NSString *labels;
@property (nonatomic,copy) NSString *videoUrlNames;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *updateName;
@property (nonatomic,copy) NSString *updateTimeTamp;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *isDelated;
@property (nonatomic,copy) NSString *pictureUrlNames;
@property (nonatomic,copy) NSString *thumbUrl;
@property (nonatomic,copy) NSString *urlPrefix;
@property (nonatomic,copy) NSString *content;//"headUrl": "用户头像", commentCount：评论数   voteCount：点赞数
@property (nonatomic,copy) NSString *headUrl;
@property (nonatomic,copy) NSString *commentCount;
@property (nonatomic,copy) NSString *voteCount;
@property (nonatomic, copy) NSString *viewCount;
@property (nonatomic, copy) NSString *isReader;

- (void)setValuesWithDic:(NSDictionary *)dic;
@end

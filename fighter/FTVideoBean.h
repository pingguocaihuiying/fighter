//
//  FTVideoBean.h
//  fighter
//
//  Created by Liyz on 5/3/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTBaseBean.h"

@interface FTVideoBean : FTBaseBean

@property (nonatomic,copy) NSString *summary;
@property (nonatomic,copy) NSString *author;
@property (nonatomic,copy) NSString *img;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *videosTime;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *videosId;
@property (nonatomic,copy) NSString *videosType;
@property (nonatomic,copy) NSString *voteCount;
@property (nonatomic,copy) NSString *commentCount;
@property (nonatomic,copy) NSString *videoLength;
@property (nonatomic,copy) NSString *viewCount;
@property (nonatomic,copy) NSString *price;
//新增字段：
//coachid 教练相关id，没有则为0
//boxerid 拳手相关id，没有则为0
//isTeach 是否为教学视频：0不是1是
//boxinghallid 拳馆相关id，没有则为0
@property (nonatomic,copy) NSString *coachid;
@property (nonatomic,copy) NSString *boxerid;
@property (nonatomic,copy) NSString *isTeach;
@property (nonatomic,copy) NSString *boxinghallid;

@property (nonatomic,copy) NSString *isReader;

- (void)setValuesWithDic:(NSDictionary *)dic;

@end

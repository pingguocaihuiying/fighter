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
@property (nonatomic,copy) NSString *vediosId;
@property (nonatomic,copy) NSString *videosType;
@property (nonatomic,copy) NSString *voteCount;
@property (nonatomic,copy) NSString *commentCount;
@property (nonatomic,copy) NSString *videoLength;
@property (nonatomic,copy) NSString *viewCount;

- (void)setValuesWithDic:(NSDictionary *)dic;

@end

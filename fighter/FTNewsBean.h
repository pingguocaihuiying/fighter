//
//  FTNewsBean.h
//  fighter
//
//  Created by Liyz on 4/13/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTBaseBean.h"

@interface FTNewsBean : FTBaseBean

@property (nonatomic,copy) NSString *Id;
@property (nonatomic,copy) NSString *layout;
@property (nonatomic,copy) NSString *newsTime;
@property (nonatomic,copy) NSString *img_small_three;
@property (nonatomic,copy) NSString *author;
@property (nonatomic,copy) NSString *img_small_one;
@property (nonatomic,copy) NSString *newsId;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *img_big;
@property (nonatomic,copy) NSString *summary;
@property (nonatomic,copy) NSString *img_small_two;
@property (nonatomic,copy) NSString *newsType;
@property (nonatomic,copy) NSString *commentCount;
@property (nonatomic,copy) NSString *voteCount;
@property (nonatomic,copy) NSString *isReader;

@property (nonatomic,copy) NSString *viewCount;

- (void)setValuesWithDic:(NSDictionary *)dic;

@end

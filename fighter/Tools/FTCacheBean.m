//
//  FTCacheBean.m
//  fighter
//
//  Created by Liyz on 5/12/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTCacheBean.h"

@implementation FTCacheBean

- (instancetype)initWithTimeStamp:(NSTimeInterval)timeStamp andDataArray:(NSArray *)dataArray{
    if (self = [super init]) {
        self.timeStamp = timeStamp;
        self.dataArray = dataArray;
    }
    return self;
}

- (instancetype)initWithTimeStamp:(NSTimeInterval)timeStamp andDataArray:(NSArray *)dataArray andVideoTag:(NSString *)videoTag{
    if (self = [super init]) {
        self.timeStamp = timeStamp;
        self.dataArray = dataArray;
        self.videoTag = videoTag;
    }
    return self;
}
@end

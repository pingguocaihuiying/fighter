//
//  FTCache.m
//  fighter
//
//  Created by Liyz on 5/12/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTCache.h"
#import "FTCacheBean.h"

@implementation FTCache

+ (instancetype)sharedInstance{
    static FTCache *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init{
    if (self = [super init]) {
        self.videoDataDic = [NSMutableDictionary new];
    }
    return self;
}

- (NSString *)description{
    NSString *rst = @"";
    rst = [NSString stringWithFormat:@"%@", self.videoDataDic];
    for(FTCacheBean *bean in self.videoDataDic){
        rst = [NSString stringWithFormat:@"%@%f%lu", rst, bean.timeStamp, bean.dataArray.count];
    }
    return rst;
}
@end

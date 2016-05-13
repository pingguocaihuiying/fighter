//
//  FTCacheBean.h
//  fighter
//
//  Created by Liyz on 5/12/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTCacheBean : NSObject
@property (nonatomic, assign)NSTimeInterval timeStamp;
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, copy)NSString *videoTag;
- (instancetype)initWithTimeStamp:(NSTimeInterval)timeStamp andDataArray:(NSArray *)dataArray;
- (instancetype)initWithTimeStamp:(NSTimeInterval)timeStamp andDataArray:(NSArray *)dataArray andVideoTag:(NSString *)videoTag;
@end

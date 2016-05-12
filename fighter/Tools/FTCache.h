//
//  FTCache.h
//  fighter
//
//  Created by Liyz on 5/12/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTCache : NSObject

@property (nonatomic, strong)NSMutableDictionary *videoDataDic;

+ (instancetype)sharedInstance;

@end

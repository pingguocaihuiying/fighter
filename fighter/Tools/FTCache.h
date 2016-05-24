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
@property (nonatomic, strong)NSMutableDictionary *newsDataDic;
@property (nonatomic, strong)NSMutableDictionary *arenaDataDic;

+ (instancetype)sharedInstance;

@end

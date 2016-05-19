//
//  FTArenaNetwork.h
//  fighter
//
//  Created by Liyz on 5/18/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTArenaNetwork : NSObject
/**
 *  发新帖
 */
- (void)newPostWithDic:(NSDictionary *)dic andOption: (void (^)(NSDictionary *dict))option;
@end

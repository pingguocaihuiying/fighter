//
//  FTQiniuNetwork.h
//  fighter
//
//  Created by Liyz on 5/19/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTQiniuNetwork : NSObject
+ (NSString *)getQiniuTokenWithOption:(void (^)(NSString *token))option;
@end

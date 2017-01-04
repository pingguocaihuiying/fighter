//
//  FTQiniuNetwork.h
//  fighter
//
//  Created by Liyz on 5/19/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QiniuSDK.h"

@interface FTQiniuNetwork : NSObject
+ (NSString *)getQiniuTokenWithMediaType:(NSString *)mediaType andKey:(NSString *)key andOption:(void (^)(NSString *token))option;

//获取一个自定义的上传管理者
+ (QNUploadManager *)getQNUploadManager;
@end

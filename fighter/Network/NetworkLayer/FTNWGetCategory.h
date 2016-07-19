//
//  FTNWGetCategory.h
//  fighter
//
//  Created by Liyz on 5/16/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTNWGetCategory : NSObject
/**
 *  获取分类
 *
 *  @param option 回调的结果是一个数组
 */
//- (void)getCategoryWithOption:(void(^)(NSArray *array))option;
+ (NSArray *)sharedCategories;

/**
 *  获取教学视频分类标签
 *
 *  @param option 回调的结果是一个数组
 */

+ (NSArray *)sharedTeachVideoCategories;
@end

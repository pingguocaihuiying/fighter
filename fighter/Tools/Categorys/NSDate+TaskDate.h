//
//  NSDate+TaskDate.h
//  fighter
//
//  Created by kang on 16/8/23.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (TaskDate)



/**
 日常任务每天的触发日期

 @return 触发日期
 */
+(NSDate *) taskDate;


@end

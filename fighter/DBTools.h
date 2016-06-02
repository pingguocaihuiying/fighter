//
//  DBConnnect.h
//  fighter
//
//  Created by kang on 16/5/18.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#import "DBManager.h"


@interface DBTools : NSObject
{
    FMDatabase * _db;
    
}

/**
 * @brief 创建数据库
 */
- (void) createDataBase;
/**
 *   搜索segment 未加空格
 */
- (NSMutableArray *)searchWord:(NSString *)keyword;
/**
 *  查询音频
 */
- (id) searchAudioPath:(NSString *)textId;
/**
 *  查询空格处理句子
 */
- (NSString *) searchSegmentOrder:(NSString *)pkId ;

@end
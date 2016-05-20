//
//  DBConnnect.m
//  fighter
//
//  Created by kang on 16/5/18.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "DBTools.h"
#import "DBManager.h"

@implementation DBTools

- (id) init {
    self = [super init];
    if (self) {
        //========== 首先查看有没有建立word的数据库，如果未建立，则建立数据库=========
        _db = [DBManager shareDBManager].dataBase;
        
    }
    return self;
}


/**
 * @brief 创建Labels表
 */
- (void) createLabelsTable {
    
    FMResultSet * set = [_db executeQuery:@"select count(*) from sqlite_master where type ='table' and name = 'Labels'"];
    
    [set next];
    
    NSInteger count = [set intForColumnIndex:0];
    
    BOOL existTable = !!count;
    
    if (existTable) {
        // TODO:是否更新数据库
        //        [AppDelegate showStatusWithText:@"数据库已经存在" duration:2];
    } else {
        // TODO: 插入新的数据库
        NSString * sql = @"CREATE TABLE 'labels' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE, 'item' TEXT, 'label' TEXT, 'type' INTEGER)";
        BOOL res = [_db executeUpdate:sql];
        if (!res) {
            //            [AppDelegate showStatusWithText:@"数据库创建失败" duration:2];
        } else {
            //            [AppDelegate showStatusWithText:@"数据库创建成功" duration:2];
        }
    }
    
}



/**
 * @brief 模拟分页查找数据。取uid大于某个值以后的limit个数据
 *
 * @param uid
 * @param limit 每页取多少个
 */
//- (NSArray *) findWithUid:(NSString *) uid limit:(int) limit{
//
//}




@end

//
//  DBManager.m
//  fighter
//
//  Created by kang on 16/5/18.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "DBManager.h"
#import "FMDatabase.h"

#define DefaultDBName @"fighter.db"
static DBManager * _sharedDBManager = nil;
@implementation DBManager


+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDBManager = [super allocWithZone:zone];
    });
    return _sharedDBManager;
}

+ (DBManager *) shareDBManager {
    
    return [self allocWithZone:nil];
}





- (id) copyWithZone:(NSZone *)zone;{
    return self;
}


- (void) dealloc {
    [self close];
}


#pragma mark -init database

//检查数据库是否创建
- (void) checkDatabase {

    // 沙盒Docu目录
    NSString * docp = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbpath = [docp stringByAppendingString:[NSString stringWithFormat:@"/%@",DefaultDBName]];
    NSLog(@"databaseName = %@",dbpath);
    NSFileManager * fileManager = [NSFileManager defaultManager];
    BOOL exist = [fileManager fileExistsAtPath:dbpath];
    
    if (!exist) {
        NSLog(@"数据库创建");
    } else {
        NSLog(@"数据库创建已经存在");
    }

}

/**
 * @brief 初始化数据库操作
 * @param name 数据库名称
 * @return 返回数据库初始化状态， 0 为 已经存在，1 为创建成功，-1 为创建失败
 */
- (int) initDBWithName : (NSString *) name {
    
    if (!name) {
        return -1;  // 返回数据库创建失败
    }
    
    // 沙盒Docu目录
    NSString * docp = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    _name = [docp stringByAppendingString:[NSString stringWithFormat:@"/%@",name]];
    NSLog(@"databaseName = %@",_name);
    NSFileManager * fileManager = [NSFileManager defaultManager];
    BOOL exist = [fileManager fileExistsAtPath:_name];
    
    [self connect];
    
    if (!exist) {
        return 0;
    } else {
        return 1; // 返回 数据库已经存在
    }
}

/// 连接数据库
- (void) connect {
    
    NSString * docp = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    _name= [docp stringByAppendingString:[NSString stringWithFormat:@"/%@",DefaultDBName]];
    
    if (!_dataBase) {
        _dataBase = [[FMDatabase alloc] initWithPath:_name];
    }
    if (![_dataBase open]) {
        NSLog(@"不能打开数据库");
    }
}

/// 关闭连接
- (void) close {
    
    [_dataBase close];
    
}


#pragma mark - labels table

/**
 * @brief 创建Labels表
 */
- (void) createLabelsTable {
    
    FMResultSet * set = [_dataBase executeQuery:@"select count(*) from sqlite_master where type ='table' and name = 'Labels'"];
    
    [set next];
    
    NSInteger count = [set intForColumnIndex:0];
    
    BOOL existTable = !!count;
    
    if (existTable) {
        // TODO:是否更新数据库
         NSLog(@"数据库labels表创建成功");
        //        [AppDelegate showStatusWithText:@"数据库已经存在" duration:2];
    } else {
        // TODO: 插入新的数据库
        NSString * sql = @"CREATE TABLE 'labels' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE, 'item' TEXT, 'label' TEXT, 'type' INTEGER)";
        BOOL res = [_dataBase executeUpdate:sql];
        if (!res) {
            //            [AppDelegate showStatusWithText:@"数据库创建失败" duration:2];
        } else {
            //            [AppDelegate showStatusWithText:@"数据库创建成功" duration:2];
            NSLog(@"数据库labels表创建成功");
        }
    }
}

/**
 * @brief 插入label表数据
 */
- (void) insertDataIntoLabels:(NSDictionary *)dic {

    
    NSNumber *idNum = [NSNumber numberWithInteger:[dic[@"id"] integerValue]];
    NSString *item = dic[@"item"];
    NSString *label = dic[@"label"];
    NSNumber *type = [NSNumber numberWithInteger:[dic[@"type"] integerValue]];
    
    //1.判断数据是否已经存在
    FMResultSet * set = [_dataBase executeQuery:@"select id from labels where id = ?",idNum];
    [set next];
    NSInteger count = [set intForColumnIndex:0];
    BOOL exist = !!count;
    
    //2.如果已经存在则更新数据
    if(exist) {
        
        BOOL result = [_dataBase executeUpdate:@"UPDATE labels set item = ?,label= ?,type = ? where id = ?" , item,label,type,idNum];
        
        if (result) {
            NSLog(@"更新数据成功");
        }else {
            NSLog(@"更新数据失败");
        }
    
    }else {//3.如果数据不存在则插入数据
        BOOL result = [_dataBase executeUpdate:@"INSERT INTO labels (id, item,label,type) VALUES (?,?,?,?)", idNum, item, label,type];
        
        if (result) {
            NSLog(@"插入数据成功");
        }else {
            NSLog(@"插入数据失败");
        }
    }
    
}


/**
 * @brief 查询label表label字段
 */
-(NSMutableArray *) searchLabel {

    NSString *querySQL = @" SELECT distinct label  FROM labels";
    FMResultSet * rs = [_dataBase executeQuery:querySQL];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[rs columnCount]];
    
    while ([rs next]) {
        NSString *label =  [rs stringForColumn:@"label"];
//        label = [label stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [array addObject:label];
    }
    return array;
}


/**
 * @brief 查询label表item字段
 */
-(NSMutableArray *) searchItem:(NSInteger)type {
    
    NSNumber *typeNum = [NSNumber numberWithInteger:type];
    
    FMResultSet * rs = [_dataBase executeQuery:@" SELECT distinct item  FROM labels where type = ?",typeNum];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[rs columnCount]];
    
    while ([rs next]) {
        NSString *item =  [rs stringForColumn:@"item"];
//        item = [item stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [array addObject:item];
    }
    return array;
}

/**
 * @brief 查询label表item字段
 * @param label 查询限制字段
 * @param type 类型
 */
-(NSMutableArray *) searchItem:(NSString *)label type:(NSInteger)type {
    
    
    NSNumber *typeNum = [NSNumber numberWithInteger:type];
    
    FMResultSet * rs = [_dataBase executeQuery:@" SELECT distinct item  FROM labels where label= ? and type = ?",label,typeNum];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[rs columnCount]];
    
    while ([rs next]) {
        NSString *item =  [rs stringForColumn:@"item"];
        //        item = [item stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [array addObject:item];
    }
    return array;
}



@end

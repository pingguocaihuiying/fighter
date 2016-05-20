//
//  DBManager.h
//  fighter
//
//  Created by kang on 16/5/18.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseAdditions.h"

@class FMDatabase;

/**
 * @brief 对数据链接进行管理，包括链接，关闭连接
 * 可以建立长连接 长连接
 */
@interface DBManager : NSObject

{
    NSString *_name;
}

/// 数据库操作对象，当数据库被建立时，会存在次至
@property (nonatomic, readonly) FMDatabase *dataBase;  // 数据库操作对象

/// 单例模式
+(DBManager *) shareDBManager;

/// 连接数据库
- (void) connect;

// 关闭数据库
- (void) close;


#pragma mark - labels table

/**
 * @brief 创建Labels表
 */
- (void) createLabelsTable;

/**
 * @brief 插入label表数据
 */
- (void) insertDataIntoLabels:(NSDictionary *)dic;

/**
 * @brief 查询label表label字段
 */
-(NSMutableArray *) searchLabel;

/**
 * @brief 查询label表item字段
 */
-(NSMutableArray *) searchItem:(NSInteger)type;

/**
 * @brief 查询label表item字段
 * @param label 查询限制字段
 * @param type 类型
 */
-(NSMutableArray *) searchItem:(NSString *)label type:(NSInteger)type;
@end

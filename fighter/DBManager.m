//
//  DBManager.m
//  fighter
//
//  Created by kang on 16/5/18.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "DBManager.h"
#import "FMDatabase.h"
#import "FTNewsBean.h"
#import "FTArenaBean.h"
#import "FTVideoBean.h"

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


#pragma mark - init database

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

-(void) createAllTables {

    [self createLabelsTable];
    [self createNewsTable];
    [self createArenasTable];
    
}


- (void) createTable:(NSString *) tableName sql:(NSString *) sql {
    FMResultSet * set = [_dataBase executeQuery:@"select count(*) from sqlite_master where type ='table' and name = ?",tableName];
    
    [set next];
    
    NSInteger count = [set intForColumnIndex:0];
    
    BOOL existTable = !!count;
    
    if (existTable) {
        // TODO:是否更新数据库
        NSLog(@"数据库中%@表已经存在",tableName);
        
    } else {
        
        BOOL res = [_dataBase executeUpdate:sql];
        if (!res) {
           NSLog(@"数据库%@表创建失败",tableName);
        } else {
           
            NSLog(@"数据库%@表创建成功",tableName);
        }
    }

    
}
#pragma mark - labels table

/**
 * @brief 创建Labels表
 */
- (void) createLabelsTable {
    
    
     NSString * sql = @"CREATE TABLE 'labels' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE, 'item' TEXT, 'label' TEXT, 'type' INTEGER)";
    
    [self createTable:@"labels" sql:sql];
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
//            NSLog(@"更新数据成功");
        }else {
            NSLog(@"更新数据失败");
        }
    
    }else {//3.如果数据不存在则插入数据
        BOOL result = [_dataBase executeUpdate:@"INSERT INTO labels (id, item,label,type) VALUES (?,?,?,?)", idNum, item, label,type];
        
        if (result) {
//            NSLog(@"插入数据成功");
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


#pragma mark - news table

/**
 * @brief 创建news表
 */
- (void) createNewsTable {
    
    NSString * sql = @"CREATE TABLE 'news' ('newsId' INTEGER PRIMARY KEY NOT NULL UNIQUE, 'author' TEXT, 'commentCount' INTEGER DEFAULT 0, 'img_big' TEXT, 'img_small_one' TEXT, 'img_small_three' TEXT, 'img_small_two' TEXT, 'layout' INTEGER, 'newsTime' INTEGER, 'newsType' TEXT, 'summary' TEXT, 'title' TEXT, 'url' TEXT, 'voteCount' TEXT DEFAULT 0, 'isReader' BOOLEAN);";
    
    [self createTable:@"news" sql:sql];
}


/**
 * @brief 插入news表数据
 */
- (void) insertDataIntoNews:(NSDictionary *)dic {
    
    
    NSNumber *idNum = [NSNumber numberWithInteger:[dic[@"newsId"] integerValue]];
    NSString *author = dic[@"author"];
    NSString *img_big = dic[@"img_big"];
    NSString *img_small_one = dic[@"img_small_one"];
    NSString *img_small_three = dic[@"img_small_three"];
    NSString *img_small_two = dic[@"img_small_two"];
    NSString *newsType = dic[@"newsType"];
    NSString *summary = dic[@"summary"];
    NSString *url = dic[@"url"];
    NSString *title = dic[@"title"];
    
    NSNumber *commentCount = [NSNumber numberWithInteger:[dic[@"commentCount"] integerValue]];
    NSNumber *voteCount = [NSNumber numberWithInteger:[dic[@"voteCount"] integerValue]];
    NSNumber *layout = [NSNumber numberWithInteger:[dic[@"layout"] integerValue]];
    NSNumber *newsTime = [NSNumber numberWithInteger:[dic[@"newsTime"] integerValue]];
    NSNumber *isReader = [NSNumber numberWithBool:NO];
    
    //1.判断数据是否已经存在
    FMResultSet * set = [_dataBase executeQuery:@"select newsId from news where newsId = ?",idNum];
    [set next];
    NSInteger count = [set intForColumnIndex:0];
    BOOL exist = !!count;
    
    //2.如果已经存在则更新数据
    if(exist) {
        
        BOOL result = [_dataBase executeUpdate:@"UPDATE news set author = ?,img_big= ?,img_small_one = ?, img_small_three= ?, img_small_two= ?, newsType= ?, summary= ? ,url= ? ,title= ? ,commentCount= ? ,voteCount= ? ,layout= ? ,newsTime= ? where newsId = ?",
                       author,
                       img_big,
                       img_small_one ,
                       img_small_three,
                       img_small_two,
                       newsType,
                       summary,
                       url ,
                       title ,
                       commentCount ,
                       voteCount ,
                       layout ,
                       newsTime,
                       idNum];
        
        if (result) {
//            NSLog(@"更新数据成功");
        }else {
            NSLog(@"更新数据失败");
        }
        
    }else {//3.如果数据不存在则插入数据
        BOOL result = [_dataBase executeUpdate:@"INSERT INTO news (newsId, author,img_big, img_small_one ,img_small_three,img_small_two, newsType,summary,url ,title ,commentCount , voteCount ,layout ,newsTime,isReader) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
                       idNum,
                       author,
                       img_big,
                       img_small_one ,
                       img_small_three,
                       img_small_two,
                       newsType,
                       summary,
                       url ,
                       title ,
                       commentCount ,
                       voteCount ,
                       layout ,
                       newsTime,
                       isReader
                       ];
        
        if (result) {
//            NSLog(@"插入数据成功");
        }else {
            NSLog(@"插入数据失败");
        }
    }
}

/**
 * @brief 查询news表所有字段
 * @param news 查询限制字段
 *
 */
-(NSMutableArray *) searchNewsWithType:(NSString *)type  page:(NSInteger )currentPage{
    NSLog(@"currentPage:%ld",(long)currentPage);
    NSNumber *pageNum = [NSNumber numberWithInteger:currentPage*20];
    FMResultSet * rs;
    if (type == nil || [type isEqualToString:@"All"]  || [type isEqualToString:@"old"]) {
        rs = [_dataBase executeQuery:@"SELECT *  FROM news where newsType != 'Hot' ORDER BY newsId DESC limit ?,20",pageNum];
        
    }else {
         rs = [_dataBase executeQuery:@" SELECT *  FROM news where newsType= ? ORDER BY newsId DESC limit ?,20",type,pageNum];
    }
    
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    while ([rs next]) {
        FTNewsBean *bean = [[FTNewsBean alloc]init];
        bean.Id = [rs stringForColumn:@"newsId"];
        bean.author = [rs stringForColumn:@"author"];
        bean.img_big = [rs stringForColumn:@"img_big"];
        bean.img_small_one = [rs stringForColumn:@"img_small_one"];
        bean.img_small_three = [rs stringForColumn:@"img_small_three"];
        bean.img_small_two = [rs stringForColumn:@"img_small_two"];
        bean.newsType = [rs stringForColumn:@"newsType"];
        bean.summary = [rs stringForColumn:@"summary"];
        bean.url = [rs stringForColumn:@"url"];
        bean.title = [rs stringForColumn:@"title"];
        bean.commentCount = [rs stringForColumn:@"commentCount"];
        bean.voteCount = [rs stringForColumn:@"voteCount"];
        bean.layout = [rs stringForColumn:@"layout"];
        bean.newsTime = [rs stringForColumn:@"newsTime"];
        bean.isReader = [rs boolForColumn:@"isReader"]==1?@"YES":@"NO";
        [array addObject:bean];
    }
    return array;
}


/**
 * @brief 更新news表所有字段
 * @param news表主键
 * @param 是否已读字段
 *
 */
- (void) updateNewsById:(NSString *)Id isReader:(BOOL)isReader {
    
    NSNumber * idNum = [NSNumber numberWithLong:[Id integerValue]];
    NSNumber * isreader = [NSNumber numberWithBool:isReader];
    BOOL result = [_dataBase executeUpdate:@"UPDATE news set isReader = ? where newsId = ?" ,isreader, idNum];
    
    if (result) {
        NSLog(@"更新数据成功");
    }else {
        NSLog(@"更新数据失败");
    }

}



#pragma mark - arenas table

/**
 * @brief 创建arenas表
 */
- (void) createArenasTable {
    
    NSString * sql = @"CREATE TABLE 'arenas' ('id' INTEGER PRIMARY KEY NOT NULL UNIQUE, 'content' TEXT, 'createName' TEXT, 'createTime' TEXT, 'createTimeTamp' INTEGER, 'headUrl' TEXT, 'isDelated' BOOLEAN DEFAULT 0, 'labels' TEXT, 'nickname' TEXT, 'thumbUrl' TEXT, 'title' TEXT, 'updateName' TEXT, 'updateTime' TEXT, 'updateTimeTamp' INTEGER, 'urlPrefix' TEXT, 'userId' TEXT, 'videoUrlNames' TEXT,'commentCount' INTEGER DEFAULT 0, 'voteCount' INTEGER DEFAULT 0, 'viewCount' INTEGER DEFAULT 0,'isReader' BOOLEAN DEFAULT 0);";
    
    [self createTable:@"arenas" sql:sql];
}


/**
 * @brief 插入arenas表数据
 */
- (void) insertDataIntoArenas:(NSDictionary *)dic {
    
    
    NSNumber *idNum = [NSNumber numberWithInteger:[dic[@"id"] integerValue]];
    NSNumber *createTimeTamp = [NSNumber numberWithInteger:[dic[@"createTimeTamp"] integerValue]];
    NSNumber *updateTimeTamp = [NSNumber numberWithInteger:[dic[@"updateTimeTamp"] integerValue]];
    NSNumber *isDelated = [NSNumber numberWithBool:[dic[@"isDelated"] boolValue]];
    NSNumber *isReader = [NSNumber numberWithBool:NO];
    
    NSNumber *commentCount = [NSNumber numberWithInteger:[dic[@"commentCount"] integerValue]];
    NSNumber *voteCount = [NSNumber numberWithInteger:[dic[@"voteCount"] integerValue]];
    NSNumber *viewCount = [NSNumber numberWithInteger:[dic[@"viewCount"] integerValue]];
    
    NSString *content = dic[@"content"];
    NSString *createName = dic[@"createName"];
    NSString *createTime = dic[@"createTime"];
    NSString *headUrl = dic[@"headUrl"];
    NSString *labels = dic[@"labels"];
    NSString *nickname = dic[@"nickname"];
    NSString *thumbUrl = dic[@"thumbUrl"];
    NSString *title = dic[@"title"];
    NSString *updateName = dic[@"updateName"];
    NSString *updateTime = dic[@"updateTime"];
    NSString *urlPrefix = dic[@"urlPrefix"];
    NSString *userId = dic[@"userId"];
    NSString *videoUrlNames = dic[@"videoUrlNames"];
    
    
    
    

    //1.判断数据是否已经存在
    FMResultSet * set = [_dataBase executeQuery:@"select id from arenas where id = ?",idNum];
    [set next];
    NSInteger count = [set intForColumnIndex:0];
    BOOL exist = !!count;
    
    //2.如果已经存在则更新数据
    if(exist) {
        
        BOOL result = [_dataBase executeUpdate:@"UPDATE arenas set content = ?,createName= ?,createTime= ?,createTimeTamp = ?,headUrl = ?,isDelated = ?,labels = ?,nickname = ?,thumbUrl = ?,title = ?,updateName = ?,updateTime = ?,updateTimeTamp = ?,urlPrefix = ?,userId = ?,videoUrlNames = ?,commentCount = ?,voteCount = ?,viewCount = ?,isReader = ? where id = ?"  , content,
                   createName,
                   createTime,
                   createTimeTamp,
                   headUrl,
                   isDelated,
                   labels,
                   nickname,
                   thumbUrl,
                   title,
                   updateName,
                   updateTime,
                   updateTimeTamp,
                   urlPrefix,
                   userId,
                   videoUrlNames,
                   commentCount,
                   voteCount,
                   viewCount,
                   isReader,
                   idNum];
        
        if (result) {
            //            NSLog(@"更新数据成功");
        }else {
            NSLog(@"更新数据失败");
        }
        
    }else {//3.如果数据不存在则插入数据
        BOOL result = [_dataBase executeUpdate:@"INSERT INTO arenas (id,content,createName,createTime,createTimeTamp,headUrl,isDelated,labels,nickname,thumbUrl,title,updateName,updateTime,updateTimeTamp,urlPrefix,userId,videoUrlNames,commentCount,voteCount,viewCount,isReader) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
                       idNum,
                       content,
                       createName,
                       createTime,
                       createTimeTamp,
                       headUrl,
                       isDelated,
                       labels,
                       nickname,
                       thumbUrl,
                       title,
                       updateName,
                       updateTime,
                       updateTimeTamp,
                       urlPrefix,
                       userId,
                       videoUrlNames,
                       commentCount,
                       voteCount,
                       viewCount,
                       isReader
                       ];
        
        if (result) {
            //            NSLog(@"插入数据成功");
        }else {
            NSLog(@"插入数据失败");
        }
    }
}

/**
 * @brief 查询arenas表所有字段
 * @param 分页查询页数，因为服务器端第一页从1开始，所以在sql中先减去1
 *
 */
-(NSMutableArray *) searchArenasWithPage:(NSInteger )currentPage {
    NSLog(@"currentPage:%ld",(long)currentPage);
    if (currentPage <=1) {
        currentPage = 0;
    }else {
        currentPage --;
    }
    NSNumber *pageNum = [NSNumber numberWithInteger:currentPage*20];
    FMResultSet * rs;
    rs = [_dataBase executeQuery:@" SELECT *  FROM arenas  ORDER BY id DESC limit ?,10",pageNum];
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    while ([rs next]) {
        FTArenaBean *bean = [[FTArenaBean alloc]init];
        bean.postsId = [rs stringForColumn:@"id"];
        bean.content = [rs stringForColumn:@"content"];
        bean.createName = [rs stringForColumn:@"createName"];
        bean.createTime = [rs stringForColumn:@"createTime"];
        bean.createTimeTamp = [rs stringForColumn:@"createTimeTamp"];
        bean.headUrl = [rs stringForColumn:@"headUrl"];
        bean.isDelated = [rs boolForColumn:@"isDelated"]==1?@"YES":@"NO";
        bean.labels = [rs stringForColumn:@"labels"];
        bean.nickname = [rs stringForColumn:@"nickname"];
        bean.thumbUrl = [rs stringForColumn:@"thumbUrl"];
        bean.title = [rs stringForColumn:@"title"];
        
        bean.updateName = [rs stringForColumn:@"updateName"];
        bean.updateTime = [rs stringForColumn:@"updateTime"];
        bean.updateTimeTamp = [rs stringForColumn:@"updateTimeTamp"];
        
        bean.urlPrefix = [rs stringForColumn:@"urlPrefix"];
        bean.userId = [rs stringForColumn:@"userId"];
        bean.videoUrlNames = [rs stringForColumn:@"videoUrlNames"];
       
        
        bean.commentCount = [rs stringForColumn:@"commentCount"];
        bean.voteCount = [rs stringForColumn:@"voteCount"];
        bean.viewCount = [rs stringForColumn:@"viewCount"];
        bean.isReader = [rs boolForColumn:@"isReader"]==1?@"YES":@"NO";
        [array addObject:bean];
    }
    return array;
}


/**
 * @brief 更新arenas表所有字段
 * @param arenas表主键
 * @param 是否已读字段
 *
 */
- (void) updateArenasById:(NSString *)Id isReader:(BOOL)isReader {
    
    NSNumber * idNum = [NSNumber numberWithLong:[Id integerValue]];
    NSNumber * isreader = [NSNumber numberWithBool:isReader];
    BOOL result = [_dataBase executeUpdate:@"UPDATE arenas set isReader = ? where id = ?" ,isreader, idNum];
    
    if (result) {
//        NSLog(@"更新数据成功");
    }else {
        NSLog(@"更新数据失败");
    }
    
}


@end

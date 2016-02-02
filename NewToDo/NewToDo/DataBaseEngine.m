//
//  DataBaseEngine.m
//  SJMicroBlog
//
//  Created by qingyun on 15/12/28.
//  Copyright © 2015年 iGhibli. All rights reserved.
//

#import "DataBaseEngine.h"
#import "FMDB.h"
#import "NSString+FilePath.h"
#import "Common.h"
#import "ListModel.h"
#import "DetailModel.h"

@implementation DataBaseEngine

+ (void)initialize{
    if (self == [DataBaseEngine self]) {
        //将数据库拷贝到documents下
        [DataBaseEngine copyDatabaseFileToDocuments:kDBFileName];
    }
}

//拷贝数据库文件到Documents下
+ (void)copyDatabaseFileToDocuments:(NSString *)dbName{
    NSString *source = [[NSBundle mainBundle] pathForResource:dbName ofType:nil];
    NSString *toPath = [NSString filePathInDocumentsWithFileName:dbName];
    NSError *error;
    if ([[NSFileManager defaultManager] fileExistsAtPath:toPath]) {
        //没有数据库文件才copy
        return;
    }
    [[NSFileManager defaultManager] copyItemAtPath:source toPath:toPath error:&error];
    if (error) {
        NSLog(@"Copy数据库文件失败！");
    }
}


+ (NSMutableArray *)getListModelsFromDBTable {
    //创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:[NSString filePathInDocumentsWithFileName:kDBFileName]];
    //打开数据库
    [db open];
    //查询语句
    NSString *sqlString = [NSString stringWithFormat:@"select * from %@ ;",kListinfo];
    //查询并输出结果
    FMResultSet *result = [db executeQuery:sqlString];
    NSMutableArray *listModelArray = [NSMutableArray array];
    while ([result next]) {
        //将一条记录转化为一个字典
        NSDictionary *dict = [result resultDictionary];
        ListModel *model = [[ListModel alloc]initListModelWithDict:dict];
        [listModelArray addObject:model];
    }
    [db close];
    return listModelArray;
}

+ (void)saveListToListTable:(NSDictionary *)dict {
    NSString *SQLStr = [NSString stringWithFormat:@"CREATE TABLE A%@ (\"id\" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , \"sort\" INTEGER, \"detailsortid\" INTEGER, \"detailsort\" , \"ischeck\" )",dict[@"sort"]];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[NSString filePathInDocumentsWithFileName:kDBFileName]];
    [queue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:@"insert into listinfo(name ,image ,sort ,adress) values(:name ,:image ,:sort ,:adress) " withParameterDictionary:dict];
        BOOL success = [db executeUpdate:SQLStr];
        NSLog(@"%d",result);
        NSLog(@"%d",success);
    }];
}

+ (void)deleteListFromListTableWithSort:(NSInteger)sort
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[NSString filePathInDocumentsWithFileName:kDBFileName]];
    [queue inDatabase:^(FMDatabase *db) {
        NSString *SQLString = [NSString stringWithFormat:@"delete from listinfo where sort = %ld;",(long)sort];
        BOOL result = [db executeUpdate:SQLString];
        NSLog(@"%d>>>>%@",result, SQLString);
    }];
}

+ (NSMutableArray *)getDetailModelsFromTable:(NSInteger)tableName WithSortIndex:(NSInteger)sort
{
    FMDatabase *db = [FMDatabase databaseWithPath:[NSString filePathInDocumentsWithFileName:kDBFileName]];
    [db open];
    NSString *sqlString = [NSString stringWithFormat:@"select * from A%ld where sort = %ld ORDER by detailsortid ASC;",(long)tableName ,(long)sort];
    FMResultSet *result = [db executeQuery:sqlString];
    NSMutableArray *modelArray = [NSMutableArray array];
    while ([result next]) {
        NSDictionary *dict = [result resultDictionary];
        DetailModel *model = [[DetailModel alloc]initDetailModelWithDict:dict];
        [modelArray addObject:model];
    }
    [db close];
    return modelArray;
}


+ (ListModel *)getListModelWithListSort:(int)sort {
    FMDatabase *db = [FMDatabase databaseWithPath:[NSString filePathInDocumentsWithFileName:kDBFileName]];
    [db open];
    NSString *sqlString = [NSString stringWithFormat:@"select * from listinfo where sort = %d;",sort];
    FMResultSet *result = [db executeQuery:sqlString];
    NSMutableArray *modelArray = [NSMutableArray array];
    while ([result next]) {
        NSDictionary *dict = [result resultDictionary];
        ListModel *listModel = [[ListModel alloc] initListModelWithDict:dict];
        [modelArray addObject:listModel];
    }
    [db close];
    return modelArray.firstObject;
}

+ (void)updataListWithInfoDict:(NSDictionary *)dict
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[NSString filePathInDocumentsWithFileName:kDBFileName]];
    [queue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:@"update listinfo SET name=:name ,image=:image ,sort=:sort ,adress=:adress where sort=:sort;" withParameterDictionary:dict];
        NSLog(@"%d",result);
    }];
}

+ (void)saveDetailToTableWithDetailDict:(NSDictionary *)dict
{
    NSString *SQLStr = [NSString stringWithFormat:@"insert into A%@(sort, detailsortid, detailsort, ischeck) VALUES(%@, %@, '%@', %@);",dict[@"id"] ,dict[@"sort"] ,dict[@"detailsortid"] ,dict[@"detailsort"] ,dict[@"ischeck"]];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[NSString filePathInDocumentsWithFileName:kDBFileName]];
    [queue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:SQLStr];
        NSLog(@"%d",result);
    }];
}

+ (void)deleteDetailFromTable:(NSInteger)tableName WithDetailSortID:(NSInteger)ID {
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[NSString filePathInDocumentsWithFileName:kDBFileName]];
    [queue inDatabase:^(FMDatabase *db) {
        NSString *SQLString = [NSString stringWithFormat:@"delete from A%ld where detailsortid = %ld;",(long)tableName ,ID];
        BOOL result = [db executeUpdate:SQLString];
        NSLog(@"%d>>>>%@",result, SQLString);
    }];
}

#if 0




//查询出两个数组中共有的方法（处理表的所有字段与有效字段的交集）
+(NSArray *)contenKeyWith:(NSArray *)key1 key2:(NSArray *)key2{
    NSMutableArray *result = [NSMutableArray array];
    
    [key1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = obj;
        //比较一个对象是否包含在另外的一个数组中
        if ([key2 containsObject:key]) {
            [result addObject:key];
        }
    }];
    return result;
}

//根据table和字典共有的key，拼接出sql语句
+(NSString *)sqlStringWithKeys:(NSArray *)keys{
    //创建字段的sql语句部分
    NSString *colume = [keys componentsJoinedByString:@", "];
    //占位部分sql语句部分
    NSString *values = [keys componentsJoinedByString:@", :"];
    values = [@":" stringByAppendingString:values];
    
    return [NSString stringWithFormat:@"insert into status(%@) values(%@)",colume,values];
}







+ (NSMutableArray *)getCityAndCountryFromDBTableWithName:(NSString *)name
{
    //创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:[NSString filePathInDocumentsWithFileName:kDBFileName]];
    //打开数据库
    [db open];
    //查询语句
//    NSString *sqlString = [NSString stringWithFormat:];
    //查询并输出结果
    FMResultSet *result = [db executeQuery:@"select name_cn from ? where Rtrim(name_cn) LIKE '%?%'",kCity ,name];
    NSMutableArray *strArray = [NSMutableArray array];
    while ([result next]) {
        NSString *str = [result stringForColumn:0];
        [strArray addObject:str];
    }
    //释放资源
    [db close];
    return strArray;
}



+ (NSMutableArray *)getItermModelsFromDBTableWithFenleiid:(NSInteger)index
{
    //创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:[NSString filePathInDocumentsWithFileName:kDBFileName]];
    //打开数据库
    [db open];
    //查询语句
    NSString *sqlString = [NSString stringWithFormat:@"select * from %@ where fenleiid = %d;",kFenLeiAndIterm ,index];
    //查询并输出结果
    FMResultSet *result = [db executeQuery:sqlString];
    NSMutableArray *modelArray = [NSMutableArray array];
    while ([result next]) {
        //将一条记录转化为一个字典
        NSDictionary *dict = [result resultDictionary];
        ItermModel *model = [[ItermModel alloc]initItermModelWithDict:dict];
        [modelArray addObject:model];
    }
    //释放资源
    [db close];
    
    return modelArray;
}
#endif

@end

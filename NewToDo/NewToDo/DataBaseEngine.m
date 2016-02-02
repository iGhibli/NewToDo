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

+ (void)updateDetailCheck:(NSInteger)ischeck ToTable:(NSInteger)tableName WithID:(NSInteger)ID {
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[NSString filePathInDocumentsWithFileName:kDBFileName]];
    [queue inDatabase:^(FMDatabase *db) {
        NSString *SQLString = [NSString stringWithFormat:@"update A%ld SET ischeck = %ld where id = %ld;",(long)tableName ,(long)ischeck ,ID];
        BOOL result = [db executeUpdate:SQLString];
        NSLog(@"%d>>>>%@",result, SQLString);
    }];
}

@end

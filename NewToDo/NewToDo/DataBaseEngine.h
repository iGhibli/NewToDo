//
//  DataBaseEngine.h
//  SJMicroBlog
//
//  Created by qingyun on 15/12/28.
//  Copyright © 2015年 iGhibli. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ListModel;
@interface DataBaseEngine : NSObject

+ (void)saveListToListTable:(NSDictionary *)dict;

+ (void)saveDetailToTableWithDetailDict:(NSDictionary *)dict;

+ (ListModel *)getListModelWithListSort:(int)sort;

+ (NSMutableArray *)getListModelsFromDBTable;

+ (NSMutableArray *)getDetailModelsFromTable:(NSInteger)tableName WithSortIndex:(NSInteger)sort;

+ (NSMutableArray *)getCityAndCountryFromDBTableWithName:(NSString *)name;

+ (void)deleteListFromListTableWithSort:(NSInteger)sort;

+ (void)updataListWithInfoDict:(NSDictionary *)dict;

+ (NSMutableArray *)getItermModelsFromDBTableWithFenleiid:(NSInteger)index;

+ (void)deleteDetailFromTable:(NSInteger)tableName WithDetailSortID:(NSInteger)ID;

+ (void)updateDetailCheck:(NSInteger)ischeck ToTable:(NSInteger)tableName WithID:(NSInteger)ID;

@end

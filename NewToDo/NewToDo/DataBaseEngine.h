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

+ (ListModel *)getListModelWithListSort:(int)sort;

+ (NSMutableArray *)getListModelsFromDBTable;

+ (NSMutableArray *)getDetailModelsFromTable:(NSInteger)tableName With:(NSInteger)sort;

+ (NSMutableArray *)getCityAndCountryFromDBTableWithName:(NSString *)name;

+ (void)deleteListFromListTableWithSort:(NSInteger)sort;

+ (void)updataTraveListWithInfoDict:(NSDictionary *)dict;

+ (NSMutableArray *)getItermModelsFromDBTableWithFenleiid:(NSInteger)index;

@end

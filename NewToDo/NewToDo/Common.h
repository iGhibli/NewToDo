//
//  Common.h
//  ToDo
//
//  Created by qingyun on 16/1/28.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#ifndef Common_h
#define Common_h

/*  Size  */
#define kScreenW    [UIScreen mainScreen].bounds.size.width
#define kScreenH    [UIScreen mainScreen].bounds.size.height
#define kScreenB    [UIScreen mainScreen].bounds

/*  DBTableName  */
#define kDBFileName                 @"ToDo.sqlite"          //数据库文件名
#define kListinfo                   @"listinfo"             //清单列表
#define kSort                       @"sort"                 //分类列表
#define kBackup                     @"backup"               //备份列表格式

/*  ListModel  */
#define kName       @"name"
#define kIcon       @"image"
#define kSort       @"sort"
#define kAdress     @"adress"
#define kID         @"id"

/*  DetailModel  */
#define kID                 @"id"
#define kSort               @"sort"
#define kDetailsortid       @"detailsortid"
#define kDetailsort         @"detailsort"
#define kIscheck            @"ischeck"

#endif /* Common_h */

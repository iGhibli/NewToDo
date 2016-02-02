//
//  DetailModel.h
//  NewToDo
//
//  Created by qingyun on 16/2/2.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailModel : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, strong) NSString *detailsortid;
@property (nonatomic, strong) NSString *detailsort;
@property (nonatomic, strong) NSString *ischeck;

- (instancetype)initDetailModelWithDict:(NSDictionary *)dict;

@end

//
//  DetailModel.m
//  NewToDo
//
//  Created by qingyun on 16/2/2.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "DetailModel.h"
#import "Common.h"

@implementation DetailModel

- (instancetype)initDetailModelWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.ID = dict[kID];
        self.sort = dict[kSort];
        self.detailsortid = dict[kDetailsortid];
        self.detailsort = dict[kDetailsort];
        self.ischeck = dict[kIscheck];
    }
    return self;
}

@end

//
//  ListModel.m
//  NewToDo
//
//  Created by qingyun on 16/2/2.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "ListModel.h"
#import "Common.h"

@implementation ListModel

- (instancetype)initListModelWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.name = dict[kName];
        self.icon = dict[kIcon];
        self.sort = dict[kSort];
        self.adress = dict[kAdress];
        self.ID = dict[kID];
    }
    return self;
}

@end

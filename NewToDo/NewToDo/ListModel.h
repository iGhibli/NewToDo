//
//  ListModel.h
//  NewToDo
//
//  Created by qingyun on 16/2/2.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ListModel : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *adress;
@property (nonatomic, strong) NSData *icon;

- (instancetype)initListModelWithDict:(NSDictionary *)dict;

@end

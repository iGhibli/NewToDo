//
//  ListCell.h
//  NewToDo
//
//  Created by qingyun on 16/2/2.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ListModel;
@interface ListCell : UITableViewCell

- (void)bindingListCellWithListModel:(ListModel *)model;

@end

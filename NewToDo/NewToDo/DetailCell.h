//
//  DetailCell.h
//  NewToDo
//
//  Created by qingyun on 16/2/2.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailModel;
@interface DetailCell : UITableViewCell

- (void)bandingDetailCellWithModel:(DetailModel *)model;

@end

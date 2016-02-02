//
//  DetailHeader.h
//  NewToDo
//
//  Created by qingyun on 16/2/2.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailHeader : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (void)bindingDetailHeaderViewWithText:(NSString *)str AndImage:(UIImage *)image;

@end

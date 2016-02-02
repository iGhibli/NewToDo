//
//  DetailHeader.m
//  NewToDo
//
//  Created by qingyun on 16/2/2.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "DetailHeader.h"

@implementation DetailHeader

- (void)bindingDetailHeaderViewWithText:(NSString *)str AndImage:(UIImage *)image {
    self.imageView.image = image;
    self.label.text = str;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

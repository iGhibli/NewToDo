//
//  ListCell.m
//  NewToDo
//
//  Created by qingyun on 16/2/2.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "ListCell.h"
#import "ListModel.h"

@interface ListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *adress;
@end

@implementation ListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)bindingListCellWithListModel:(ListModel *)model {
    self.icon.layer.cornerRadius = 25;
    self.icon.clipsToBounds = YES;
    self.icon.image = [UIImage imageWithData:(NSData *)model.icon];
    self.name.text = model.name;
    self.adress.text = model.adress;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

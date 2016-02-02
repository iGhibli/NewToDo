//
//  DetailCell.m
//  NewToDo
//
//  Created by qingyun on 16/2/2.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "DetailCell.h"
#import "DetailModel.h"

@interface DetailCell ()
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end
@implementation DetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)bandingDetailCellWithModel:(DetailModel *)model {
    self.checkBtn.selected = [model.ischeck boolValue];
    self.detailLabel.text = model.detailsort;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

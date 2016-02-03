//
//  AddDetailVC.m
//  NewToDo
//
//  Created by qingyun on 16/2/2.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "AddDetailVC.h"
#import "Common.h"
#import "DataBaseEngine.h"
#import "DetailModel.h"

@interface AddDetailVC ()<UIPickerViewDataSource ,UIPickerViewDelegate ,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UITextField *textField;
//@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *imageNames;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation AddDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.picker.delegate = self;
    self.picker.dataSource = self;
//    self.dataSource = @[@"行前事项" ,@"购物清单" ,@"文件/备份" ,@"资金" ,@"服装" ,@"个护/化妆" ,@"医疗/健康" ,@"电子数码" ,@"杂项" ,@"旅途备忘" ,@"自定义"];
    self.imageNames = @[@"0" ,@"1" ,@"2" ,@"3" ,@"4" ,@"5" ,@"6" ,@"7" ,@"8" ,@"9" ,@"10"];
    _currentIndex = 0;
    self.textField.delegate = self;
}

- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveBtnAction:(UIButton *)sender {
    if (self.textField.text.length != 0) {
        NSArray *tempArray = [DataBaseEngine getDetailModelsFromTable:self.sort WithSortIndex:_currentIndex];
        DetailModel *model = tempArray.lastObject;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@(self.sort) forKey:@"id"];
        [dict setObject:@(_currentIndex) forKey:@"sort"];
        [dict setObject:self.textField.text forKey:@"detailsort"];
        [dict setObject:@([model.detailsortid intValue] + 1) forKey:@"detailsortid"];
        [dict setObject:@(0) forKey:@"ischeck"];
        [DataBaseEngine saveDetailToTableWithDetailDict:dict];
    }else {
        UILabel *popLabel = [[UILabel alloc]init];
        popLabel.bounds = CGRectMake(0, 0, 200, 50);
        popLabel.center = CGPointMake(kScreenW / 2, kScreenH / 2);
        popLabel.layer.cornerRadius = 10;
        popLabel.clipsToBounds = YES;
        popLabel.text = @"请填写清单名称";
        popLabel.font = [UIFont systemFontOfSize:14];
        popLabel.textAlignment = NSTextAlignmentCenter;
        popLabel.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:popLabel];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:popLabel selector:@selector(removeFromSuperview) userInfo:nil repeats:NO];
    }
}

//取消输入第一响应
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    return YES;
}

#pragma mark -UIPickerViewDataSource
//设置列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//每列中的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.imageNames.count;
}

#pragma mark -UIPickerViewDelegate
////设置文本
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    return self.imageNames[row];
//}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.imageNames[row]]];
    return imageView;
}

////设置属性文本
//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    if (row == 0) {
//        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self.dataSource[row] attributes:@{NSUnderlineStyleAttributeName:@1,NSForegroundColorAttributeName:[UIColor redColor]}];
//        return attributedString;
//    }
//    return nil;
//    
//}

//设置行高
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 60;
}

//选中row
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _currentIndex = row;
}

@end

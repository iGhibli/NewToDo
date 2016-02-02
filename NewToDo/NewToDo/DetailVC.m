//
//  DetailVC.m
//  NewToDo
//
//  Created by qingyun on 16/2/2.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "DetailVC.h"
#import "DataBaseEngine.h"
#import "DetailModel.h"
#import "DetailCell.h"
#import "Common.h"
#import "ChangInfoVC.h"

@interface DetailVC ()<UITableViewDataSource ,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *twoDimensionArray;

@end

@implementation DetailVC
static NSString *detailCellID = @"DetailCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)changeShowAction:(UIButton *)sender
{
    sender.selected = sender.selected ? NO : YES;
}

- (NSArray *)twoDimensionArray {
    if (_twoDimensionArray == nil) {
        _twoDimensionArray = [NSMutableArray array];
        for (int i = 0; i < 11; i++) {
            NSArray *tempArray = [NSArray array];
            tempArray = [DataBaseEngine getDetailModelsFromTable:self.sort With:i];
            if (tempArray.count != 0) {
                [_twoDimensionArray addObject:tempArray];
            }
        }
    }
    return _twoDimensionArray;
}

#pragma mark - ButtonAction
- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sortShowAction:(UIButton *)sender {
    sender.selected = sender.selected ? NO:YES;
}

- (IBAction)addCustomAction:(UIButton *)sender {
    
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.twoDimensionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.twoDimensionArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCellID forIndexPath:indexPath];
    DetailModel *model = self.twoDimensionArray[indexPath.section][indexPath.row];
    [cell bandingDetailCellWithModel:model];
    return cell;
}

#pragma mark - SectionHeader
//section头标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    DetailModel *model = self.twoDimensionArray[section][0];
    NSArray *sortNames = @[@"行前事项" ,@"购物清单" ,@"文件/备份" ,@"资金" ,@"服装" ,@"个护/化妆" ,@"医疗/健康" ,@"电子数码" ,@"杂项" ,@"旅途备忘" ,@"自定义"];
    return sortNames[[model.sort intValue]];
}

//section头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

#pragma mark - PushSegue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: @"changeListInfoSegue"]) {
        [segue.destinationViewController setValue:@(self.sort) forKey:@"sort"];
    }else if ([segue.identifier isEqualToString:@"librarySegue"]) {
        [segue.destinationViewController setValue:@(self.sort) forKey:@"sort"];
    }
    
}

@end

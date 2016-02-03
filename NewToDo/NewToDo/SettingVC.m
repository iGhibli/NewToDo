//
//  SettingVC.m
//  NewToDo
//
//  Created by qingyun on 16/2/3.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "SettingVC.h"
#import "Common.h"

@interface SettingVC ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIView *aboutView;
@property (nonatomic, strong) NSArray *source;
@end

@implementation SettingVC
static NSString *SettingCellID = @"SettingCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    _source = @[@[@"建议反馈" ,@"支持鼓励" ,@"关于ToDo"],
                @[@"当前版本：1.0"]];
}

- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)aboutView {
    if (_aboutView == nil) {
        _aboutView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _aboutView.backgroundColor = [UIColor grayColor];
        _aboutView.alpha = 0.98;
        
        UILabel *author = [[UILabel alloc]initWithFrame:CGRectMake(10, kScreenH / 2 - 100, kScreenW - 20, 30)];
        author.text = @"Author: iGhibli";
        author.font = [UIFont systemFontOfSize:22];
        author.textAlignment = NSTextAlignmentCenter;
        [_aboutView addSubview:author];
        
        UIButton *emailBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, kScreenH / 2 - 65, kScreenW - 20, 30)];
        [emailBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [emailBtn setTitle:@"Email: iGhibli@163.com" forState:UIControlStateNormal];
        [emailBtn addTarget:self action:@selector(sendEmailToMe) forControlEvents:UIControlEventTouchUpInside];
        [_aboutView addSubview:emailBtn];
        
        UILabel *version = [[UILabel alloc]initWithFrame:CGRectMake(10, kScreenH / 2 - 30, kScreenW - 20, 30)];
        version.text = @"Version: 1.0";
        version.font = [UIFont systemFontOfSize:16];
        version.textAlignment = NSTextAlignmentCenter;
        [_aboutView addSubview:version];
        UILabel *thanks = [[UILabel alloc]initWithFrame:CGRectMake(10, kScreenH / 2 + 5, kScreenW - 20, 30)];
        thanks.text = @"^_^ 谢谢使用 ^_^";
        
        thanks.textAlignment = NSTextAlignmentCenter;
        [_aboutView addSubview:thanks];
        
        UIButton *cancel = [[UIButton alloc]init];
        cancel.center = CGPointMake(kScreenW / 2, kScreenH - 95);
        cancel.bounds = CGRectMake(0, 0, 40, 40);
        [cancel setImage:[UIImage imageNamed:@"btn-cancel-1"] forState:UIControlStateNormal];
        [cancel setImage:[UIImage imageNamed:@"btn-cancel-2"] forState:UIControlStateHighlighted];
        [cancel addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
        [_aboutView addSubview:cancel];
    }
    return _aboutView;
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.source.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.source[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SettingCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 1) {
        cell.textLabel.text = self.source[indexPath.section][indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.backgroundColor = [UIColor colorWithRed:199.f/255.f green:155.f/255.f blue:116.f/255.f alpha:1.f];
        return cell;
    }
    cell.textLabel.text = self.source[indexPath.section][indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = [UIColor blueColor];
    cell.backgroundColor = [UIColor colorWithRed:199.f/255.f green:155.f/255.f blue:116.f/255.f alpha:1.f];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self sendEmailToMe];
    }else if (indexPath.section == 0 && indexPath.row == 1) {
        [self goodAction];
    }else if (indexPath.section == 0 && indexPath.row == 2) {
        [self aboutAction];
    }
}

- (void)aboutAction {
    [self.view addSubview:self.aboutView];
}

- (void)sendEmailToMe
{
    NSMutableString *mailUrl = [[NSMutableString alloc]init];
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject: @"iGhibli@163.com"];
    [mailUrl appendFormat:@"mailto:%@", [toRecipients componentsJoinedByString:@","]];
    //添加抄送
    NSArray *ccRecipients = [NSArray arrayWithObjects:@"iGhibli@163.com", nil];
    [mailUrl appendFormat:@"?cc=%@", [ccRecipients componentsJoinedByString:@","]];
    //添加密送
    NSArray *bccRecipients = [NSArray arrayWithObjects:@"iGhibli@163.com", nil];
    [mailUrl appendFormat:@"&bcc=%@", [bccRecipients componentsJoinedByString:@","]];
    //添加主题
    [mailUrl appendString:@"&subject=关于ToDo的建议和反馈。"];
    //添加邮件内容
    [mailUrl appendString:@"&body=<b>ToDo,让生活更从容！</b> 您有什么建议或疑惑，请在这里写下并发送给我，我将随时为您解答！"];
    NSString* email = [mailUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];
}

- (void)goodAction {
    //跳转到AppStore当前应用界面
    //当前应用的AppID
    int myAPPID = 1080990671;
    NSString *str = [NSString stringWithFormat:
                     @"itms-apps://itunes.apple.com/cn/app/todo/id%d?mt=8",
                     myAPPID ];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)hiddenView
{
    [self.aboutView removeFromSuperview];
}

@end

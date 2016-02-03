//
//  ChangInfoVC.m
//  NewToDo
//
//  Created by qingyun on 16/2/2.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "ChangInfoVC.h"
#import "ListModel.h"
#import "DataBaseEngine.h"
#import "Common.h"

@interface ChangInfoVC ()<UINavigationControllerDelegate ,UIImagePickerControllerDelegate ,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *adress;
@property (nonatomic, strong) UIImage *selectImage;
@property (nonatomic, strong) ListModel *currentModel;
@end

@implementation ChangInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentModel = [DataBaseEngine getListModelWithListSort:self.sort];
    [_imageBtn setBackgroundImage:[UIImage imageWithData:(NSData *)_currentModel.icon] forState:UIControlStateNormal];
    _name.text = _currentModel.name;
    _adress.text = _currentModel.adress;
    _selectImage = [UIImage imageWithData:(NSData *)_currentModel.icon];
    self.name.delegate = self;
    self.adress.delegate = self;
}
- (IBAction)determineBtnAction:(UIButton *)sender {
    //未填写ListName
    if (self.name.text.length == 0) {
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
        return;
    }
    //未填写ListAdress
    if (self.adress.text.length == 0) {
        UILabel *popLabel = [[UILabel alloc]init];
        popLabel.bounds = CGRectMake(0, 0, 200, 50);
        popLabel.center = CGPointMake(kScreenW / 2, kScreenH / 2);
        popLabel.layer.cornerRadius = 10;
        popLabel.clipsToBounds = YES;
        popLabel.text = @"请填写目的地";
        popLabel.font = [UIFont systemFontOfSize:14];
        popLabel.textAlignment = NSTextAlignmentCenter;
        popLabel.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:popLabel];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:popLabel selector:@selector(removeFromSuperview) userInfo:nil repeats:NO];
        return;
    }
    //都已填写完成
    if (self.name.text.length != 0 && self.adress.text.length != 0) {
        NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];
        if (self.selectImage == nil) {
            self.selectImage = [UIImage imageNamed:@"listPlaceholderImage"];
        }
        NSData *data = UIImagePNGRepresentation(self.selectImage);
        [infoDict setValue:data forKey:@"image"];
        [infoDict setValue:_name.text forKey:@"name"];
        [infoDict setValue:_adress.text forKey:@"adress"];
        [infoDict setValue:@(self.sort) forKey:@"sort"];
        [DataBaseEngine updataListWithInfoDict:infoDict];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)imageBtnAction:(UIButton *)sender {
    [self chooseImage];
}

//取消输入第一响应
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self.name resignFirstResponder];
    [self.adress resignFirstResponder];
    return YES;
}

//调用相机和图库
- (void)chooseImage
{
    //创建UIAlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选取照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //创建AlertAction
    UIAlertAction *imageAction = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 跳转相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        // 跳转相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    // 判断是否支持相机，添加对应的Action
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [alertController addAction:imageAction];
        [alertController addAction:photoAction];
        [alertController addAction:cancelAction];
    }
    else {
        [alertController addAction:imageAction];
        [alertController addAction:cancelAction];
    }
    //显示AlertController
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}

#pragma mark - 照片选取代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    self.selectImage = image;
    [self.imageBtn setBackgroundImage:image forState:UIControlStateNormal];
}

@end

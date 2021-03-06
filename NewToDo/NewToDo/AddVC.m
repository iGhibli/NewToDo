//
//  AddVC.m
//  NewToDo
//
//  Created by qingyun on 16/2/2.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "AddVC.h"
#import "Common.h"
#import "DataBaseEngine.h"

@interface AddVC ()<UINavigationControllerDelegate ,UIImagePickerControllerDelegate ,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *adress;
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property (nonatomic, strong) UIImage *selectImage;
@end

@implementation AddVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.name.delegate = self;
    self.adress.delegate = self;
}
- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)imageBtnAction:(UIButton *)sender {
    [self chooseImage];
}
- (IBAction)determineAction:(UIButton *)sender {
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
        [infoDict setValue:@(self.sort + 1) forKey:@"sort"];
        [DataBaseEngine saveListToListTable:infoDict];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//取消输入第一响应
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self.name resignFirstResponder];
    [self.adress resignFirstResponder];
    return YES;
}

//调用图库
- (void)chooseImage
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}

#pragma mark - 照片选取代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    self.selectImage = image;
    [self.imageBtn setBackgroundImage:image forState:UIControlStateNormal];
}

@end

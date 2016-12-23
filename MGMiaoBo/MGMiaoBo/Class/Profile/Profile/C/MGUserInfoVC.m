//
//  MGUserInfoVC.m
//  MGMiaoBo
//
//  Created by ming on 16/9/22.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "MGUserInfoVC.h"
#import "HomeWebVC.h"

@interface MGUserInfoVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userIconView;
/** <#注释#> */
@property (nonatomic,strong) NSIndexPath *indexPath;

@end

@implementation MGUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"用户信息";
    self.userIconView.layer.cornerRadius = self.userIconView.height * 0.5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelagate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        
        case 0:
        {
            [self changeUserImage];
        }
            break;
        case 1:
            if (0 == indexPath.row) {
                [self change:indexPath withTitleStr:@"修改名字"];
            }else if(1 == indexPath.row) {
                [self change:indexPath withTitleStr:@"修改IDX"];
            }else if (2 == indexPath.row) {
                [self change:indexPath withTitleStr:@"修改性别"];
            }else if (3 == indexPath.row) {
                [self change:indexPath withTitleStr:@"修改个性签名"];
            }
            break;
        case 2:
        {
            NSString *urlStr = nil;
            NSString *title = nil;
            if (0 == indexPath.row) {
                urlStr = @"http://live.9158.com/Privilege?useridx=63417164&Random=7";
                title = @"我的头衔";
            }else if (1 == indexPath.row) {
                urlStr = @"http://live.9158.com/Rank/MyLevel?useridx=63417164&chkcode=bec82e95877a865e6c880f307b4c5a06&Random=9";
                title = @"我的等级";
            }
            [self.navigationController pushViewController:[[HomeWebVC alloc] initWithNavigationTitle:title withUrlStr:urlStr] animated:YES];
        }
            break;
        case 3:
        {
            if (0 == indexPath.row) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"实名认证要先绑定手机号喔" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
            }else if (1 == indexPath.row) {
               
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 更换头像
/**
 *  更换头像
 */
- (void)changeUserImage {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请选择照片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    // 相机
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        [self openCamera:UIImagePickerControllerSourceTypeCamera];
    }];
    
    // 相册
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        [self openCamera:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertVC addAction:cameraAction];
    [alertVC addAction:photoAction];
    [alertVC addAction:cancelAction];
    [self.navigationController presentViewController:alertVC animated:YES completion:nil];
}

/**
 *  打开照相机/打开相册
 */
- (void)openCamera:(UIImagePickerControllerSourceType)type{
    if (![UIImagePickerController isSourceTypeAvailable:type]){
        [self showHint:@"Camera不可用"];
        return;
    }
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = type;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    // 1.获取用户选中的图片
    UIImage *selectedImg =  info[UIImagePickerControllerOriginalImage];
    
    // 2.设置图片
    [self.userIconView setImage:selectedImg];
    
    // 3.隐藏当前图片选择控制器
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - 更改
- (void)change:(NSIndexPath *)indexPath withTitleStr:(NSString *)title{
    self.indexPath = indexPath;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView setAlertViewStyle: UIAlertViewStylePlainTextInput];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UITextField *txt = [alertView textFieldAtIndex:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_indexPath];
        cell.detailTextLabel.text = txt.text;
        [self.tableView reloadRowsAtIndexPaths:@[_indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

@end

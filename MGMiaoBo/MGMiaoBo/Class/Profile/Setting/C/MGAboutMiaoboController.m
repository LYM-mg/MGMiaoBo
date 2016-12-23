/*
    @header MGAboutMiaoboController.m
 
    @abstract MGMiaoBo 关于源代码文件的一些基本描述
 
    @author Created by ming on 16/9/12.
 
    @简书：http://www.jianshu.com/users/57b58a39b70e/latest_articles
    @github：https://github.com/LYM-mg
 
   Copyright © 2016年 ming. All rights reserved.
 */

#import "MGAboutMiaoboController.h"

@interface MGAboutMiaoboController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

/** imageView */
@property (nonatomic,weak) UIImageView *quarCodeImageView;
@end

@implementation MGAboutMiaoboController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupMainView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UI
- (void)setupMainView{
    UIImageView *quarCodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    quarCodeImageView.image = [UIImage imageNamed:@"download_logo_100x100_"];
    quarCodeImageView.center = self.view.center;
    [self.view addSubview:quarCodeImageView];
    quarCodeImageView.userInteractionEnabled = YES;
    [quarCodeImageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)]];
    _quarCodeImageView = quarCodeImageView;
    
    // 导航栏右边按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(photoItemClick:)];
}


- (void)longPress:(UILongPressGestureRecognizer *)longPress {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *phoneAction = [UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDestructive  handler:^(UIAlertAction * _Nonnull action) {
        [self saveImage];
    }];
    UIAlertAction *recognitionAction = [UIAlertAction actionWithTitle:@"识别图片中的二维码" style:UIAlertActionStyleDestructive  handler:^(UIAlertAction * _Nonnull action) {
        [self getQRCodeInfo:_quarCodeImageView.image];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    [alertVC addAction:phoneAction];
    [alertVC addAction:recognitionAction];
    [alertVC addAction:cancelAction];
    [self.navigationController presentViewController:alertVC animated:YES completion:nil];

}

/// 点击导航栏右边照片的操作 (识别图片中的二维码)
- (void)photoItemClick:(id)sender {
    // 1.判断照片源是否可用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        [self showHint:@"照片库不可用"];
    }
    
    // 2.创建ipc
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    
    // 3.设置照片源
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    // 4.设置代理
    ipc.delegate = self;
    
    // 5.弹出控制器
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate,UINavigationControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    // 2.识别照片中的二维码的信息
    [self getQRCodeInfo:image];
    
    // 3.退出控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}

/// 取得图片中的信息
- (void)getQRCodeInfo:(UIImage *)image{
    // 1.创建扫描器
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:nil];
    
    // 2.扫描结果
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    
    NSArray *features = [detector featuresInImage:ciImage];
    
    // 3.遍历扫描结果
    for (CIQRCodeFeature *f in features) {
        // 如果是网址就跳转
        if ([f.messageString containsString:@"http://"] || [f.messageString containsString:@"https://"] ) {            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:f.messageString]];
        }else{ // 其他信息 弹框显示
            [self showHint:f.messageString];
        }
    }
}

/**
 *  保存照片
 */
- (void)saveImage {
    UIImageWriteToSavedPhotosAlbum(_quarCodeImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        [self showHint:@"保存失败"];
    } else {
        [self showHint:@"保存成功"];
    }
}
@end

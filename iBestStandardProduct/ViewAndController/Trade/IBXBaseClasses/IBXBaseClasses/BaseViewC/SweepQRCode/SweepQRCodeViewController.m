//
//  SweepQRCodeViewController.m
//  QRCodeDemo1
//
//  Created by CPZX010 on 16/4/15.
//  Copyright © 2016年 谢昆鹏. All rights reserved.
//

#import "SweepQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "FuzzyViewAndLine.h"
#import <Photos/Photos.h>
#import "UIImage+SGHelper.h"


@interface SweepQRCodeViewController()<AVCaptureMetadataOutputObjectsDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIView *scanRectView;
@property (nonatomic ,strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preView;
@property (nonatomic ,strong) FuzzyViewAndLine *fuzzyView;
@end

@interface SweepQRCodeViewController ()

@end

@implementation SweepQRCodeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self.session startRunning];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = CustomLocalizedString(@"FX_BU_SAOYISAO", nil);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:CustomLocalizedString(@"QCancel", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancleSweep:)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarButtonItenAction)];
    [self sweepView];
}
- (void)cancleSweep :(UIBarButtonItem *)sender {
    if (self.xNavigationcontroller.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    [self.session stopRunning];
}
- (void)sweepView {
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    self.output = [[AVCaptureMetadataOutput alloc]init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:(ScreenHeight<500?AVCaptureSessionPreset640x480:AVCaptureSessionPresetHigh)];
    [self.session addInput:self.input];
    [self.session addOutput:self.output];
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    CGSize windowSize = [UIScreen mainScreen].bounds.size;
    CGSize scanSize = CGSizeMake(windowSize.width*3/4, windowSize.width*3/4);
    CGRect scanRect = CGRectMake(ScreenWidth / 2.0 - scanSize.width / 2.0, ScreenHeight / 2.0 - scanSize.height / 2.0 - 32, scanSize.width, scanSize.height);
#pragma mark    选用
    self.fuzzyView = [[FuzzyViewAndLine alloc] initWithFrame:scanRect];
    [self.view addSubview:self.fuzzyView];
    scanRect = CGRectMake(scanRect.origin.y/windowSize.height, scanRect.origin.x/windowSize.width, scanRect.size.height/windowSize.height,scanRect.size.width/windowSize.width);
    self.output.rectOfInterest = scanRect;
    
    self.scanRectView = [UIView new];
    [self.view addSubview:self.scanRectView];
    self.scanRectView.frame = CGRectMake(0, 0, scanSize.width, scanSize.height);
    self.scanRectView.center = CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), CGRectGetMidY([UIScreen mainScreen].bounds) - 32);
    //    self.scanRectView.layer.borderColor = [UIColor purpleColor].CGColor;
    self.scanRectView.layer.borderWidth = 1;
    self.output.rectOfInterest = scanRect;
    self.preView = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preView.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preView.frame = [UIScreen mainScreen].bounds;
    [self.view.layer insertSublayer:self.preView atIndex:0];

}
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    AudioServicesPlaySystemSound(1305);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    if (metadataObjects.count == 0) {
        return;
    }
    if (metadataObjects.count > 0) {
        [self.session stopRunning];
        AVMetadataMachineReadableCodeObject *currentMetadataObject = metadataObjects.firstObject;
        NSString *qrCodeString = currentMetadataObject.stringValue;
#pragma mark    两种方案1:拿到字符串直接做相应处理;2:dismiss到上一界面做相应处理
        if (1) {
             self.qrCodeBlock(qrCodeString);
            [self dismissViewControllerAnimated:NO completion:nil];
        }else {
            //直接拿到字符串做相应处理
        }
    }
}

- (void)getBlockFromOutSide:(GetQRCodeStringSuccess)qrCodeBlock {
    if (qrCodeBlock) {
        self.qrCodeBlock = qrCodeBlock;
    }
}


#pragma mark    读取相册二维码
- (void)rightBarButtonItenAction {
    [self readImageFromAlbum];
    [self.session stopRunning];
//    [self.fuzzyView removeFromSuperview];
}



- (void)readImageFromAlbum {
    
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        // 判断授权状态
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusNotDetermined) { // 用户还没有做出选择
            // 弹框请求用户授权
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) { // 用户第一次同意了访问相册权限
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; //（选择类型）表示仅仅从相册中选取照片
                        imagePicker.delegate = self;
                        [self presentViewController:imagePicker animated:YES completion:nil];
                    });
                } else { // 用户第一次拒绝了访问相机权限
                    
                }
            }];
        } else if (status == PHAuthorizationStatusAuthorized) { // 用户允许当前应用访问相册
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; //（选择类型）表示仅仅从相册中选取照片
            imagePicker.delegate = self;
            [self presentViewController:imagePicker animated:YES completion:nil];
            
        } else if (status == PHAuthorizationStatusDenied) { // 用户拒绝当前应用访问相册
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:CustomLocalizedString(@"MINEJINGGAO", nil) message:CustomLocalizedString(@"FX_BU_QINGQUSHEZHIDAKAIFANGWENKAIGUAN", nil) preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:CustomLocalizedString(@"QOK", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
        } else if (status == PHAuthorizationStatusRestricted) {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:CustomLocalizedString(@"MINEWENXINTISHI", nil) message:CustomLocalizedString(@"FX_BU_YOUYUXITONGYUANYINWUFAFANGWENXIANGCE", nil) preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:CustomLocalizedString(@"QOK", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
        }
    }
}
#pragma mark - - - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self dismissViewControllerAnimated:YES completion:^{
        [self scanQRCodeFromPhotosInTheAlbum:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    }];
}

#pragma mark - - - 从相册中识别二维码, 并进行界面跳转
- (void)scanQRCodeFromPhotosInTheAlbum:(UIImage *)image {
    // 对选取照片的处理，如果选取的图片尺寸过大，则压缩选取图片，否则不作处理
    image = [UIImage imageSizeWithScreenImage:image];
    
    // CIDetector(CIDetector可用于人脸识别)进行图片解析，从而使我们可以便捷的从相册中获取到二维码
    // 声明一个CIDetector，并设定识别类型 CIDetectorTypeQRCode
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    
    // 取得识别结果
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    for (int index = 0; index < [features count]; index ++) {
        CIQRCodeFeature *feature = [features objectAtIndex:index];
        NSString *scannedResult = feature.messageString;
        //SGQRCodeLog(@"scannedResult - - %@", scannedResult);
        // 在此发通知，告诉子类二维码数据
        if (self.qrCodeBlock) {
            self.qrCodeBlock(scannedResult);
            [self cancleSweep:nil];
        }
    }
}








- (void)dealloc {
    [self.fuzzyView removeFromSuperview];
    self.fuzzyView = nil;
    NSLog(@"[%@----------------dealloc]", self.class);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

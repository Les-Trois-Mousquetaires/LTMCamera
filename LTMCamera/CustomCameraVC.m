//
//  CustomCameraVC.m
//  LTMCamera
//
//  Created by 柯南 on 2020/9/28.
//

#import "CustomCameraVC.h"

#import <AVFoundation/AVFoundation.h>

#import <Masonry/Masonry.h>
#import "ImageDealVC.h"

typedef void (^PermissionBlock)(BOOL result);

@interface CustomCameraVC ()<AVCapturePhotoCaptureDelegate>

@property(nonatomic,assign) BOOL statusHiden;
/// 设备
@property (strong, nonatomic) AVCaptureDevice *device;
/// 输入设备
@property (strong, nonatomic) AVCaptureDeviceInput *input;
/// 当启动摄像机开始捕获输入
@property (strong, nonatomic) AVCaptureMetadataOutput *output;
/// 照片输出流(iOS10之后开始使用,之前采用AVCaptureStillImageOutput)
@property (strong, nonatomic) AVCapturePhotoOutput *imageOutput;

@property (strong, nonatomic) AVCaptureSession *session;
/// 预览 实时显示捕获的图像
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *preview;
/// 拍照按钮
@property (strong, nonatomic) UIButton *takePictureBtn;
/// 聚焦
@property (strong, nonatomic) UIView *focusView;
@end

@implementation CustomCameraVC

- (BOOL)prefersStatusBarHidden{
    return  self.statusHiden;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.statusHiden = true;
    [self openCamera];
    [self loadCustomView];
    [self focusAtPoint:CGPointMake(1, 1)];
}

- (void)openCamera {
    NSLog(@"可以使用相机了");
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    self.input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:nil];
    self.output = [[AVCaptureMetadataOutput alloc]init];
    self.imageOutput = [[AVCapturePhotoOutput alloc]init];
    self.session = [[AVCaptureSession alloc]init];
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]){
        [self.session canSetSessionPreset:AVCaptureSessionPreset1280x720];
    }
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.imageOutput]) {
        [self.session addOutput:self.imageOutput];
    }
    
    self.preview = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.preview.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.preview];
    
    [self.session startRunning];
    /// 修改设备的属性，先加锁
    if ([self.device lockForConfiguration:nil]) {
        /// 白平衡
        if ([self.device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]){
            [self.device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        /// 解锁
        [self.device unlockForConfiguration];
    }
}

- (void)loadCustomView {
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setImage:[UIImage imageNamed:@"CancelImage"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    self.takePictureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.takePictureBtn setImage:[UIImage imageNamed:@"TakePictureImage"] forState:UIControlStateNormal];
    [self.takePictureBtn addTarget:self action:@selector(takePictureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.takePictureBtn];
    
    self.focusView = [[UIView alloc]init];
    self.focusView.layer.borderWidth = 1.0;
    self.focusView.layer.borderColor = [UIColor yellowColor].CGColor;
    [self.view addSubview:self.focusView];
    self.focusView.hidden = YES;
    
    [self.takePictureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-28);
    }];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.takePictureBtn);
        make.left.equalTo(self.view).offset(20);
    }];
    [self.focusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)cancelBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)takePictureBtnClick {
    AVCaptureConnection *videoConnection = [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (videoConnection == nil) {
        return;
    }
    
    AVCapturePhotoSettings *settings = [[AVCapturePhotoSettings alloc]init];
    [self.imageOutput capturePhotoWithSettings:settings delegate:self];
}

- (void)focusGesture:(UITapGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:gesture.view];
    [self focusAtPoint:point];
}

- (void)focusAtPoint:(CGPoint)point{
    CGSize size = self.view.bounds.size;
    // focusPoint 函数后面Point取值范围是取景框左上角（0，0）到取景框右下角（1，1）之间,按这个来但位置就是不对，只能按上面的写法才可以。前面是点击位置的y/PreviewLayer的高度，后面是1-点击位置的x/PreviewLayer的宽度
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1 - point.x/size.width );
    
    if ([self.device lockForConfiguration:nil]) {
        
        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        
        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
            [self.device setExposurePointOfInterest:focusPoint];
            //曝光量调节
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [self.device unlockForConfiguration];
        _focusView.center = point;
        _focusView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                self.focusView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                self.focusView.hidden = YES;
            }];
        }];
    }
}

#pragma mark - AVCapturePhotoCaptureDelegate

- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(NSError *)error API_AVAILABLE(ios(11.0)){
    NSData *data = [photo fileDataRepresentation];
    [self presenToImageDealVC:data];
}

- (void)presenToImageDealVC:(NSData *)data {
    ImageDealVC *dealVC = [[ImageDealVC alloc]init];
    dealVC.modalPresentationStyle = UIModalPresentationFullScreen;
    dealVC.image = [UIImage imageWithData:data];
    [self presentViewController:dealVC animated:true completion:nil];
}

@end

//
//  WZZbarScanController.m
//  chexiaozhen
//
//  Created by songbiwen on 16/6/28.
//  Copyright © 2016年 songbiwen. All rights reserved.
//

#import "WZZbarScanController.h"
#import <AVFoundation/AVFoundation.h>

@interface WZZbarScanController ()
<UIAlertViewDelegate, AVCaptureMetadataOutputObjectsDelegate>

{
     AVCaptureSession * session;//输入输出的中间桥梁
}

//扫描框
@property (weak, nonatomic) IBOutlet UIImageView *scan_imageView;

//扫描条
@property (weak, nonatomic) IBOutlet UIImageView *scanLineImageView;

//扫描条top约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scanLineTopConstraint;

//定时器
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation WZZbarScanController


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(moveUpAndDownLine) userInfo:nil repeats:YES];
    }
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.scan_imageView.layer.borderWidth = 1.0;
    self.scan_imageView.layer.borderColor = [UIColor orangeColor].CGColor;
    self.scanLineTopConstraint.constant = 0;
    
    //如果没获得权限
    NSString *mediaType = AVMediaTypeVideo;
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        
         [[[UIAlertView alloc] initWithTitle:nil message:@"亲,请先到系统“隐私”中打开相机权限哦！" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles:nil, nil] show];
        return;
    }
    else if (authStatus == AVAuthorizationStatusNotDetermined) {
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                //允许
            }else{
                
                [[[UIAlertView alloc] initWithTitle:nil message:@"亲,请先到系统“隐私”中打开相机权限哦！" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles:nil, nil] show];
                return;
                
            }
        }];
    }
    
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:mediaType];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([session canAddInput:input]) {
        [session addInput:input];
    }
    
    if ([session canAddOutput:output]) {
        [session addOutput:output];
    }
    
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
//    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    //设置二维码
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    //添加阅览图层
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    
    //开始捕获
    [session startRunning];
    
    __weak __typeof(self) weakSelf = self;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureInputPortFormatDescriptionDidChangeNotification object:nil queue:[NSOperationQueue currentQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        ////设置扫描输出口的视图捕捉范围
        output.rectOfInterest = [layer metadataOutputRectOfInterestForRect:weakSelf.scan_imageView.frame];
        
//        NSLog(@"%@",NSStringFromCGRect([_layer metadataOutputRectOfInterestForRect:weakSelf.scan_imageView.frame]));
        
    }];
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//最后实现代理方法：
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    NSString *stringValue;
    if ([metadataObjects count] >0){
        //停止扫描
        [session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        
        [[[UIAlertView alloc] initWithTitle:nil message:stringValue delegate:nil cancelButtonTitle:@"完美" otherButtonTitles:nil, nil] show];
        
    }else{
        //扫码失败
        [session startRunning];
        return;
    }
}


// 扫描条上下滚动
- (void)moveUpAndDownLine
{
    
    self.scanLineImageView.hidden = NO;
    __weak __typeof(self) weakSelf = self;
    
    
    [UIView animateWithDuration:0.01
                     animations:^{
                         CGRect frame = weakSelf.scanLineImageView.frame;
                         weakSelf.scanLineTopConstraint.constant += frame.size.height;
                     }
                     completion:^(BOOL finished) {
                         
                         CGFloat constant = weakSelf.scanLineTopConstraint.constant;
                         CGRect frame = weakSelf.scan_imageView.frame;
                         if (constant >= frame.size.height) {
                             constant = 0;
                             weakSelf.scanLineImageView.hidden = YES;
                             weakSelf.scanLineTopConstraint.constant = constant;
                         }
                         
                     }];
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}
@end

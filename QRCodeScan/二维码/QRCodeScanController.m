//
//  QRCodeScanController.m
//  NSThread-GCD-NSOperation
//
//  Created by ios2chen on 2018/9/18.
//  Copyright © 2018年 Lfy. All rights reserved.
//

#import "QRCodeScanController.h"
#import "QRCodeView.h"
#import "QRCodeAnimationView.h"
#import "AlbumPhotoController.h"


@interface QRCodeScanController () <AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PictureChooseProtocol>
@property (weak, nonatomic) IBOutlet UIView *iNavigationView;
@property (nonatomic, strong) QRCodeAnimationView *iAnimateView;
//TODO:二维码
@property (nonatomic, strong) AVCaptureSession *iCaptureSession;
@property (nonatomic, strong) AVCaptureDevice *iCaptureDevice;
@property (nonatomic, strong) AVCaptureDeviceInput *iCaptureInput;
@property (nonatomic, strong) AVCaptureMetadataOutput *iCaptureOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *iCaptureLayer;
@end

@implementation QRCodeScanController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.iNavigationView.frame = CGRectMake(0, 0, UIScreen_Width, UIScreen_StatusHeight+44);
    
    
    if ([DevelopmentUtil cameraAuthorization]) {
        [self origionScan];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请到设置页打开相机权限！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}
#pragma mark -------------------------------------------------------
//TODO:二维码扫描
#pragma mark -------------------------------------------------------

//TODO:原生方法,扫描二维码
-(void)origionScan{
    
    CGFloat focusWidth = 180*(UIScreen_Width/320);
    CGRect focusRect = CGRectMake((UIScreen_Width-focusWidth)/2, (UIScreen_Height-focusWidth)/2, focusWidth, focusWidth);
    
    self.iCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.iCaptureInput = [[AVCaptureDeviceInput alloc]initWithDevice:self.iCaptureDevice error:nil];
    self.iCaptureOutput = [[AVCaptureMetadataOutput alloc]init];
    [self.iCaptureOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    self.iCaptureSession = [[AVCaptureSession alloc]init];
    [self.iCaptureSession setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.iCaptureSession canAddInput:self.iCaptureInput]) {
        [self.iCaptureSession addInput:self.iCaptureInput];
    }
    if ([self.iCaptureSession canAddOutput:self.iCaptureOutput]) {
        [self.iCaptureSession addOutput:self.iCaptureOutput];
    }
    self.iCaptureOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    //设置扫描区域，（y,x,height,width）,坐标是反的，需注意
    self.iCaptureOutput.rectOfInterest = CGRectMake(focusRect.origin.y/UIScreen_Height, focusRect.origin.x/UIScreen_Width, focusWidth/UIScreen_Height, focusWidth/UIScreen_Width);
    
    self.iCaptureLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.iCaptureSession];
    self.iCaptureLayer.frame = [UIScreen mainScreen].bounds;
    [self.iCaptureLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.view.layer insertSublayer:self.iCaptureLayer atIndex:0];
    
    
    QRCodeView *bgView = [[QRCodeView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    bgView.iFocusFrame = focusRect;
    [self.view addSubview:bgView];
    
    self.iAnimateView = [[QRCodeAnimationView alloc]initWithFrame:focusRect];
    [self.view addSubview:self.iAnimateView];
    
    [self.view bringSubviewToFront:self.iNavigationView];
    
    [self.iCaptureSession startRunning];
}

#pragma mark - 相机扫描成功回调
-(void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    
    NSString *resultString;
    if (metadataObjects.count>0) {
        AVMetadataMachineReadableCodeObject *object = metadataObjects.firstObject;
        resultString = object.stringValue;
        NSLog(@"string == %@",resultString);
        [self.iCaptureSession stopRunning];
        [self.iAnimateView stopAnimation];
        
        /*
         *扫码成功，在这里做相应处理
         *
         *下面是示例
         */
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"扫码成功！" message:@"是否继续扫码？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [controller addAction:cancelAction];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.iCaptureSession startRunning];
            [self.iAnimateView startAnimation];
        }];
        [controller addAction:sureAction];
        
        [self presentViewController:controller animated:YES completion:nil];
        
    }else{
        NSLog(@"没有扫描结果");
    }
    
}
- (IBAction)backButtonAction:(id)sender {
    [self.iCaptureSession stopRunning];
    [self.iAnimateView stopAnimation];
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - 扫描相册二维码
- (IBAction)cameraButtonAction:(id)sender {
    
    //[self systemAlbum];//使用系统相册
    
    //TODO:使用自定义相册
    CATransition* transition = [CATransition animation];
    transition.duration = 0.2f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    AlbumPhotoController *albumPhotoVC = [[AlbumPhotoController alloc]init];
    albumPhotoVC.delegate = self;
    
    [self.navigationController pushViewController:albumPhotoVC animated:NO];

    
}

//TODO:---------------  UIImagePickerController系统相册  -----------------
-(void)systemAlbum{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerController.delegate = self;
    [self presentViewController:pickerController animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"info==%@",info);
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self detectorImage:image];
    
    
}

#pragma mark - PictureChooseProtocol
-(void)choosePictureArray:(NSArray *)array{
    
    UIImage *image = [array firstObject];
    [self detectorImage:image];
    
}

-(void)detectorImage:(UIImage *)image{
    
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:nil];
    NSArray *features = [detector featuresInImage:[CIImage imageWithData:UIImagePNGRepresentation(image)]];
    if (features.count>0) {
        CIQRCodeFeature *qrCodeFeature = features[0];
        NSLog(@"result==%@",qrCodeFeature.messageString);
        
        [self.iCaptureSession stopRunning];
        [self.iAnimateView stopAnimation];
        
        /*
         *扫码成功，在这里做相应处理
         *
         *下面是示例
         */
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"扫码成功！" message:@"是否继续扫码？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [controller addAction:cancelAction];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.iCaptureSession startRunning];
            [self.iAnimateView startAnimation];
        }];
        [controller addAction:sureAction];
        
        [self presentViewController:controller animated:YES completion:nil];
        
    } else {
        NSLog(@"没有扫描结果");
    }
    
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

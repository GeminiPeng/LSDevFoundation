//
//  LScanningViewController.m
//  NingxiaInternational
//
//  Created by  tsou117 on 15/6/10.
//  Copyright (c) 2015年  tsou117. All rights reserved.
//

#import "LScanningViewController.h"

@interface LScanningViewController ()

@end

@implementation LScanningViewController
{
    
    UIScrollView* rootView;
    
    AVCaptureDevice* device;
    AVCaptureDeviceInput * input;
    AVCaptureMetadataOutput * output;
    AVCaptureSession * session;
    AVCaptureVideoPreviewLayer * preview;
    
    UIView* _boxView;
    UILabel* _scanLayer;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navTitle = @"扫一扫";
    
    if (session) {
        //
        [session startRunning];
    }

}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    rootView.frame = self.view.bounds;

    preview.frame = rootView.layer.bounds;
    [rootView.layer insertSublayer:preview atIndex:0];
    
    [output setRectOfInterest:CGRectMake (( 124 )/ kSCREEN_HEIGHT ,(( kSCREEN_WIDTH - 220 )/ 2 )/ kSCREEN_WIDTH , 220 / kSCREEN_HEIGHT , 220 / kSCREEN_WIDTH)];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //
    rootView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:rootView];
    
    //
    device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (device == nil) {
        //
        [SVProgressHUD showErrorWithStatus:@"未检测到相机"];
        [self performSelector:@selector(vcback) withObject:nil afterDelay:1.0];
        return;
    }
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        [LSFactory fc_showSysAlertViewWithMsg:@"无法访问到相机"];
    }
    
    
    input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    output = [[ AVCaptureMetadataOutput alloc ] init ];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //
    session = [[ AVCaptureSession alloc ] init ];
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([session canAddInput:input]) {
        //
        [session addInput:input];
    }
    
    if ([session canAddOutput:output]) {
        //
        [session addOutput:output];
    }
    
    //条码类型  AVMetadataObjectTypeQRCode
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    //
    preview = [AVCaptureVideoPreviewLayer layerWithSession:session];
    preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    //10.1.扫描框
    _boxView = [[UIView alloc] initWithFrame:CGRectMake(50, 60, kSCREEN_WIDTH-100, kSCREEN_WIDTH-100)];
    _boxView.layer.borderColor = [UIColor greenColor].CGColor;
    _boxView.layer.borderWidth = 1.0f;
    _boxView.clipsToBounds = YES;
    
    [rootView addSubview:_boxView];

    
    //10.2.扫描线
    _scanLayer = [[UILabel alloc] init];
    _scanLayer.frame = CGRectMake(5, 5, _boxView.frame.size.width-10, 1);
    _scanLayer.backgroundColor = [UIColor greenColor];
    
    [_boxView addSubview:_scanLayer];
    
    [self downAnimate];
    
    //提示 将二维码放到框内即可自动扫描
    UILabel* markLb = [[UILabel alloc] initWithFrame:CGRectMake(0, _boxView.frame.origin.y+_boxView.frame.size.height+40, kSCREEN_WIDTH, 40)];
    markLb.textAlignment = 1;
    markLb.textColor = [UIColor whiteColor];
    markLb.text = @"将二维码放到框内即可自动扫描";
    [rootView addSubview:markLb];
    
    //start
    [session startRunning];
    
}

- (void)upAnimate{
    
    [UIView animateWithDuration:1.5 animations:^{
        //
        
        _scanLayer.frame = CGRectMake(5, 5, _boxView.frame.size.width-10, 1);
        
    } completion:^(BOOL finished) {
        //
        [self downAnimate];
    }];
}
- (void)downAnimate{
    [UIView animateWithDuration:1.5 animations:^{
        //
        
        _scanLayer.frame = CGRectMake(5, _boxView.frame.size.width-5,  _boxView.frame.size.width-10, 1);
        
    } completion:^(BOOL finished) {
        //
        [self upAnimate];
    }];
}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- ( void )captureOutput:( AVCaptureOutput *)captureOutput didOutputMetadataObjects:( NSArray *)metadataObjects fromConnection:( AVCaptureConnection *)connection
{
    NSString *stringValue;
    if ([metadataObjects count ] > 0 )
    {
        // 停止扫描
        [ session stopRunning ];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        stringValue = metadataObject. stringValue;
        
//        LSWebViewController* web_vc = [[LSWebViewController alloc] init];
//        web_vc.urlStr = stringValue;
//        web_vc.defaultTitle = @"扫描结果";
//        [self.navigationController pushViewController:web_vc animated:YES];
        
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

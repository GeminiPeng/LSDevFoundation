//
//  LSMapViewController.m
//  LSDevModel3
//
//  Created by  tsou117 on 16/3/16.
//  Copyright © 2016年 sen. All rights reserved.
//

#import "LSMapViewController.h"
#import <BMKPinAnnotationView.h>
#import <BMKPointAnnotation.h>

@interface LSMapViewController ()
<BMKMapViewDelegate,BMKLocationServiceDelegate>

@end

@implementation LSMapViewController
{
    BMKMapView* _mapview;
    BMKLocationService* _locservice;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navTitle = @"地图";
    _mapview = [[BMKMapView alloc] initWithFrame:CGRectZero];
    _mapview.mapType = BMKMapTypeStandard;
    _mapview.zoomLevel = 16.0f;
    _mapview.backgroundColor = kBGC_contentView;
    self.view = _mapview;
    
    //
    _locservice = [[BMKLocationService alloc] init];
    [_locservice setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [_locservice setDistanceFilter:100.0f];
    [self actionOfRefresh];
    
    //
//    UIBarButtonItem* updatabtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(actionOfRefresh)];
//    self.navigationItem.rightBarButtonItem = updatabtn;
}

- (void)actionOfRefresh{
    //
    [_locservice startUserLocationService];
    _mapview.showsUserLocation = NO;
    _mapview.userTrackingMode = BMKUserTrackingModeFollow;
    _mapview.showsUserLocation = YES;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    _mapview.frame = self.view.bounds;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.closeCebianMoveout = YES;
    self.fullSlidePopBack = NO;
    
    [_mapview viewWillAppear];
    _mapview.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locservice.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_mapview viewWillDisappear];
    _mapview.delegate = nil; // 不用时，置nil
    _locservice.delegate = nil;
}

#pragma mark


#pragma mark 

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    //处理方向变更信息
    [_mapview updateLocationData:userLocation];
}
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    //处理位置坐标更新
    [_mapview updateLocationData:userLocation];
    
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}


- (void)dealloc
{
    if (_mapview) {
        _mapview = nil;
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

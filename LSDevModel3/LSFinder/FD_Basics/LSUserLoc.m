//
//  LSUserLoc.m
//  LSDevModel3
//
//  Created by  tsou117 on 16/5/31.
//  Copyright © 2016年 sen. All rights reserved.
//

#import "LSUserLoc.h"

static LSUserLoc* __loc;


@implementation LSUserLoc
{
    BOOL locSuccess;
}
+ (LSUserLoc* )shareLoc{
    //
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        //
        __loc = [[LSUserLoc alloc] init];

        __loc.myLocservice = [[BMKLocationService alloc] init];
        [__loc.myLocservice setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        [__loc.myLocservice setDistanceFilter:100.0f];
        [__loc.myLocservice startUserLocationService];
    });
    
    return __loc;
}

#pragma mark - 定位

- (void)locStart{
    _myLocservice.delegate = self;
}
- (void)locStop{
    _myLocservice.delegate = nil;
}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    //处理方向变更信息
    //    [_mapview updateLocationData:userLocation];
}
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    //处理位置坐标更新
    //    [_mapview updateLocationData:userLocation];
    if (!locSuccess) {
        locSuccess = YES;
        NSString* userlon = [LSFactory fc_judgeObj:@(userLocation.location.coordinate.longitude) placeholder:@""];
        NSString* userlat = [LSFactory fc_judgeObj:@(userLocation.location.coordinate.latitude) placeholder:@""];
        NSLog(@"userLocation = %@ %@",userlon,userlat);
        
        if (self.blockUserLocSuccess) {
            self.blockUserLocSuccess(userlon,userlat);
        }
        [self locStop];
    }
}
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
    locSuccess = NO;
    if (self.blockUserLocFaiure) {
        self.blockUserLocFaiure(YES);
    }
    [SVProgressHUD showInfoWithStatus:@"无法获取当前位置,请重试"];
    [self locStop];
}












@end


















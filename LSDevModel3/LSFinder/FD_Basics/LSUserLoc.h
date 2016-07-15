//
//  LSUserLoc.h
//  LSDevModel3
//
//  Created by  tsou117 on 16/5/31.
//  Copyright © 2016年 sen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSUserLoc : NSObject
<BMKLocationServiceDelegate>

@property (nonatomic, strong) BMKLocationService* myLocservice;
@property (nonatomic, copy) void (^blockUserLocSuccess)(NSString* userlon, NSString* userlat);
@property (nonatomic, copy) void (^blockUserLocFaiure)(BOOL isfailure);

+ (LSUserLoc* )shareLoc;

- (void)locStart;
- (void)locStop;

@end

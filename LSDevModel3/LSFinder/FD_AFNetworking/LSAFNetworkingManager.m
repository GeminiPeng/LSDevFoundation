//
//  LSAFNetworkingManager.m
//  LSDevModel3
//
//  Created by  tsou117 on 16/2/18.
//  Copyright (c) 2016年 sen. All rights reserved.
//

#import "LSAFNetworkingManager.h"

static LSAFNetworkingManager* __manager = nil;


@implementation LSAFNetworkingManager

+ (instancetype)shareManager{
    //
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        __manager = [[LSAFNetworkingManager alloc] initWithBaseURL:[NSURL URLWithString:kHOST_main]];
        __manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        __manager.securityPolicy.allowInvalidCertificates = YES;
        __manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain",@"text/xml", nil];
    });
    
    //
    NSDictionary *properties = [[NSMutableDictionary alloc] init];
    [properties setValue: @"cookie" forKey:NSHTTPCookieValue];
    [properties setValue: kMark_userCookie forKey:NSHTTPCookieName];
    [properties setValue:@"" forKey:NSHTTPCookieDomain];
    [properties setValue:[NSDate dateWithTimeIntervalSinceNow:60*60] forKey:NSHTTPCookieExpires];
    [properties setValue:@"/" forKey:NSHTTPCookiePath];
    NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:properties];
    NSArray *cookies=[NSArray arrayWithObjects:cookie,nil];
    NSDictionary *headers=[NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    
    [__manager.requestSerializer setValue:[headers objectForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
    
    return __manager;
}

#pragma mark - Cookie


#pragma mark - GET & POST

+ (void)GET:(NSString*)URLString
 parameters:(id)parameters
    success:(void (^)(NSURLSessionDataTask* task, id responseObject))success
    failure:(LSRequestFailure)failure{
    
    NSMutableDictionary* dic;
    if (parameters) {
        NSDictionary* tmp = (NSDictionary*)parameters;
        dic = [NSMutableDictionary dictionaryWithDictionary:tmp];
    }else{
        dic = [NSMutableDictionary dictionary];
    }
    
    [[self shareManager] GET:URLString parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        //
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self logRequestMessageWithUrl:URLString parameters:dic];
        success(task,responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       //
        NSInteger code = error.code;
        if (code == 3840) {
            //
            [SVProgressHUD showErrorWithStatus:@"请求失败(404)"];
        }else{
            if (code != -999) {
                //
                [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            }
        }
        [self logRequestMessageWithUrl:URLString parameters:dic];
        DLog(@"%@",[error localizedDescription]);
        
        failure(YES);
    }];
    
}

+ (void)POST:(NSString*)URLString
 parameters:(id)parameters
    success:(void (^)(NSURLSessionDataTask* task, id responseObject))success
    failure:(LSRequestFailure)failure{
    
    NSMutableDictionary* dic;
    if (parameters) {
        NSDictionary* tmp = (NSDictionary*)parameters;
        dic = [NSMutableDictionary dictionaryWithDictionary:tmp];
    }else{
        dic = [NSMutableDictionary dictionary];
    }

    
    [[self shareManager] POST:URLString parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self logRequestMessageWithUrl:URLString parameters:dic];
        success(task,responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        NSInteger code = error.code;
        if (code == 3840) {
            //
            [SVProgressHUD showErrorWithStatus:@"请求失败(404)"];
        }else{
            if (code != -999) {
                //
                [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            }
        }
        [self logRequestMessageWithUrl:URLString parameters:dic];
        DLog(@"%@",[error localizedDescription]);
        failure(YES);
    }];
    
}

#pragma mark - 上传图片

+ (void)uploadImageWithURLString:(NSString*)URLString
                      parameters:(id)parameters
                           image:(UIImage*)upimage
                            name:(NSString*)name
                        fileName:(NSString*)filename
                         success:(void (^)(NSURLSessionDataTask* task, id responseObject))success
                         failure:(LSRequestFailure)failure{
    //
    NSMutableDictionary* dic;
    if (parameters) {
        NSDictionary* tmp = (NSDictionary*)parameters;
        dic = [NSMutableDictionary dictionaryWithDictionary:tmp];
    }else{
        dic = [NSMutableDictionary dictionary];
    }

    [[self shareManager] POST:URLString parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //
        NSData* imgdata = UIImageJPEGRepresentation(upimage, 0.25);
        [formData appendPartWithFileData:imgdata name:name fileName:filename mimeType:@"image/jpeg"];
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        [self logRequestMessageWithUrl:URLString parameters:dic];
        success(task,responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        NSInteger code = error.code;
        if (code == 3840) {
            //
            [SVProgressHUD showErrorWithStatus:@"请求失败(404)"];
        }else{
            if (code != -999) {
                //
                [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            }
        }
        [self logRequestMessageWithUrl:URLString parameters:dic];
        DLog(@"%@",[error localizedDescription]);
        failure(YES);
    }];
}


+ (void)logRequestMessageWithUrl:(NSString*)urlstring parameters:(id)parameters{
    //
    
    NSDictionary* tmpdic = (NSDictionary*)parameters;
    NSMutableString* mbstring = [NSMutableString stringWithString:@"?"];
    for (int i = 0; i<tmpdic.allKeys.count; i++) {
        //
        NSString* key = tmpdic.allKeys[i];
        NSString* value = tmpdic[key];
        NSString* parstring = [NSString stringWithFormat:@"%@=%@",key,value];
        [mbstring appendString:[NSString stringWithFormat:@"%@&",parstring]];
    }
    
    NSString* requestapi = [NSString stringWithFormat:@"%@%@",urlstring,[mbstring substringToIndex:mbstring.length-1]];
    
    [LSFactory fc_addAPIWithApi:[NSString stringWithFormat:@"%@%@",kHOST_main,requestapi]];
    
    NSString* logstr = [NSString stringWithFormat:@"\n请求的api %@\n参数 %@\n完整的请求地址：%@%@\n",urlstring,parameters,kHOST_main,requestapi];
    
    DLog(@"%@\n",logstr);
    
}

#pragma mark - 取消请求

+ (void)cancelAllRequest{
    [[[self shareManager] operationQueue] cancelAllOperations];
}

#pragma mark - 结果提醒处理
+ (BOOL)judgeResultWithDic:(NSDictionary*)resultdic{
    //
    NSString* status = [LSFactory fc_judgeObj:resultdic[@"status"] placeholder:nil];
    
    if (!status) {
        //
        [SVProgressHUD showInfoWithStatus:@"不支持的返回格式"];
        return NO;
    }
    if (![status isEqualToString:@"1"]) {
        //
        NSString* showmsg = [LSFactory fc_judgeObj:resultdic[@"showMessage"] placeholder:kNotFoundObj(@"showMessage")];
        [SVProgressHUD showInfoWithStatus:showmsg];
        return NO;
    }
    return YES;
}

#pragma mark - APIs

#pragma mark ---用户

+ (void)user_getRegCodeWithNumber:(NSString*)number
                          regType:(NSString*)regtype
                          success:(LSRequestSuccess)success failure:(LSRequestFailure)failure{
    //
    NSDictionary* dic = @{@"username":[LSFactory fc_judgeObj:number placeholder:kNotFoundObj(@"")],
                          @"regType":regtype};
    [self GET:kAPI_userGetRegCode parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        NSDictionary* tmpdic = (NSDictionary*)responseObject;
        BOOL issuccessed = [self judgeResultWithDic:tmpdic];
        issuccessed ? success(responseObject) : failure(YES);
    } failure:^(BOOL isfailure) {
        //
        failure(isfailure);
    }];
}

+ (void)user_registerWithAccountNumber:(NSString*)accnumber password:(NSString*)password regCode:(NSString*)regcode success:(LSRequestSuccess)success failure:(LSRequestFailure)failure{
    //
    NSDictionary* dic = @{@"username":[LSFactory fc_judgeObj:accnumber placeholder:kNotFoundObj(@"")],
                          @"password":[LSFactory fc_judgeObj:password placeholder:kNotFoundObj(@"")],
                          @"regCode":[LSFactory fc_judgeObj:regcode placeholder:kNotFoundObj(@"")],
                          @"regType":@"0"};
    [self POST:kAPI_userRegister parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        NSDictionary* tmpdic = (NSDictionary*)responseObject;
        BOOL issuccessed = [self judgeResultWithDic:tmpdic];
        issuccessed ? success(responseObject) : failure(YES);
        
    } failure:^(BOOL isfailure) {
        //
        failure(isfailure);
    }];
}

+ (void)user_loginWithAccountNumber:(NSString*)accnumber password:(NSString*)password success:(LSRequestSuccess)success failure:(LSRequestFailure)failure{
    //
    NSDictionary* dic = @{@"username":[LSFactory fc_judgeObj:accnumber placeholder:kNotFoundObj(@"")],
                          @"password":[LSFactory fc_judgeObj:password placeholder:kNotFoundObj(@"")]};
    
    [self POST:kAPI_userLogin parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        NSDictionary* tmpdic = (NSDictionary*)responseObject;
        BOOL issuccessed = [self judgeResultWithDic:tmpdic];
        issuccessed ? success(responseObject) : failure(YES);
        
        if (issuccessed) {
            //
        }
        
    } failure:^(BOOL isfailure) {
        //
        failure(isfailure);
    }];
}

+ (void)user_getUserInfoSuccess:(LSRequestSuccess)success failure:(LSRequestFailure)failure{
    //
    [self GET:kAPI_userInfo parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        NSDictionary* tmpdic = (NSDictionary*)responseObject;
        BOOL issuccessed = [self judgeResultWithDic:tmpdic];
        issuccessed ? success(responseObject) : failure(YES);
        
    } failure:^(BOOL isfailure) {
        //
        failure(isfailure);
    }];
}

+ (void)user_logoutSuccess:(LSRequestSuccess)success failure:(LSRequestFailure)failure{
    //
    [self GET:kAPI_userLogout parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        NSDictionary* tmpdic = (NSDictionary*)responseObject;
        BOOL issuccessed = [self judgeResultWithDic:tmpdic];
        issuccessed ? success(responseObject) : failure(YES);
        
    } failure:^(BOOL isfailure) {
        //
        failure(isfailure);
    }];
}


#pragma mark 

#pragma mark

+ (void)tools_getToolListWithPage:(NSString*)page success:(LSRequestSuccess)success failure:(LSRequestFailure)failure{
    
    NSDictionary* dic = @{@"page":page,
                          @"pageSize":@"99"};
    
    [self GET:kAPI_tools parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        NSDictionary* tmpdic = (NSDictionary*)responseObject;
        BOOL issuccessed = [self judgeResultWithDic:tmpdic];
        issuccessed ? success(responseObject) : failure(YES);
        
    } failure:^(BOOL isfailure) {
        //
        failure(isfailure);
    }];
}

#pragma mark

#pragma mark
#pragma mark

#pragma mark
#pragma mark


#pragma mark

#pragma mark

#pragma mark

#pragma mark
+ (void)weather_geiWithCity:(NSString*)city success:(LSRequestSuccess)success failure:(LSRequestFailure)failure{
    //
    AFHTTPSessionManager* weathermanager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://appserver.1035.mobi/"]];
    weathermanager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    weathermanager.securityPolicy.allowInvalidCertificates = YES;
    weathermanager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain",@"text/xml", nil];
    
    NSDictionary* dic = @{@"city":city};
    
    [weathermanager GET:kAPI_weather parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        BOOL issuccessed = [responseObject isKindOfClass:[NSDictionary class]];
        issuccessed ? success(responseObject) : failure(YES);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        NSInteger code = error.code;
        if (code == 3840) {
            //
            [SVProgressHUD showErrorWithStatus:@"请求失败(404)"];
        }else{
            if (code != -999) {
                //
                [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            }
        }
        DLog(@"%@",[error localizedDescription]);
        
        failure(YES);
    }];
}

#pragma mark - 其他
+ (void)func_uploadImageWithImage:(UIImage*)image fileName:(NSString*)filename success:(LSRequestSuccess)success failure:(LSRequestFailure)failure{
    //
    [self uploadImageWithURLString:kAPI_funcUploadPic parameters:nil image:image name:@"file" fileName:[NSString stringWithFormat:@"%@.jpg",filename] success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        NSDictionary* tmpdic = (NSDictionary*)responseObject;
        BOOL issuccessed = [self judgeResultWithDic:tmpdic];
        issuccessed ? success(responseObject) : failure(YES);
        
    } failure:^(BOOL isfailure) {
        //
        failure(isfailure);
    }];
}










@end

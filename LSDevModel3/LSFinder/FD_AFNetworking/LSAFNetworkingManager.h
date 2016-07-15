//
//  LSAFNetworkingManager.h
//  LSDevModel3
//
//  Created by  tsou117 on 16/2/18.
//  Copyright (c) 2016年 sen. All rights reserved.
//

#import "AFHTTPSessionManager.h"

typedef void (^LSRequestSuccess)(id result);
typedef void (^LSRequestFailure)(BOOL isfailure);

@interface LSAFNetworkingManager : AFHTTPSessionManager


#pragma mark -

+ (void)cancelAllRequest;

/**
 *  获取验证码
 *
 *  @param number  手机号码
 *  @param success 成功
 *  @param failure 失败
 */
+ (void)user_getRegCodeWithNumber:(NSString*)number
                          regType:(NSString*)regtype
                          success:(LSRequestSuccess)success failure:(LSRequestFailure)failure;

/**
 *  用户注册
 *
 *  @param accnumber 手机号/
 *  @param password  密码
 *  @param regcode   验证码
 *  @param success   成功
 *  @param failure   失败
 */
+ (void)user_registerWithAccountNumber:(NSString*)accnumber password:(NSString*)password regCode:(NSString*)regcode success:(LSRequestSuccess)success failure:(LSRequestFailure)failure;

/**
 *  用户登录
 *
 *  @param accnumber 账号
 *  @param password  密码
 *  @param success   请求成功
 *  @param failure   失败
 */
+ (void)user_loginWithAccountNumber:(NSString*)accnumber password:(NSString*)password success:(LSRequestSuccess)success failure:(LSRequestFailure)failure;

/**
 *  获取个人资料
 *
 *  @param success 成功
 *  @param failure 失败
 */
+ (void)user_getUserInfoSuccess:(LSRequestSuccess)success failure:(LSRequestFailure)failure;

/**
 *  用户登出
 *
 *  @param success 成功
 *  @param failure 失败
 */
+ (void)user_logoutSuccess:(LSRequestSuccess)success failure:(LSRequestFailure)failure;


#pragma mark
#pragma mark
#pragma mark
/**
 *  便民工具
 *
 *  @param page    页码
 *  @param success 成功
 *  @param failure 失败
 */
+ (void)tools_getToolListWithPage:(NSString*)page success:(LSRequestSuccess)success failure:(LSRequestFailure)failure;

#pragma mark
#pragma mark
#pragma mark

#pragma mark

#pragma mark

#pragma mark
#pragma mark


#pragma mark
#pragma mark - 其他

/**
 *  上传图片
 *
 *  @param image    图片
 *  @param filename 文件名
 *  @param success  成功
 *  @param failure  失败
 */
+ (void)func_uploadImageWithImage:(UIImage*)image fileName:(NSString*)filename success:(LSRequestSuccess)success failure:(LSRequestFailure)failure;

















@end

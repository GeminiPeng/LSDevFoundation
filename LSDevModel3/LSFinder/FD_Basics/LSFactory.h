//
//  LSFactory.h
//  LSDevModel3
//
//  Created by Sen on 16/2/19.
//  Copyright © 2016年 sen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kLS_BASE_CECHE_PATH_Archiver @"/Library/Caches/Archiver"


@interface LSFactory : NSObject
<UIAlertViewDelegate>

#pragma mark - DMInfo

//是否使用辅助工具
+ (BOOL)useDebugTool;


+ (BOOL)useWelcomeView;
+ (BOOL)useSideBar;
+ (BOOL)useTabBar;

+ (NSArray*)fc_getWelcomePics;

#pragma mark - Device

//终端信息
+ (NSString*)fc_deviceMessageLog;

//获取服务器和当前服务器
+ (NSArray*)fc_getAllHttpServer;

//获取当前网络环境
+ (NSString*)fc_networkingStatusFromStatusBar;

//app信息
+ (NSString*)fc_getAppName;
+ (NSString*)fc_getAppVersion;
+ (NSString*)fc_getAppBuild;

#pragma mark - 接口debugview显示

+ (NSArray* )fc_getAPIList;
+ (void )fc_addAPIWithApi:(NSString*)apistr;

#pragma mark - 小工具
//获取当前时间
+ (NSString*)fc_getNowDate;

//颜色生成图片
+ (UIImage*)fc_imageWithColor:(UIColor*)color andHeight:(CGFloat)height;

//渐变颜色
+ (UIImage*)fc_backgroundImageFromColor:(UIColor*)fromcolor
                                 toColor:(UIColor*)tocolor frame:(CGRect)frame;

//随机颜色
+ (UIColor*)fc_randomColor;

//数据类型判断
+ (NSString*)fc_judgeObj:(id)baseobj placeholder:(NSString*)placeholder;
+ (NSDictionary*)fc_judgeDicWithObject:(id)baseobj;
+ (NSArray*)fc_judgeArrayWithObject:(id)baseobj;
+ (NSString*)fc_moneyDisposeWithMoney:(id)basemoney;

//弹框
+ (void)fc_showSysAlertViewWithMsg:(NSString*)msg;


//指定一个活动指示器
+ (void)fc_showIndicatorOnView:(UIView*)supview;
+ (void)fc_stopIndicatorOnView:(UIView*)supview;

//获取天气图片
+ (NSString*)fc_getWeatherImgWithStatus:(NSString*)status;

//计算字符串size
+ (CGSize)fc_getStringSizeWith:(NSString*)_mystr boundingRectWithSize:(CGSize)_boundSize font:(UIFont*)font;

//基于一个size换算出自适应的高度
+ (CGFloat)fc_getLayoutHeightWithBasicSize:(CGSize)size currWidth:(CGFloat)curr_w;

//正则手机号码
+(BOOL)fc_isMobileNumber:(NSString*)mobileNum;

//md5加密
+ (NSString *)fc_md5:(NSString *)str;

//等比缩放图片
+ (UIImage *)fc_scaleImage:(UIImage *)image toScale:(float)scaleSize;

//线条
+ (UIView*)fc_lineWithFrame:(CGRect)frame supView:(UIView*)supview;


#pragma mark - 沙箱路径

//
+ (void)fc_saveData:(NSData*)data withFileName:(NSString*)filename;


//路径检查
+ (BOOL)fc_checkPath:(NSString*)pathstr;


@end

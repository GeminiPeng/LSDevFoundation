//
//  LSFactory.m
//  LSDevModel3
//
//  Created by Sen on 16/2/19.
//  Copyright © 2016年 sen. All rights reserved.
//

#import "LSFactory.h"

#import <CommonCrypto/CommonDigest.h>

#import "LSAlertView.h"

@implementation LSFactory


#pragma mark - DMInfo

+ (NSDictionary*)fc_DMInfo{
    
    NSString* path = [kLSBundle pathForResource:@"LSDMInfo" ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:path];
}

+ (BOOL)useDebugTool{

    NSDictionary* dmdic = [self fc_DMInfo];
    BOOL tmp = [dmdic[@"Use debugTool"] boolValue];
    return tmp;
}
//+ (BOOL)useHamburgerStyle{
//
//    NSDictionary* dmdic = [self fc_DMInfo];
//    BOOL tmp = [dmdic[@"Use hamburger"] boolValue];
//    return tmp;
//}
//+ (BOOL)useJustHomeView{
//
//    NSDictionary* dmdic = [self fc_DMInfo];
//    BOOL tmp = [dmdic[@"Use just homeView"] boolValue];
//    return tmp;
//}
+ (BOOL)useWelcomeView{

    NSDictionary* dmdic = [self fc_DMInfo];
    BOOL tmp = [dmdic[@"Use welcomeView"] boolValue];
    return tmp;
}
+ (BOOL)useSideBar{
    
    NSDictionary* dmdic = [self fc_DMInfo];
    BOOL tmp = [dmdic[@"Use SideBar"] boolValue];
    return tmp;
}
+ (BOOL)useTabBar{
    
    NSDictionary* dmdic = [self fc_DMInfo];
    BOOL tmp = [dmdic[@"Use TabBar"] boolValue];
    return tmp;
}



+ (NSArray*)fc_getWelcomePics{
    
    NSDictionary* dmdic = [self fc_DMInfo];
    NSArray* pics = dmdic[@"Welcome pictures"];
    if (!pics || pics.count == 0) {
        return @[kNotFoundObj(@"")];
    }
    return pics;
}

#pragma mark - Device
//终端信息输出
+ (NSString*)fc_deviceMessageLog{
    //
    NSString* tmps;
    //设备信息
    UIDevice* device = [[UIDevice alloc] init];
    NSString* deviceS = [NSString stringWithFormat:@"设备名称：%@\n\n机型：%@\n\n系统：iOS %@\n",device.name,device.model,kDevice_sysVersion];
    
    //分辨率
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat width = rect.size.width*scale;
    CGFloat height = rect.size.height*scale;
    NSString* pixelS = [NSString stringWithFormat:@"\n分辨率：%0.0f*%0.0f\n",width,height];
    
    //网络环境
    NSString* netS = [NSString stringWithFormat:@"\n网络环境：%@\n",[self fc_networkingStatusFromStatusBar]];
    
    //服务器
    NSString* serverS = [NSString stringWithFormat:@"\n当前服务器：%@",kHOST_main];
    
    tmps = [NSString stringWithFormat:@"%@%@%@%@",deviceS,pixelS,netS,serverS];
    DLog(@"%@\n\n ****************************************\n\n",tmps);
    return tmps;
}

+ (NSArray*)fc_getAllHttpServer{
    
    NSDictionary* dmdic = [self fc_DMInfo];
    NSArray* allserver = dmdic[@"All server"];
    
    if (!allserver || allserver.count == 0) {
        //
        return @[kNotFoundObj(@"")];
    }
    
    return allserver;
    
}

//获取当前网络环境
+ (NSString*)fc_networkingStatusFromStatusBar{
    // 状态栏是由当前app控制的，首先获取当前app
    
    //如果状态栏被隐藏了要先让它显示出来，然后在之后隐藏
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    UIApplication *app = [UIApplication sharedApplication];
    
    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    
    int type = 0;
    for (id child in children) {
        if ([child isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
        }
    }
    
    NSString *stateString = @"wifi";
    
    switch (type) {
        case 0:
            stateString = @"notReachable";
            break;
            
        case 1:
            stateString = @"2G";
            break;
            
        case 2:
            stateString = @"3G";
            break;
            
        case 3:
            stateString = @"4G";
            break;
            
        case 4:
            stateString = @"LTE";
            break;
            
        case 5:
            stateString = @"wifi";
            break;
            
        default:
            stateString = @"无法检测网络环境";
            break;
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:[self fc_isStatusBarHidden]];
    
    
    return stateString;
}
//判断状态栏是否被隐藏
+ (BOOL)fc_isStatusBarHidden{
    
    UIApplication* app = [UIApplication sharedApplication];
    
    id statusBar = [app valueForKeyPath:@"statusBar"];
    
    if (statusBar) {
        return NO;
    }
    return YES;
    
}

+ (NSString*)fc_getAppName{
    //
    NSDictionary* infodic = [kLSBundle infoDictionary];
    
    //appname
    NSString* appname = infodic[@"CFBundleName"];
    
    return appname;
}
+ (NSString*)fc_getAppVersion{
    //
    NSDictionary* infodic = [kLSBundle infoDictionary];
    
    //
    NSString* appversion = infodic[@"CFBundleShortVersionString"];
    
    return appversion;
}
+ (NSString*)fc_getAppBuild{
    //
    NSDictionary* infodic = [kLSBundle infoDictionary];
    //
    NSString* appbuild = infodic[@"CFBundleVersion"];
    
    return appbuild;
}

#pragma mark - 接口debugview显示

+ (NSArray* )fc_getAPIList{
    //APIREQUESTARRAY
    
    return [kLSUserDefaults arrayForKey:kMark_requestApis];
}

+ (void )fc_addAPIWithApi:(NSString*)apistr{
    //
    NSMutableArray* apiarr = [NSMutableArray arrayWithArray:[kLSUserDefaults arrayForKey:kMark_requestApis]];
    
    BOOL canadd = apiarr.count < 3 ? YES : NO;
    if (canadd) {
        //可以添加进去
        [apiarr addObject:apistr];
    }else{
        //替换 先删掉index 0
        [apiarr removeObjectAtIndex:0];
        [apiarr addObject:apistr];
    }
    
    //先删除原有的
    [kLSUserDefaults removeObjectForKey:kMark_requestApis];
    [kLSUserDefaults synchronize];
    
    //添加
    [kLSUserDefaults setObject:apiarr forKey:kMark_requestApis];
    [kLSUserDefaults synchronize];
}

#pragma mark - 小工具

//获取当前时间
+ (NSString*)fc_getNowDate{
    //
    NSDate* currentDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    /*
     去0
     
     NSArray* tmparr = [dateString componentsSeparatedByString:@"-"];
     NSString* yearstring = tmparr[0];
     NSString* monthstring = tmparr[1];
     NSString* daystring = tmparr[2];
     
     NSInteger _month = [monthstring integerValue];
     NSInteger _day = [daystring integerValue];
     
     NSString* tmpstr = [NSString stringWithFormat:@"%@-%d-%d",yearstring,_month,_day];
     
     */
    
    return dateString;
}

+ (UIImage*)fc_imageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage*)fc_backgroundImageFromColor:(UIColor*)fromcolor
                                 toColor:(UIColor*)tocolor frame:(CGRect)frame{
    
    UIColor* colors[2] = {fromcolor,tocolor};
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat colorComponents[8];
    
    UIGraphicsBeginImageContextWithOptions(frame.size, YES, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGContextSaveGState(context);
    
    for (int i = 0; i<2; i++) {
        //
        UIColor* color = colors[i];
        CGColorRef temcolorRef = color.CGColor;
        const CGFloat* components = CGColorGetComponents(temcolorRef);
        for (int j = 0; j < 4; j++) {
            colorComponents[i * 4 + j] = components[j];
        }
    }
    
    CGPoint startPoint;
    CGPoint endPoint;
    
    //从上到下渐变
    startPoint = CGPointZero;
    endPoint = CGPointMake(0, frame.size.height);
    
    //从左到右渐变
//        startPoint = CGPointZero;
//        endPoint = CGPointMake(frame.size.width, 0);
    
    CGGradientRef gradient =  CGGradientCreateWithColorComponents(rgb, colorComponents, NULL, 2);
    CGColorSpaceRelease(rgb);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient);
    
    CGImageRef cgImage2 = CGBitmapContextCreateImage(context);
    UIImage *image = [UIImage imageWithCGImage:cgImage2];//UIGraphicsGetImageFromCurrentImageContext();
    CGImageRelease(cgImage2);
    
    return image;
}

//随机颜色
+ (UIColor*)fc_randomColor{
    static BOOL seeded = NO;
    if (!seeded) {
        seeded = YES;
        (time(NULL));
    }
    CGFloat red = (CGFloat)random() / (CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random() / (CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random() / (CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

//数据类型判断
+ (NSString*)fc_judgeObj:(id)baseobj placeholder:(NSString*)placeholder{
    
    //    NSLog(@"baseobj class = %@",[baseobj class]);
    
    if ([baseobj isEqual: [NSNull null]] || baseobj == nil || baseobj == NULL ){
        //
        return placeholder;
        
    }else if ([baseobj isKindOfClass:[NSNumber class]]){
        //
        return [baseobj stringValue];
        
    }else if ([baseobj isKindOfClass:[NSString class]]){
        //
        NSString* tmp = (NSString*)baseobj;
        if ([tmp isEqualToString:@""]) {
            //
            return placeholder;
        }
        if ([[tmp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
            //
            return placeholder;
        }
        if ([tmp isEqualToString:@"null"]) {
            //
            return placeholder;
        }
    }else{
        
        NSString* tmps = [NSString stringWithFormat:@"%@",baseobj];
        
        return tmps;
    }
    
    return baseobj;
    
}

+ (NSDictionary*)fc_judgeDicWithObject:(id)baseobj{
    //
    
    if ([baseobj isKindOfClass:[NSDictionary class]]) {
        return baseobj;
    }
    
    return @{};
}
+ (NSArray*)fc_judgeArrayWithObject:(id)baseobj{
    //
    if ([baseobj isKindOfClass:[NSArray class]]) {
        return baseobj;
    }
    return @[];
}

//涉及金额小数点控制
+ (NSString*)fc_moneyDisposeWithMoney:(id)basemoney{
    //
    if ([basemoney isKindOfClass:[NSNumber class]]) {
        //
        
        NSString* tmp = [NSString stringWithFormat:@"%0.2f",[basemoney doubleValue]];
        return tmp;
    }else if ([basemoney isKindOfClass:[NSString class]]){
        NSString* tmp = (NSString*)basemoney;
        
        double dd = [tmp doubleValue];
        tmp = [NSString stringWithFormat:@"%0.2f",dd];
        return tmp;
    }
    return @"暂无";
}


//默认弹框（无代理）
+ (void)fc_showSysAlertViewWithMsg:(NSString*)msg{
    //
    UIAlertView* alertV = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertV show];
    
}

//指定一个活动指示器
+ (void)fc_showIndicatorOnView:(UIView*)supview{
    //
    [self fc_stopIndicatorOnView:supview];
    UIActivityIndicatorView* activityView = [[UIActivityIndicatorView alloc] initWithFrame:supview.bounds];
    activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    activityView.tag =  99;
    [supview addSubview:activityView];
    
    [activityView startAnimating];
}

+ (void)fc_stopIndicatorOnView:(UIView*)supview{
    //
    UIActivityIndicatorView* activityView = (UIActivityIndicatorView*)[supview viewWithTag:99];
    
    [activityView stopAnimating];
    [activityView removeFromSuperview];
}

+ (NSString*)fc_getWeatherImgWithStatus:(NSString*)status{
    
    NSString* tmp;
    if ([status rangeOfString:@"多云"].location != NSNotFound) {
        //
        tmp = @"duoyun.png";
    }
    else if ([status rangeOfString:@"晴"].location != NSNotFound) {
        //
        tmp = @"qing.png";
    }
    else if ([status rangeOfString:@"阴"].location != NSNotFound) {
        //
        tmp = @"yin.png";
    }
    else if ([status rangeOfString:@"阵雨"].location != NSNotFound) {
        //
        tmp = @"zhenyu.png";
    }
    else if ([status rangeOfString:@"雷阵雨"].location != NSNotFound) {
        //
        tmp = @"leizhenyu.png";
    }
    else if ([status rangeOfString:@"小雨"].location != NSNotFound) {
        //
        tmp = @"xiaoyu.png";
        
    }
    else if ([status rangeOfString:@"中雨"].location != NSNotFound) {
        //
        tmp = @"zhongyu.png";
    }
    else if ([status rangeOfString:@"大雨"].location != NSNotFound) {
        //
        tmp = @"dayu.png";
    }
    else if ([status rangeOfString:@"雪"].location != NSNotFound) {
        //
        tmp = @"xue.png";
    }
    else{
        
    }
    
    return tmp;
}

//计算字符串size
+ (CGSize)fc_getStringSizeWith:(NSString*)_mystr boundingRectWithSize:(CGSize)_boundSize font:(UIFont*)font{
    
    _mystr = [self fc_judgeObj:_mystr placeholder:nil];
    
    if (!_mystr) {
        //
        return CGSizeMake(_boundSize.width, 20);
        
    }
    
    //    if ([_mystr isEqual: [NSNull null]] || _mystr == nil || [_mystr isEqualToString: @""] || [_mystr isEqualToString: @"<null>"])
    //    {
    //        return CGSizeMake(_boundSize.width, 20);
    //    }
    
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize size = [_mystr  boundingRectWithSize:_boundSize options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return size;
}

//基于一个size换算出自适应的高度
+ (CGFloat)fc_getLayoutHeightWithBasicSize:(CGSize)size currWidth:(CGFloat)curr_w{
    //
    CGFloat w = size.width;
    CGFloat h = size.height;
    
    return curr_w*h/w;
    
}

//正则手机号码
+(BOOL)fc_isMobileNumber:(NSString*)mobileNum{
    
    //返回YES表示可用的手机号码
    if (mobileNum.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//md5加密
+ (NSString *)fc_md5:(NSString *)str
{
    const char *original_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

//等比缩放图片
+ (UIImage *)fc_scaleImage:(UIImage *)image toScale:(float)scaleSize{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+ (UIView*)fc_lineWithFrame:(CGRect)frame supView:(UIView*)supview{
    UIView* line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = kColor_line;
    [supview addSubview:line];
    return line;
}

#pragma mark - 沙箱路径

+ (void)fc_saveData:(NSData*)data withFileName:(NSString*)filename{
    //
    
    NSString* path = [NSHomeDirectory() stringByAppendingString:kLS_BASE_CECHE_PATH_Archiver];
    NSFileManager *fileManger = [NSFileManager defaultManager];
    if (![fileManger fileExistsAtPath:path]){
        //创建目录
        [fileManger createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //拼接文件路径
    NSMutableString * tempStr = [[NSMutableString alloc]init];
    for (int i=0; i<filename.length; i++) {
        if (([filename characterAtIndex:i]<='9'&&[filename characterAtIndex:i]>='0')||([filename characterAtIndex:i]<='z'&&[filename characterAtIndex:i]>='a')||([filename characterAtIndex:i]<='Z'&&[filename characterAtIndex:i]>='A')) {
            [tempStr appendFormat:@"%c",[filename characterAtIndex:i]];
        }
    }
    NSString * writePath = [path stringByAppendingFormat:@"/%@",tempStr];
    
    [data writeToFile:writePath atomically:YES];
    
}

+ (NSString*)fc_getAppSandBoxPath{
    //
    return [NSHomeDirectory() stringByAppendingFormat:@"/Library/Caches/%@",kApp_name];
}



+ (BOOL)fc_checkPath:(NSString*)pathstr{
    
    NSFileManager* fileManger = [NSFileManager defaultManager];
    
    return [fileManger fileExistsAtPath:pathstr]; // YES 有该路径 NO 没有该路径
    
}


@end

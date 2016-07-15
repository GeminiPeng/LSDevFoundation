//
//  AppDelegate.m
//  LSDevModel3
//
//  Created by  tsou117 on 16/2/18.
//  Copyright (c) 2016年 sen. All rights reserved.
//

#import "AppDelegate.h"
#import "LSHomeViewController.h"
#import "LSSideViewController.h"

#import "LSHighLevelWindow.h"

@interface AppDelegate ()
<UITabBarControllerDelegate>

@end

@implementation AppDelegate
{
    //
    BMKMapManager* _mapmanager;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self appSet];
    
        
    return YES;
}

- (void)appSet{
    //
    
    //创建沙箱缓存环境
        
    if (!kHOST_main) {
        //当前服务器
        NSArray* allserver = [LSFactory fc_getAllHttpServer];
        [kLSUserDefaults setObject:allserver[0] forKey:kMark_currServer];
        [kLSUserDefaults synchronize];
    }
    
    
    //HUD
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0.000 green:0.020 blue:0.059 alpha:0.85]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMinimumDismissTimeInterval:3.0];
    
    //辅助工具
    if ([LSFactory useDebugTool]) {
        //
        [LSHIGHLEVELWINDOW creatDebugWindow];
    }else{
        //
        [LSFactory fc_deviceMessageLog];
    }
    

    
    //引导页
    if ([LSFactory useWelcomeView] ) {
        //
        
        BOOL isfirst = [kLSUserDefaults boolForKey:kMark_firstWelcome];
        if (isfirst == NO) {
            [kLSUserDefaults setBool:YES forKey:kMark_firstWelcome];
            [kLSUserDefaults synchronize];
            
            [LSHIGHLEVELWINDOW creatWelcomeWindow];
        }
        
    }
    
    //百度地图
    _mapmanager = [[BMKMapManager alloc] init];
    BOOL ret = [_mapmanager start:@"IbkEmVUNkj6CTQQVXSWmFGof"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    //友盟
    [UMSocialData setAppKey:kUmKey];
    [UMSocialWechatHandler setWXAppId:@"wx781720146e7ff1f1" appSecret:@"51cfb5d4a752146009c5093965dbdf31" url:kApp_downUrl];
    [UMSocialQQHandler setQQWithAppId:@"1105219039" appKey:@"qPIeRsEGbd45g2tE" url:kApp_downUrl];
    
    //个推
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppkey appSecret:kGtAppSecret delegate:self];
    [self registerUserNotification];
    
    
    //汉堡包风格 || tabbar风格
    
    if ([LSFactory useSideBar]) {
        [self appSetHamburgerStyle];
        return;
    }
    if ([LSFactory useTabBar]) {
        [self appSetTabBarStyle];
        return;
    }
    
    LSHomeViewController* home_vc = [[LSHomeViewController alloc] init];
    UINavigationController* nav_home = [[UINavigationController alloc] initWithRootViewController:home_vc];
    self.window.rootViewController = nav_home;
}

- (void)appSetTabBarStyle{
    //
    UITabBarController* tb = [[UITabBarController alloc] init];
    tb.delegate = self;
    self.window.rootViewController = tb;
        
    //
    LSHomeViewController* home_vc = [[LSHomeViewController alloc] init];
    UINavigationController* nav_home = [[UINavigationController alloc] initWithRootViewController:home_vc];

    NSArray* vcs = @[nav_home];
    
    for (int i = 0; i<vcs.count; i++) {
        //
        UINavigationController* nc = (UINavigationController*)vcs[i];
        nc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        UIImage *img1 = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_%d.png",i+1]];
        UIImage *imgS1 =[UIImage imageNamed:[NSString stringWithFormat:@"tabbar_s_%d.png",i+1]];
        nc.tabBarItem.selectedImage = [imgS1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nc.tabBarItem.image = [img1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UINavigationController* nav = vcs[i];
        LSBaseViewController* base_vc = (LSBaseViewController*)nav.topViewController;
        base_vc.isTabbar = YES;
    }
    
    tb.viewControllers = vcs;
    
}
- (void)appSetHamburgerStyle{
    //
    LSHomeViewController* home_vc = [[LSHomeViewController alloc] init];
    UINavigationController* nav_home = [[UINavigationController alloc] initWithRootViewController:home_vc];

    
    LSSideViewController* side_vc = [[LSSideViewController alloc] init];
    UINavigationController* nav_side = [[UINavigationController alloc] initWithRootViewController:side_vc];
    
    UIImage* img = [UIImage imageNamed:@"ui_cebian_0.png"];
    
    MMDrawerController* drawer_vc = [[MMDrawerController alloc] initWithCenterViewController:nav_home leftDrawerViewController:nav_side];
    [drawer_vc setShowsShadow:YES];
    [drawer_vc setRestorationIdentifier:@"MMDrawer"];
    [drawer_vc setMaximumLeftDrawerWidth:img.size.width];
    [drawer_vc setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawer_vc setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [drawer_vc setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        
        MMDrawerControllerDrawerVisualStateBlock visualStateBlock = [MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:2.0];
        if (visualStateBlock) {
            visualStateBlock(drawerController,drawerSide,percentVisible);
        }
        
        
    }];
    
    self.window.rootViewController = drawer_vc;
}

#pragma mark 个推
/** 注册用户通知 */
- (void)registerUserNotification {
    
    /*
     注册通知(推送)
     申请App需要接受来自服务商提供推送消息
     */
    
    // 判读系统版本是否是“iOS 8.0”以上
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ||
        [UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        
        // 定义用户通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        
        // 定义用户通知设置
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        // 注册用户通知 - 根据用户通知设置
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else { // iOS8.0 以前远程推送设置方式
        // 定义远程通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        
        // 注册远程通知 -根据远程通知类型
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
}

/** 已登记用户通知 用户通知(推送)回调 _IOS 8.0以上使用 */
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // 注册远程通知（推送）
    [application registerForRemoteNotifications];
}

/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
    
    // [3]:向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:token];
}

/** 远程通知注册失败委托 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"\n>>>[DeviceToken Error]:%@\n\n", error.description);
}

/** APP已经接收到“远程”通知(推送) - (App运行在后台/App运行在前台) */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    application.applicationIconBadgeNumber = 0; // 标签
    
    NSLog(@"\n>>>[Receive RemoteNotification]:%@\n\n", userInfo);
}

/** APP已经接收到“远程”通知(推送) - 透传推送消息  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    
    // 处理APN
    NSLog(@"\n>>>[Receive RemoteNotification - Background Fetch]:%@\n\n", userInfo);
    
//    [LSFactory fc_showSysAlertViewWithMsg:@"APP已经接收到“远程”通知(推送)"];
    
    [GeTuiSdk resetBadge]; //重置角标计数
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - GeTuiSdkDelegate

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    // [4-EXT-1]: 个推SDK已注册，返回clientId
    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"\n>>>[GexinSdk error]:%@\n\n", [error localizedDescription]);
}


/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    
    // [4]: 收到个推消息
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    }
    
    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@", taskId, msgId, payloadMsg, offLine ? @"<离线消息>" : @""];
    NSLog(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n", msg);
    [LSFactory fc_showSysAlertViewWithMsg:payloadMsg];
    
    [GeTuiSdk resetBadge]; //重置角标计数
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

/** SDK收到sendMessage消息回调 */
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // [4-EXT]:发送上行消息结果反馈
    NSString *msg = [NSString stringWithFormat:@"sendmessage=%@,result=%d", messageId, result];
    NSLog(@"\n>>>[GexinSdk DidSendMessage]:%@\n\n", msg);
//    [LSFactory fc_showSysAlertViewWithMsg:@"SDK收到sendMessage消息回调"];
}

/** SDK运行状态通知 */
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    // [EXT]:通知SDK运行状态
    NSLog(@"\n>>>[GexinSdk SdkState]:%u\n\n", aStatus);
}

/** SDK设置推送模式回调 */
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error {
    if (error) {
        NSLog(@"\n>>>[GexinSdk SetModeOff Error]:%@\n\n", [error localizedDescription]);
        return;
    }
    
    NSLog(@"\n>>>[GexinSdk SetModeOff]:%@\n\n", isModeOff ? @"开启" : @"关闭");
}

#pragma mark

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    BOOL result;
    
    result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //
        result = [Pingpp handleOpenURL:url withCompletion:nil];
    }
    return result;
    
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    //
//    BOOL canHandleURL = [Pingpp handleOpenURL:url withCompletion:nil];
//    return canHandleURL;
    
    BOOL result;
    
    result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //
        result = [Pingpp handleOpenURL:url withCompletion:nil];
    }
    return result;
}


- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    /// Background Fetch 恢复SDK 运行
    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

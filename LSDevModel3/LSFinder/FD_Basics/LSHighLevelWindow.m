//
//  LSHighLevelWindow.m
//  LSDevModel2
//
//  Created by  tsou117 on 15/10/13.
//  Copyright (c) 2015年  tsou117. All rights reserved.
//

#import "LSHighLevelWindow.h"

#import "LSDebugViewController.h"
#import "LSWelcomeViewController.h"


static LSHighLevelWindow* __welwindow;

@implementation LSHighLevelWindow
{
    //
    UIWindow* debugwindow;
    
    UIWindow* welcomewindow;
    UIView* coverView;

}

+ (LSHighLevelWindow*)shareMyWindow{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        //
        
        __welwindow = [[LSHighLevelWindow alloc] init];
    });
    
    return __welwindow;
}

#pragma mark - deBugWindow
- (void)creatDebugWindow{
    //
    debugwindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    debugwindow.windowLevel = UIWindowLevelStatusBar;
    [debugwindow makeKeyAndVisible];
    debugwindow.clipsToBounds = YES;
    
    
    //set rootvc
    LSDebugViewController* debug_vc = [[LSDebugViewController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:debug_vc];
    debugwindow.rootViewController = nav;
    
    UIButton* switchbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    switchbtn.layer.cornerRadius = 4;
    switchbtn.clipsToBounds = YES;
    [switchbtn setImage:[UIImage imageNamed:@"Lbtn.png"] forState:UIControlStateNormal];
    switchbtn.tag = 100;
    switchbtn.frame = CGRectMake(kSCREEN_WIDTH-30, kSCREEN_HEIGHT-100, 30, 30);
    [switchbtn addTarget:self action:@selector(actionofShowOrHide:) forControlEvents:UIControlEventTouchUpInside];
    [debugwindow addSubview:switchbtn];
    
    [self actionofShowOrHide:switchbtn];
}

- (void)actionofShowOrHide:(UIButton*)sender{
    
    if (sender.tag == 100)
    {
        //隐藏
        sender.tag = 101;
        
        [UIView animateWithDuration:0.35 animations:^{
            //
            debugwindow.frame = CGRectMake(-kSCREEN_WIDTH, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        } completion:^(BOOL finished) {
            //
            debugwindow.frame = CGRectMake(0, kSCREEN_HEIGHT-100, 30, 30);
            debugwindow.backgroundColor = [UIColor colorWithRed:0.000 green:0.020 blue:0.059 alpha:0];
            sender.frame = debugwindow.bounds;
        }];
        
    }
    else if (sender.tag == 101)
    {
        //展示
        sender.tag = 100;
        
        debugwindow.frame = CGRectMake(-kSCREEN_WIDTH+30, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        debugwindow.backgroundColor = [UIColor colorWithRed:0.000 green:0.020 blue:0.059 alpha:1];
        sender.frame = CGRectMake(kSCREEN_WIDTH-30, kSCREEN_HEIGHT-100, 30, 30);
        
        [UIView animateWithDuration:0.35 animations:^{
            //
            debugwindow.frame = [[UIScreen mainScreen] bounds];
        } completion:^(BOOL finished) {
            //
            
        }];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNoti_debugTool object:nil];
        
    }
}

#pragma mark - 欢迎界面
- (void)creatWelcomeWindow{
    
    //
    welcomewindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    welcomewindow.windowLevel = UIWindowLevelStatusBar;
    welcomewindow.backgroundColor = [UIColor clearColor];
    [welcomewindow makeKeyAndVisible];
    welcomewindow.clipsToBounds = YES;
    
    coverView = [[UIView alloc] initWithFrame:welcomewindow.bounds];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0.5;
    [welcomewindow addSubview:coverView];
    
    //set rootvc
    LSWelcomeViewController* welcome_vc = [[LSWelcomeViewController alloc] init];
    welcomewindow.rootViewController = welcome_vc;
    

    
}

- (void)setAlpha:(CGFloat)alpha{
    //
    coverView.alpha = alpha;
}

- (void)resignWelcomeWindow{
    //
    welcomewindow.rootViewController = nil;
    welcomewindow.hidden = YES;
}

@end

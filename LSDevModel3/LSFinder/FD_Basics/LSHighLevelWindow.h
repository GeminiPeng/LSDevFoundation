//
//  LSHighLevelWindow.h
//  LSDevModel2
//
//  Created by  tsou117 on 15/10/13.
//  Copyright (c) 2015年  tsou117. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define LSHIGHLEVELWINDOW [LSHighLevelWindow shareMyWindow]

@interface LSHighLevelWindow : NSObject

+ (LSHighLevelWindow*)shareMyWindow;


@property (nonatomic, assign) CGFloat alpha;

//创建debugwindow
- (void)creatDebugWindow;

//创建欢迎window
- (void)creatWelcomeWindow;
- (void)resignWelcomeWindow;



@end

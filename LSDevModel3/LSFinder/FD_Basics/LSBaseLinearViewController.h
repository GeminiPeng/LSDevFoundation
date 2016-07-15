//
//  LSBaseLinearViewController.h
//  LSDevModel2
//
//  Created by  tsou117 on 15/11/5.
//  Copyright (c) 2015年  tsou117. All rights reserved.
//

#import "LSBaseViewController.h"

@interface LSBaseLinearViewController : LSBaseViewController

@property (nonatomic,strong) UIScrollView* rootview;    //全部子视图在rootview上布局
@property (nonatomic,assign) CGFloat subviews_h;        //记录子视图的及时y坐标
@property (nonatomic,assign) BOOL bounces;
@property (nonatomic,assign) BOOL autoGoEnd;  //添加子视图之后，界面自动跟踪到最后添加的那个视图的位置,默认不会

@property (nonatomic,strong,readonly) NSMutableArray* subviews; //子视图集合

#pragma mark - 基本
- (void)addSubview:(UIView*)view;


- (void)loadPlaceholderSpaceWithHeight:(CGFloat)height;

- (void)reloadRootContentSize;

- (void)clearRootView;

@end

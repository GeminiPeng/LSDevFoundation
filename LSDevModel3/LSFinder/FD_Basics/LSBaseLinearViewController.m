//
//  LSBaseLinearViewController.m
//  LSDevModel2
//
//  Created by  tsou117 on 15/11/5.
//  Copyright (c) 2015年  tsou117. All rights reserved.
//

#import "LSBaseLinearViewController.h"

@interface LSBaseLinearViewController ()
@end

@implementation LSBaseLinearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //rootview
    _rootview = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _rootview.alwaysBounceVertical = YES;
    [self.view addSubview:_rootview];
    
    [self linearSet];
    
    //
    //
    _rootview.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [_rootview registerAsDodgeViewForMLInputDodger];
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    _rootview.frame = self.view.bounds;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.closeCebianMoveout = YES;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
}

- (void)linearSet{
    //
    
    //
    self.fullSlidePopBack = YES;
    
    self.subviews_h = 0;
    _subviews = [NSMutableArray array];
}

#pragma mark - 基本

- (void)setBounces:(BOOL)bounces{
    
    _rootview.bounces = bounces;
}

- (void)setAutoGoEnd:(BOOL)autoGoEnd{
    
    _autoGoEnd = autoGoEnd;
    
    if (_autoGoEnd) {
        //
        CGFloat ff = self.rootview.contentSize.height-self.rootview.bounds.size.height;
        [self.rootview setContentOffset:CGPointMake(0, ff) animated:YES];
    }
    
}

- (void)addSubview:(UIView*)view{
    
    [_rootview addSubview:view];
    
    self.subviews_h += view.bounds.size.height;
    [_subviews addObject:view];
    
    [self reloadRootContentSize];
    
}

- (void)loadPlaceholderSpaceWithHeight:(CGFloat)height{
    //
    
    self.subviews_h += height;
    [self reloadRootContentSize];
    
}

- (void)reloadRootContentSize{
    
    _rootview.contentSize = CGSizeMake(_rootview.bounds.size.width, self.subviews_h);
    
}

- (void)clearRootView{
    //
    NSArray* subviews = [_rootview subviews];
    if (subviews.count != 0) {
        [subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

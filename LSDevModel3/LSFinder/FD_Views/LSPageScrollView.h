//
//  LSPageScrollView.h
//  LSPageControl
//
//  Created by  sen on 15/8/28.
//  Copyright (c) 2015年  sen. All rights reserved.
//

#define PAGECONTROL_jx  5  //缩略点之间的间隙

#import "LSBaseView.h"

#import "LSDIYView1.h"
#import "LSDIYView2.h"

typedef void (^blockAllItems)(NSArray* items);

typedef NS_ENUM(NSInteger, LSPageShowStyle) {
    LSPageShowStyleRound = 0,
    LSPageShowStyleLine
};

typedef NS_ENUM(NSInteger, LSPageItemClass) {
    LSPageItemClassButton = 0,
    LSPageItemClassImageView,
    LSPageItemClassDiyView1,
    LSPageItemClassDiyView2
    //more diy view ...
};

@interface LSPageScrollView : LSBaseView
<UIScrollViewDelegate>

- (instancetype)initWithFrame:(CGRect)frame
                    itemCount:(NSInteger)count
                     itemSize:(CGSize)itemsize
               itemInterspace:(CGFloat)interspace
                    itemClass:(LSPageItemClass)itemclass
                     complete:(blockAllItems)allitems;


- (instancetype)initWithFrame:(CGRect)frame
                    itemCount:(NSInteger)count
                     itemSize:(CGSize)itemsize
               itemInterspace:(CGFloat)interspace
                    itemClass:(LSPageItemClass)itemclass
             indexOfBreakLine:(NSInteger)index
                     complete:(blockAllItems)allitems;

@property (nonatomic, assign) BOOL pagingEnabled;   //默认是YES

@property (nonatomic, assign) BOOL hiddenPageControl;   //隐藏页数标识
@property (nonatomic, strong) UIImage* defaultPageIndicatorImage;   //默认page图
@property (nonatomic, strong) UIImage* currentPageIndicatorImage;   //当前page图

@property (nonatomic, assign) NSInteger pages;  //页数,如果赋值将有最高优先级
@property (nonatomic, assign) LSPageShowStyle showstyle;    //默认随图片风格变化而变化

@property (nonatomic, assign) BOOL isCenterBegin;   //从中点开始

@property (nonatomic, assign) BOOL alwaysBounceHorizontal;    //保持水平边界反弹

@end

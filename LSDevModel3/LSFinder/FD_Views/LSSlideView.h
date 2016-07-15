//
//  LSSlideView.h
//  LSdiyView
//
//  Created by  tsou117 on 15/4/30.
//  Copyright (c) 2015年  tsou117. All rights reserved.
//

#import "LSBaseView.h"

#define IMAGE_HEIGHT [UIScreen mainScreen].bounds.size.width*0.5

typedef NS_ENUM(NSInteger, LSPageControlAlignment) {
    LSPageControlAlignmentCenter = 0,   //居中
    LSPageControlAlignmentLeft,         //左侧
    LSPageControlAlignmentRight         //右侧
};

@interface LSSlideView : LSBaseView
<UIScrollViewDelegate>
@property (nonatomic,strong) NSArray* imageArr;         //本地图片
@property (nonatomic,strong) NSArray* imageUrlArr;      //网络图片
@property (nonatomic,strong) NSArray* titleArr;         //标题

@property (nonatomic,assign) BOOL hiddenTitle;//隐藏标题，默认是显示的
@property (nonatomic,assign) BOOL hiddenPageControllView;   //是否显示点点点，默认显示

@property (nonatomic,assign) BOOL closeAutoSlide;//是否关闭自动滚动，默认是自动滚动的,

@property (nonatomic,assign) UIViewContentMode contentMode;//图片显示的样式

@property (nonatomic,assign) LSPageControlAlignment pcalignment;    // 。。。的位置

@property (nonatomic,strong) UIImage* pageIndicatorImage;
@property (nonatomic,strong) UIImage* currentPageIndicatorImage;

@property (nonatomic,copy) void(^selected)(NSInteger index);


@end

#pragma mark - 带标题的图片
@interface ADImageView : UIImageView

@property (nonatomic,assign) BOOL hiddenTitle;
@property (nonatomic,copy) NSString* title;

@end
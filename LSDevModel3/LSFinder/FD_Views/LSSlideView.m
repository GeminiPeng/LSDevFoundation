//
//  LSSlideView.m
//  LSdiyView
//
//  Created by  tsou117 on 15/4/30.
//  Copyright (c) 2015年  tsou117. All rights reserved.
//

#import "LSSlideView.h"

//static NSUInteger //记录中间图片的下标,开始总是为1

@implementation LSSlideView
{
    NSUInteger currentImageIndex;
    UIScrollView* rootView;
    
    ADImageView* leftImgView;
    ADImageView* centerImgView;
    ADImageView* rightImgView;
    
    BOOL isUrl;
    
    SMPageControl* pagecontrol;
    
    NSTimer* mytimer;
    NSInteger timeCount;
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) [self setupImageView];
    
    return self;
}

#pragma mark - 自动滚动
- (void)loadTimer{
    
    if (!_imageUrlArr) {
        return;
    }
    
    mytimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(functionOfTimer:) userInfo:nil repeats:YES];
    if (_closeAutoSlide) {[mytimer setFireDate:[NSDate distantFuture]];}
    
    timeCount = 0;
}

- (void)functionOfTimer:(NSTimer*)sender{
    
    
    [rootView setContentOffset:CGPointMake(rootView.bounds.size.width*2, 0) animated:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:0.4f target:self selector:@selector(scrollViewDidEndDecelerating:) userInfo:nil repeats:NO];
}

- (void)setCloseAutoSlide:(BOOL)closeAutoSlide{
    _closeAutoSlide = closeAutoSlide;
    if (closeAutoSlide) {[mytimer setFireDate:[NSDate distantFuture]];}
}

#pragma mark - Setup Method

- (void)setupImageView{
    
    currentImageIndex = 0;//记录中间图片的下标,开始总是为1
    
    self.clipsToBounds = YES;
    
    rootView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:rootView];
    
    rootView.bounces = NO;
    rootView.clipsToBounds = YES;
    rootView.pagingEnabled = YES;
    rootView.scrollsToTop = NO;
    rootView.delegate = self;
    
    rootView.showsHorizontalScrollIndicator = NO;
    rootView.showsVerticalScrollIndicator = NO;
    
    CGFloat self_w = rootView.bounds.size.width;
    
    rootView.contentSize = CGSizeMake(self_w*3, self.bounds.size.height);
    
    rootView.contentOffset = CGPointMake(self_w, 0);
    
    
    
    leftImgView = [[ADImageView alloc] initWithFrame:CGRectMake(0, 0, self_w, self.bounds.size.height)];
    [rootView addSubview:leftImgView];
    
    centerImgView = [[ADImageView alloc] initWithFrame:CGRectMake(self_w, 0, self_w, self.bounds.size.height)];
    [rootView addSubview:centerImgView];
    
    rightImgView = [[ADImageView alloc] initWithFrame:CGRectMake(self_w*2, 0, self_w, self.bounds.size.height)];
    [rootView addSubview:rightImgView];
    
    for (ADImageView* obj in rootView.subviews) {
        obj.userInteractionEnabled = YES;
        obj.contentMode = UIViewContentModeScaleAspectFill;
        obj.clipsToBounds = YES;
        obj.hiddenTitle = YES;
        obj.image = kImage_placeHolder;
    }
    
    UITapGestureRecognizer* center_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionOfScelect:)];
    [centerImgView addGestureRecognizer:center_tap];
    
    
    //pc view
    
    UIView* pcView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-30, self.bounds.size.width, 30)];
    //    pcView.backgroundColor = [UIColor colorWithRed:0.000 green:0.035 blue:0.075 alpha:0.65];
    [self addSubview:pcView];
    
    pagecontrol = [[SMPageControl alloc] initWithFrame:pcView.bounds];
    pagecontrol.userInteractionEnabled = NO;
    pagecontrol.hidesForSinglePage = YES;
    pagecontrol.currentPageIndicatorTintColor = kColor_themeWithAlpha(1);
    pagecontrol.pageIndicatorTintColor = [UIColor whiteColor];
    [pcView addSubview:pagecontrol];
}

- (void)setPcalignment:(LSPageControlAlignment)pcalignment{
    _pcalignment = pcalignment;
    
    if (pcalignment == LSPageControlAlignmentLeft) {
        //
        pagecontrol.frame = CGRectMake(10, 0, 60, 30);
    }
    else if (pcalignment == LSPageControlAlignmentRight){
        //
        pagecontrol.frame = CGRectMake(self.bounds.size.width-60, 0, 60, 30);
        
    }
    
}
- (void)setPageIndicatorImage:(UIImage *)pageIndicatorImage{
    pagecontrol.pageIndicatorImage = pageIndicatorImage;
}
- (void)setCurrentPageIndicatorImage:(UIImage *)currentPageIndicatorImage{
    pagecontrol.currentPageIndicatorImage = currentPageIndicatorImage;
}

- (void)setImageArr:(NSArray *)imageArr{
    
    isUrl = NO;
    
    if (!imageArr || imageArr.count == 0) {
        //
        return;
    }
    
    _imageArr = imageArr;
    pagecontrol.numberOfPages = _imageArr.count;
    
    if (imageArr.count == 1)
    {
        //
        leftImgView.image = imageArr[0];
        centerImgView.image =  imageArr[0];
        rightImgView.image = imageArr[0];
        
    }else{
        //
        if (imageArr.count == 2)
        {
            //
            leftImgView.image = imageArr[1];
            centerImgView.image = imageArr[0];
            rightImgView.image = imageArr[1];
            
        }
        else
        {
            //
            leftImgView.image = imageArr[imageArr.count-1];
            centerImgView.image = imageArr[0];
            rightImgView.image = imageArr[1];
            
        }
        [self loadTimer];
        
    }
    
}

- (void)setImageUrlArr:(NSArray *)imageUrlArr{
    
    //
    currentImageIndex = 0;//记录中间图片的下标,开始总是为1
    
    isUrl = YES;
    
    if (!imageUrlArr || imageUrlArr.count == 0) {
        //
        
        _imageArr = nil;
        _imageUrlArr = nil;
        self.userInteractionEnabled = NO;
        [self setImageArr:@[kImage_placeHolder]];
        
        return;
    }
    _imageUrlArr = imageUrlArr;
    pagecontrol.numberOfPages = _imageUrlArr.count;
    
    if (imageUrlArr.count == 1)
    {
        //
        [leftImgView sd_setImageWithURL:[NSURL URLWithString:imageUrlArr[0]]];
        [centerImgView sd_setImageWithURL:[NSURL URLWithString:imageUrlArr[0]]];
        [rightImgView sd_setImageWithURL:[NSURL URLWithString:imageUrlArr[0]]];
        
        rootView.scrollEnabled = NO;
        
    }else{
        if (imageUrlArr.count == 2)
        {
            //
            [leftImgView sd_setImageWithURL:[NSURL URLWithString:imageUrlArr[1]]];
            [centerImgView sd_setImageWithURL:[NSURL URLWithString:imageUrlArr[0]]];
            [rightImgView sd_setImageWithURL:[NSURL URLWithString:imageUrlArr[1]]];
        }
        else
        {
            [leftImgView sd_setImageWithURL:[NSURL URLWithString:imageUrlArr[imageUrlArr.count-1]]];
            [centerImgView sd_setImageWithURL:[NSURL URLWithString:imageUrlArr[0]]];
            [rightImgView sd_setImageWithURL:[NSURL URLWithString:imageUrlArr[1]]];
        }
        
        [self loadTimer];
    }
    
}

- (void)setTitleArr:(NSArray *)titleArr{
    _titleArr = titleArr;
    
    if (!titleArr || titleArr.count == 0) {
        //
        for (ADImageView* obj in rootView.subviews) {
            obj.hiddenTitle = YES;
        }
        return;
    }
    
    //    self.hiddenPageControllView = YES;
    
    for (ADImageView* obj in rootView.subviews) {
        obj.hiddenTitle = NO;
    }
    
    if (titleArr.count == 1)
    {
        //
        leftImgView.title = titleArr[0];
        centerImgView.title = titleArr[0];
        rightImgView.title = titleArr[0];
    }
    else if (titleArr.count == 2)
    {
        //
        leftImgView.title = titleArr[1];
        centerImgView.title = titleArr[0];
        rightImgView.title = titleArr[1];
        
    }
    else
    {
        leftImgView.title = titleArr[titleArr.count-1];
        centerImgView.title = titleArr[0];
        rightImgView.title = titleArr[1];
        
    }
    
}

- (void)setHiddenPageControllView:(BOOL)hiddenPageControllView{
    _hiddenPageControllView = hiddenPageControllView;
    
    
    pagecontrol.hidden = hiddenPageControllView;
    
}

- (void)setContentMode:(UIViewContentMode)contentMode{
    
    for (UIImageView* obj in rootView.subviews) {
        obj.contentMode = contentMode;
    }
    
}

#pragma mark - 滑动

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
    if (isUrl) {
        //
        
        if (!_imageUrlArr)
        {
            return;
        }
        if (rootView.contentOffset.x == 0)
        {
            //
            if (currentImageIndex == 0) {
                //
                currentImageIndex = _imageUrlArr.count-1;
            }else{
                currentImageIndex = (currentImageIndex-1)%_imageUrlArr.count;
            }
        }
        else if (rootView.contentOffset.x == self.bounds.size.width*2)
        {
            currentImageIndex = (currentImageIndex+1)%_imageUrlArr.count;
        }
        else
        {
            return;
        }
        
        if (currentImageIndex == 0)
        {
            //
            [leftImgView sd_setImageWithURL:[NSURL URLWithString:_imageUrlArr[_imageUrlArr.count-1]]];
            leftImgView.title = _titleArr[_imageUrlArr.count-1];
        }else
        {
            [leftImgView sd_setImageWithURL:[NSURL URLWithString:_imageUrlArr[(currentImageIndex-1)%_imageUrlArr.count]]];
            leftImgView.title = _titleArr[(currentImageIndex-1)%_imageUrlArr.count];
        }
        
        [centerImgView sd_setImageWithURL:[NSURL URLWithString:_imageUrlArr[currentImageIndex%_imageUrlArr.count]]];
        centerImgView.title = _titleArr[currentImageIndex%_imageUrlArr.count];
        
        [rightImgView sd_setImageWithURL:[NSURL URLWithString:_imageUrlArr[(currentImageIndex+1)%_imageUrlArr.count]]];
        rightImgView.title = _titleArr[(currentImageIndex+1)%_imageUrlArr.count];
        
        rootView.contentOffset = CGPointMake(self.bounds.size.width, 0);
        
        pagecontrol.currentPage = currentImageIndex;
        
    }else{
        //
        if (!_imageArr) {
            
            return;
        }
        
        if (rootView.contentOffset.x == 0)
        {
            //
            if (currentImageIndex == 0) {
                //
                currentImageIndex = _imageArr.count-1;
            }else{
                currentImageIndex = (currentImageIndex-1)%_imageArr.count;
            }
        }
        else if (rootView.contentOffset.x == self.bounds.size.width*2)
        {
            //
            currentImageIndex = (currentImageIndex+1)%_imageArr.count;
            
        }
        else
        {
            //
            return;
        }
        
        if (currentImageIndex == 0) {
            //
            leftImgView.image = _imageArr[_imageArr.count-1];
            
        }else{
            leftImgView.image = _imageArr[(currentImageIndex-1)%_imageArr.count];
        }
        
        centerImgView.image = _imageArr[currentImageIndex%_imageArr.count];
        rightImgView.image = _imageArr[(currentImageIndex+1)%_imageArr.count];
        
        
        rootView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    }
    
    
    
}


- (void)actionOfScelect:(UITapGestureRecognizer*)sender{
    
    NSLog(@"index = %lu",currentImageIndex);
    if (self.selected) {
        self.selected(currentImageIndex);
    }
}

@end


@implementation ADImageView
{
    UILabel* titleLb;
    UIView* markview;
}
//
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        
        self.backgroundColor = [UIColor lightGrayColor];
        
        //
        markview = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-30, frame.size.width, 30)];
        markview.backgroundColor = [UIColor colorWithRed:0.000 green:0.035 blue:0.075 alpha:0.65];
        [self addSubview:markview];
        
        
        titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height-30, frame.size.width-60, 30)];
        //        titleLb.backgroundColor = [UIColor colorWithRed:0.000 green:0.035 blue:0.075 alpha:0.65];
        titleLb.font = [UIFont systemFontOfSize:12];
        titleLb.textColor = [UIColor whiteColor];
        [self addSubview:titleLb];
    }
    return self;
}

- (void)setHiddenTitle:(BOOL)hiddenTitle{
    _hiddenTitle = hiddenTitle;
    
    markview.hidden = hiddenTitle;
    titleLb.hidden = hiddenTitle;
}


- (void)setTitle:(NSString *)title{
    _title = title;
    titleLb.text = [NSString stringWithFormat:@"  %@",title];
}

@end














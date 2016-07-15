//
//  LSImgZoomView.m
//  MyDemo
//
//  Created by Sen on 15/1/25.
//  Copyright (c) 2015年  tsou117. All rights reserved.
//

#import "LSImgZoomView.h"

@implementation LSImgZoomView
{
    UIScrollView* rootScroller;
    
    UIScrollView* currScroller;
    UIImageView* zoomImgView;
    
    UIView* toolView;
    
    int count;
    
    CGRect first_fm;
    
    NSArray* _imgUrlArr;
    NSInteger currIndex;
    
    //数量标识
    UILabel* markLb;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

#pragma mark - if

#pragma mark - else

- (id)initWithFirstFrame:(CGRect)frame1 withImgUrlArr:(NSArray*)imgUrlArr withIndexImg:(NSInteger)index
{
    self = [super init];
    if (self) {
        //
        first_fm = CGRectMake(20, (kSCREEN_HEIGHT-kSCREEN_WIDTH*0.5)*0.5, kSCREEN_WIDTH-40, kSCREEN_WIDTH*0.5);
        _imgUrlArr = imgUrlArr;
        
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        
        rootScroller = [[UIScrollView alloc] initWithFrame:self.bounds];
        rootScroller.pagingEnabled = YES;
        rootScroller.delegate = self;
        rootScroller.scrollsToTop = NO;
        rootScroller.showsHorizontalScrollIndicator = NO;
        rootScroller.backgroundColor = [UIColor colorWithRed:0.031 green:0.031 blue:0.031 alpha:0];
        [self addSubview:rootScroller];
        
        
        rootScroller.contentSize = CGSizeMake(self.bounds.size.width*_imgUrlArr.count, self.bounds.size.height);
        [rootScroller setContentOffset:CGPointMake(index*self.bounds.size.width, 0)];
        
        currIndex = index;
        
        for (int i = 0; i< _imgUrlArr.count; i++) {
            //
            UIScrollView *scrV = [[UIScrollView alloc] initWithFrame:CGRectMake(i*self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
            scrV.delegate = self;
            scrV.tag = 100+i;
            [scrV setShowsHorizontalScrollIndicator:NO];
            [scrV setShowsVerticalScrollIndicator:NO];
            [scrV setMaximumZoomScale:2.0];
            [scrV setMinimumZoomScale:1.0];
            [rootScroller addSubview:scrV];
            
            UIImageView* imgV = [[UIImageView alloc] initWithFrame: i == index ? first_fm : CGRectMake((kSCREEN_WIDTH-60)*0.5, (kSCREEN_HEIGHT-60)*0.5, 60, 60)];
            imgV.tag = 200+i;
            imgV.userInteractionEnabled = YES;
            imgV.contentMode = UIViewContentModeScaleAspectFill;
            imgV.clipsToBounds = YES;
            imgV.backgroundColor = [UIColor lightGrayColor];
            [scrV addSubview:imgV];
            
            if (currIndex == i) {
                //
                
                [imgV sd_setImageWithURL:[NSURL URLWithString:_imgUrlArr[i]] placeholderImage:kImage_placeHolder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    //
                    if (image) {
                        //
                        [self changeImgFrameWith:image.size];
                    }
                }];
                
            }else{
                imgV.image = kImage_placeHolder;
            }
            
            
            //双击
            UITapGestureRecognizer* bigTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigtapAction:)];
            bigTap.numberOfTapsRequired = 2;
            bigTap.numberOfTouchesRequired = 1;
            [imgV addGestureRecognizer:bigTap];
            
            //关闭
            UITapGestureRecognizer* backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionOfBack:)];
            backTap.numberOfTapsRequired = 1;
            backTap.numberOfTouchesRequired = 1;
            [backTap requireGestureRecognizerToFail:bigTap];//
            [scrV addGestureRecognizer:backTap];
            
        }
        
        currScroller = (UIScrollView*)[rootScroller viewWithTag:100+currIndex];
        zoomImgView = (UIImageView*)[currScroller viewWithTag:200+currIndex];
        zoomImgView.alpha = 0;
        
        [self changeImgFrameWith:zoomImgView.image.size];
        
        //toolview
        toolView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-44, self.bounds.size.width, 44)];
        toolView.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:0.031 green:0.031 blue:0.031 alpha:0.55];
        [self addSubview:toolView];
        
        markLb = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 20, 34)];//self.bounds.size.height-44
        markLb.textAlignment = 2;
        markLb.textColor = [UIColor whiteColor];
        markLb.font = [UIFont systemFontOfSize:16];
        markLb.text = [NSString stringWithFormat:@"%ld",index+1];
        [toolView addSubview:markLb];
        
        UILabel* markLb2 = [[UILabel alloc] initWithFrame:CGRectMake(30, 12, 60, 32)];
        markLb2.textAlignment = 0;
        markLb2.textColor = [UIColor whiteColor];
        markLb2.font = [UIFont systemFontOfSize:12];
        markLb2.text = [NSString stringWithFormat:@" /%lu",(unsigned long)_imgUrlArr.count];
        [toolView addSubview:markLb2];
        
        //下载
        UIButton* downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        downBtn.frame = CGRectMake(self.bounds.size.width-54, 0, 54, 44);
        [downBtn setImage:[UIImage imageNamed:@"download.png"] forState:UIControlStateNormal];
        [downBtn setImage:[UIImage imageNamed:@"download-click.png"] forState:UIControlStateHighlighted];
        [downBtn addTarget:self action:@selector(actionOfDown:) forControlEvents:UIControlEventTouchUpInside];
        [toolView addSubview:downBtn];
        
    }
    
    return self;
}

- (void)changeImgFrameWith:(CGSize)imgSize{
    
    //    CGSize imgSize = zoomImgView.image.size;
    
    CGRect newRect;
    
    if (self.bounds.size.width*imgSize.height/imgSize.width>self.bounds.size.height)
    {
        //
        newRect = CGRectMake(
                             0,
                             0,
                             self.bounds.size.width,
                             self.bounds.size.width*imgSize.height/imgSize.width);
        currScroller.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.width*imgSize.height/imgSize.width);
    }
    else
    {
        //
        newRect = CGRectMake(
                             0,
                             (self.bounds.size.height-self.bounds.size.width*imgSize.height/imgSize.width)/2,
                             self.bounds.size.width,
                             self.bounds.size.width*imgSize.height/imgSize.width);
    }
    
    [UIView transitionWithView:self duration:kAnimationDurationTime options:UIViewAnimationOptionCurveEaseInOut animations:^{
        // currScroller.frame = self.bounds;
        zoomImgView.frame = newRect;
        zoomImgView.alpha = 1;

        rootScroller.backgroundColor = [UIColor colorWithRed:0.031 green:0.031 blue:0.031 alpha:0.85];
    } completion:^(BOOL ok){
        
    }];
    
}

- (void)actionOfBack:(UITapGestureRecognizer*)sender{
    
    //zoomImgView.contentMode = UIViewContentModeTop;
    self.backgroundColor = [UIColor clearColor];
    [currScroller setZoomScale:1.0 animated:YES];
    
    [UIView transitionWithView:self duration:0.35 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        // [currScroller setFrame:first_fm];
        [zoomImgView setFrame:first_fm];
        zoomImgView.alpha = 0;
        rootScroller.backgroundColor = [UIColor colorWithRed:0.031 green:0.031 blue:0.031 alpha:0];
    } completion:^(BOOL finished){
        if (finished) {
            [self removeFromSuperview];
        }
        if (self.BlockClose) {
            self.BlockClose(YES);
        }
    }];
    
}

- (void)show{
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    
}

//每个双击大图的手势
-(void)bigtapAction:(UITapGestureRecognizer*)Gesture{
    if (Gesture.state==UIGestureRecognizerStateEnded) {
        if (count==0) {
            [currScroller setZoomScale:2.0 animated:YES];
            
            count=1;
        }else{
            [currScroller setZoomScale:1.0 animated:YES];
            count=0;
            
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == rootScroller) {
        //
        
        //先还原前一个图片的状态
        [currScroller setZoomScale:1.0 animated:NO];
        count = 0;
        
        currIndex = scrollView.contentOffset.x/self.bounds.size.width;
        markLb.text = [NSString stringWithFormat:@"%ld",currIndex+1];
        
        //新的
        currScroller = (UIScrollView*)[self viewWithTag:100+currIndex];
        zoomImgView = (UIImageView*)[currScroller viewWithTag:200+currIndex];
        
        
        [zoomImgView sd_setImageWithURL:[NSURL URLWithString:_imgUrlArr[currIndex]] placeholderImage:kImage_placeHolder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //
            if (image) {
                //
                [self changeImgFrameWith:image.size];
            }
        }];
        
    }
    
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    
    if (zoomImgView && scrollView == currScroller) {
        return zoomImgView;
    }
    return nil;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    if (zoomImgView && scrollView == currScroller) {
        CGFloat offsetX = (currScroller.bounds.size.width > currScroller.contentSize.width)?
        
        (currScroller.bounds.size.width - currScroller.contentSize.width) * 0.5 : 0.0;
        
        CGFloat offsetY = (currScroller.bounds.size.height > currScroller.contentSize.height)?
        
        (currScroller.bounds.size.height - currScroller.contentSize.height) * 0.5 : 0.0;
        
        zoomImgView.center = CGPointMake(currScroller.contentSize.width * 0.5 + offsetX,
                                         
                                         currScroller.contentSize.height * 0.5 + offsetY);
    }
}

#pragma mark - 下载
- (void)actionOfDown:(UIButton*)sender{
    
    UIImageWriteToSavedPhotosAlbum(zoomImgView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error != NULL) {
        
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
        
    }else{
        
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }
}

@end

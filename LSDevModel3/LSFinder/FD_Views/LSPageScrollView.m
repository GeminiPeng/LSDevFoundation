//
//  LSPageScrollView.m
//  LSPageControl
//
//  Created by  sen on 15/8/28.
//  Copyright (c) 2015年  sen. All rights reserved.
//

#import "LSPageScrollView.h"



@implementation LSPageScrollView
{
    UIScrollView* myscrollview;
    
    UIView* pagecontrolview;
    
    NSMutableArray* markimgs;
    
    UIView* pagebgview;
    UIImageView* moveMark;
    
    NSInteger _count;
    LSPageItemClass _itemclass;
    
    //
    BOOL isoverflow;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithFrame:(CGRect)frame
                    itemCount:(NSInteger)count
                     itemSize:(CGSize)itemsize
               itemInterspace:(CGFloat)interspace
                    itemClass:(LSPageItemClass)itemclass
                     complete:(blockAllItems)allitems{
    
    self = [super initWithFrame:frame];
    if (self) {
        //
        _count = count;
        _itemclass = itemclass;
        
        myscrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        myscrollview.scrollsToTop = NO;
        myscrollview.showsHorizontalScrollIndicator = NO;
        myscrollview.delegate = self;
        myscrollview.pagingEnabled = YES;
        [self addSubview:myscrollview];
        
        //
        NSMutableArray* items = [NSMutableArray array];
        
        CGFloat sub_w = 0;
        for (int i = 0; i<count; i++) {
            // 初始随自己意愿 imageView或者button
            
            [self loadItemClassWithFrame:CGRectMake(interspace+i*(itemsize.width+interspace), 0, itemsize.width, itemsize.height) addOnArray:items];
            sub_w += interspace + itemsize.width;
        }
        sub_w += interspace;
        
        myscrollview.contentSize = CGSizeMake(sub_w, myscrollview.bounds.size.height);
        isoverflow = myscrollview.contentSize.width > myscrollview.bounds.size.width;
        
        //
        
        allitems(items);
        
        //page control view
        
        markimgs = [NSMutableArray array];
        
        pagecontrolview = [[UIView alloc] initWithFrame:CGRectMake(0, itemsize.height, self.frame.size.width, 20)];
        [self addSubview:pagecontrolview];
        
        //tb3 tb4 jx10
        
        pagebgview = [[UIView alloc] initWithFrame:CGRectZero];
        [pagecontrolview addSubview:pagebgview];
        
        [self loadPageControlSubViews];
        
    }
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame
                    itemCount:(NSInteger)count
                     itemSize:(CGSize)itemsize
               itemInterspace:(CGFloat)interspace
                    itemClass:(LSPageItemClass)itemclass
             indexOfBreakLine:(NSInteger)index
                     complete:(blockAllItems)allitems{
    
    self = [super initWithFrame:frame];
    if (self) {
        //
        _count = count;
        _itemclass = itemclass;
        
        myscrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        myscrollview.scrollsToTop = NO;
        myscrollview.showsHorizontalScrollIndicator = NO;
        myscrollview.delegate = self;
        myscrollview.pagingEnabled = YES;
        [self addSubview:myscrollview];
        
        myscrollview.contentSize = CGSizeMake(itemsize.width*index, myscrollview.bounds.size.height);
        
        int j = 0, k = 0;
        NSMutableArray* tmparr = [NSMutableArray array];
        for (int i = 0; i<count; i++) {
            //
            if (j>=index) {
                k++;
                j = 0;
            }
            [self loadItemClassWithFrame:CGRectMake(interspace+(itemsize.width+interspace)*j, itemsize.height*k, itemsize.width, itemsize.height) addOnArray:tmparr];
            
            j++;
        }
        
        allitems(tmparr);
        
        
        //
        //        NSMutableArray* items = [NSMutableArray array];
        //
        //        CGFloat sub_w = 0;
        //        for (int i = 0; i<count; i++) {
        //            // 初始随自己意愿 imageView或者button
        //
        //            [self loadItemClassWithFrame:CGRectMake(interspace+i*(itemsize.width+interspace), 0, itemsize.width, itemsize.height) addOnArray:items];
        //            sub_w += interspace + itemsize.width;
        //        }
        //        sub_w += interspace;
        //
        //        myscrollview.contentSize = CGSizeMake(sub_w, myscrollview.bounds.size.height);
        //        isoverflow = myscrollview.contentSize.width > myscrollview.bounds.size.width;
        //
        //        //
        //        allitems(items);
        //
        //        //page control view
        //
        //        markimgs = [NSMutableArray array];
        //
        //        pagecontrolview = [[UIView alloc] initWithFrame:CGRectMake(0, itemsize.height, self.frame.size.width, 20)];
        //        [self addSubview:pagecontrolview];
        //
        //        //tb3 tb4 jx10
        //
        //        pagebgview = [[UIView alloc] initWithFrame:CGRectZero];
        //        [pagecontrolview addSubview:pagebgview];
        //
        //        [self loadPageControlSubViews];
        
    }
    return self;
    
}


#pragma mark - LSPageItemClass

- (void)loadItemClassWithFrame:(CGRect)frame addOnArray:(NSMutableArray*)items{
    //
    
    if (_itemclass == LSPageItemClassButton) {
        //
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [LSFactory fc_randomColor];
        btn.frame = frame;
        btn.clipsToBounds = YES;
        [myscrollview addSubview:btn];
        [items addObject:btn];
    }
    if (_itemclass == LSPageItemClassImageView) {
        //
        UIImageView* imgview = [[UIImageView alloc] initWithFrame:frame];
        imgview.contentMode = UIViewContentModeScaleAspectFill;
        imgview.userInteractionEnabled = YES;
        imgview.clipsToBounds = YES;
        [myscrollview addSubview:imgview];
        [items addObject:imgview];
    }
    if (_itemclass == LSPageItemClassDiyView1) {
        //
        LSDIYView1* diyview1 = [[NSBundle mainBundle] loadNibNamed:@"LSDIYView1" owner:nil options:nil][0];
        diyview1.frame = frame;
        [myscrollview addSubview:diyview1];
        [items addObject:diyview1];
    }
    if (_itemclass == LSPageItemClassDiyView2) {
        //
        LSDIYView2* diyview2 = [[NSBundle mainBundle] loadNibNamed:@"LSDIYView2" owner:nil options:nil][0];
        diyview2.frame = frame;
        [myscrollview addSubview:diyview2];
        [items addObject:diyview2];
    }
    //more case ...
    
}


#pragma mark - pageContentrol subviews

- (void)loadPageControlSubViews{
    //
    if (!isoverflow) {
        //
        return;
    }
    //def
    for (int i = 0; i<_count; i++) {
        UIImageView* imgv = [[UIImageView alloc] initWithFrame:CGRectZero];
        imgv.backgroundColor = [UIColor lightGrayColor];
        [pagebgview addSubview:imgv];
        [markimgs addObject:imgv];
        imgv.image = _defaultPageIndicatorImage;
        
        if (_defaultPageIndicatorImage) {
            imgv.backgroundColor = [UIColor clearColor];
        }
        
    }
    
    //cur
    moveMark = [[UIImageView alloc] initWithFrame:CGRectZero];
    moveMark.backgroundColor = [UIColor blueColor];
    moveMark.image = _currentPageIndicatorImage;
    
    if (_currentPageIndicatorImage) {
        moveMark.backgroundColor = [UIColor clearColor];
    }
    [pagebgview addSubview:moveMark];
    
    [self reloadPageViewSize];
}

- (void)reloadPageViewSize{
    
    CGSize pageSize_def = CGSizeMake(12, 12);
    CGSize pageSize_cur = CGSizeMake(12, 12);
    
    if (_defaultPageIndicatorImage) {pageSize_def = _defaultPageIndicatorImage.size;}
    if (_currentPageIndicatorImage) {pageSize_cur = _currentPageIndicatorImage.size;}
    
    CGFloat bg_w = pageSize_def.width*0.5*_count+PAGECONTROL_jx*(_count-1);
    CGFloat bg_h = pageSize_def.height*0.5;
    
    pagebgview.frame = CGRectMake(CGRectGetMidX(pagecontrolview.frame)-bg_w*0.5, CGRectGetMidY(pagecontrolview.bounds)-bg_h*0.5, bg_w, bg_h);
    
    //def
    for (int i = 0; i<markimgs.count; i++) {
        UIImageView* imgv = (UIImageView*)markimgs[i];
        imgv.frame = CGRectMake(i*(pageSize_def.width*0.5+PAGECONTROL_jx), 0, pageSize_def.width*0.5, pageSize_def.height*0.5);
    }
    
    //cur
    moveMark.frame = CGRectMake(0, 0, pageSize_cur.width*0.5, pageSize_cur.height*0.5);
}

#pragma mark - SET

- (void)setPages:(NSInteger)pages{
    
    _count = pages;
    
    [markimgs removeAllObjects];
    
    for (UIView* obj in pagebgview.subviews) {
        [obj removeFromSuperview];
    }
    
    [self loadPageControlSubViews];
}

- (void)setShowstyle:(LSPageShowStyle)showstyle{
    //未实现
    _showstyle = showstyle;
    
}

- (void)setPagingEnabled:(BOOL)pagingEnabled{
    _pagingEnabled = pagingEnabled;
    myscrollview.pagingEnabled = _pagingEnabled;
}
- (void)setHiddenPageControl:(BOOL)hiddenPageControl{
    _hiddenPageControl = hiddenPageControl;
    
    [pagecontrolview removeFromSuperview];
}

- (void)setDefaultPageIndicatorImage:(UIImage *)defaultPageIndicatorImage{
    _defaultPageIndicatorImage = defaultPageIndicatorImage;
    for (UIImageView* imgv in markimgs) {
        //
        imgv.image = defaultPageIndicatorImage;
        imgv.backgroundColor = [UIColor clearColor];
    }
    [self reloadPageViewSize];
}
- (void)setCurrentPageIndicatorImage:(UIImage *)currentPageIndicatorImage{
    
    _currentPageIndicatorImage = currentPageIndicatorImage;
    moveMark.image = currentPageIndicatorImage;
    moveMark.backgroundColor = [UIColor clearColor];
    [self reloadPageViewSize];
    
}

- (void)setIsCenterBegin:(BOOL)isCenterBegin{
    _isCenterBegin = isCenterBegin;
    
    if (_isCenterBegin) {
        //
        
        myscrollview.contentOffset = CGPointMake((myscrollview.contentSize.width-myscrollview.bounds.size.width)*0.5, 0);
        
        [self performSelector:@selector(scrollViewDidScroll:) withObject:myscrollview afterDelay:0.5];
    }
    
}

- (void)setAlwaysBounceHorizontal:(BOOL)alwaysBounceHorizontal{
    _alwaysBounceHorizontal = alwaysBounceHorizontal;
    
    
    if (_alwaysBounceHorizontal && !isoverflow) {
        //
        
        CGFloat interspace = (myscrollview.bounds.size.width-myscrollview.contentSize.width)*0.5;
        myscrollview.contentInset = UIEdgeInsetsMake(0, interspace, 0, interspace);
        
        
    }
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //
    CGFloat scroll_content_w = myscrollview.contentSize.width-myscrollview.bounds.size.width;
    CGFloat scroll_curr_x = scrollView.contentOffset.x;
    
    CGFloat move_content_w = moveMark.superview.bounds.size.width-moveMark.bounds.size.width;
    
    //求当前滑块的x坐标
    CGFloat move_curr_x = move_content_w*scroll_curr_x/scroll_content_w;
    
    moveMark.frame = CGRectMake(move_curr_x, 0, moveMark.frame.size.width, moveMark.frame.size.height);
    
}

@end

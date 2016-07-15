//
//  LSAlertView.m
//  LSDevModel2
//
//  Created by  tsou117 on 16/1/18.
//  Copyright (c) 2016年  tsou117. All rights reserved.
//

#import "LSAlertView.h"

#define kBaseTag 100

@implementation LSAlertView
{
    //
    NSMutableArray* btnArray;
    NSMutableArray* btnTitleArray;
    
    //
    NSString* _title;
    NSString* _message;
    
    NSString* _cancelbuttontitle;
    
    //
    CGFloat subviews_h;
    
    //
    UIView* rootview;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<LSAlertViewDelegate>)delegate cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString *)buttonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    self = [super init];
    if (self) {
        //
        
        subviews_h = 10;
        _delegate = delegate;
        _title = [LSFactory fc_judgeObj:title placeholder:nil];
        _message = [LSFactory fc_judgeObj:message placeholder:nil];
        _cancelbuttontitle = [LSFactory fc_judgeObj:cancelButtonTitle placeholder:@"取消"];    //取消按钮必有
        
        btnArray = [NSMutableArray array];
        btnTitleArray = [NSMutableArray array];
        
        //
        
        NSMutableArray* tmp_otherButtonTitles = [NSMutableArray array];
        
        va_list args;
        va_start(args, buttonTitles);
        
        if (buttonTitles){
            //
            [tmp_otherButtonTitles addObject:buttonTitles];
            while (1){
                //
                NSString* otherBtnTitle = va_arg(args, NSString*);
                if(otherBtnTitle == nil){
                    break;
                }else{
                    [tmp_otherButtonTitles addObject:otherBtnTitle];
                }
            }
        }
        va_end(args);
        
        //
        BOOL hasMoreOtherBtn = tmp_otherButtonTitles.count > 1;
        
        if(hasMoreOtherBtn){
            //
            [btnTitleArray addObjectsFromArray:tmp_otherButtonTitles];
            for (int i = 0; i< btnTitleArray.count; i++) {
                //
                [btnArray addObject:[self newButtonWithTag:kBaseTag+i+1]];
            }
            
            [btnTitleArray addObject:_cancelbuttontitle];
            [btnArray addObject:[self newButtonWithTag:kBaseTag]];
            
        }else{
            //
            [btnTitleArray addObject:_cancelbuttontitle];
            [btnArray addObject:[self newButtonWithTag:kBaseTag]];
            
            [btnTitleArray addObjectsFromArray:tmp_otherButtonTitles];
            for (int i = 1; i< btnTitleArray.count; i++) {
                //
                [btnArray addObject:[self newButtonWithTag:kBaseTag+i]];
            }
        }

        
        //
        self.frame = kSCREEN_RECT;
        self.backgroundColor = [UIColor colorWithRed:0.031 green:0.031 blue:0.031 alpha:0];
        
        rootview = [[UIView alloc] initWithFrame:CGRectMake((kSCREEN_WIDTH-270)*0.5, 0, 270, 44)];
        rootview.backgroundColor = [UIColor whiteColor];
        rootview.clipsToBounds = YES;
        rootview.layer.cornerRadius = 8;
        rootview.center = self.center;
        [self addSubview:rootview];
        
        //
        [self initContentViews];
        
        //
        [UIView animateWithDuration:kAnimationDurationTime animations:^{
            //
            self.backgroundColor = [UIColor colorWithRed:0.031 green:0.031 blue:0.031 alpha:0.4];
        }];
        [self setShow:YES withView:rootview];
        
        //
        UITapGestureRecognizer* nulltap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionOfNullTap)];
        [rootview addGestureRecognizer:nulltap];
        //
        UITapGestureRecognizer* backtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionOfBackTap)];
        [self addGestureRecognizer:backtap];
    }
    return self;
}

#pragma mark - 内容视图
- (void)initContentViews{
    //
    if (_title) {[self addTitleLb];}
    if (_message) {[self addContentLb];}
    
    [self addBottomButtons];
    
    subviews_h += 10;
    rootview.frame = CGRectMake((kSCREEN_WIDTH-270)*0.5, 0, 270, subviews_h);
    rootview.center = self.center;
}

- (void)addTitleLb{

    UILabel* titlelb = [[UILabel alloc] initWithFrame:CGRectMake(10, subviews_h, rootview.bounds.size.width-20, 30)];
    titlelb.text = _title;
    titlelb.numberOfLines = 0;
    titlelb.lineBreakMode = NSLineBreakByWordWrapping;
    titlelb.font = [UIFont boldSystemFontOfSize:18];
    titlelb.textColor = [UIColor colorWithRed:0.247 green:0.247 blue:0.247 alpha:1];
    [rootview addSubview:titlelb];
    [titlelb sizeToFit];
    
    titlelb.frame = CGRectMake((rootview.bounds.size.width-titlelb.bounds.size.width)*0.5, titlelb.frame.origin.y, titlelb.bounds.size.width, titlelb.bounds.size.height);
    
    subviews_h += titlelb.bounds.size.height;
}

- (void)addContentLb{
    //
    
    subviews_h += 10;
    
    UILabel* contentlb = [[UILabel alloc] initWithFrame:CGRectMake(10, subviews_h, rootview.bounds.size.width-20, 30)];
    contentlb.text = _message;
    contentlb.numberOfLines = 0;
    contentlb.textAlignment = 1;
    contentlb.lineBreakMode = NSLineBreakByWordWrapping;
    contentlb.font = [UIFont systemFontOfSize:14];
    contentlb.textColor = [UIColor colorWithRed:0.200 green:0.200 blue:0.200 alpha:1];
    [rootview addSubview:contentlb];
    [contentlb sizeToFit];
    
    contentlb.frame = CGRectMake((rootview.bounds.size.width-contentlb.bounds.size.width)*0.5, contentlb.frame.origin.y, contentlb.bounds.size.width, contentlb.bounds.size.height);
    
    subviews_h += contentlb.bounds.size.height;
}

- (void)addBottomButtons{
    //
    
    subviews_h += 10;
    
    CGFloat bgv_h = (btnTitleArray.count > 2) ? 31*btnTitleArray.count + 10*(btnTitleArray.count-1) : 31;
    
    UIView* bgview = [[UIView alloc] initWithFrame:CGRectMake(22.5, subviews_h, rootview.bounds.size.width-45, bgv_h)];
    [rootview addSubview:bgview];
    
    
    CGFloat btn_w = (btnTitleArray.count == 2) ? (bgview.bounds.size.width-20)*0.5 : bgview.bounds.size.width;
    CGFloat btn_h = 31;
    
    for (int i = 0; i<btnTitleArray.count; i++) {
        //
        
        UIButton* btn = btnArray[i];
        [btn setTitle:btnTitleArray[i] forState:UIControlStateNormal];
        btn.backgroundColor = btn.tag == kBaseTag ? [UIColor colorWithRed:0.961 green:0.961 blue:0.961 alpha:1] : [UIColor colorWithRed:0.945 green:0.133 blue:0.251 alpha:1];
        [btn setTitleColor:btn.tag == kBaseTag ? [UIColor colorWithRed:0.357 green:0.357 blue:0.357 alpha:1] : [UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(actionOfClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bgview addSubview:btn];
        
        if (btnTitleArray.count == 1) {
            //
            btn.frame = CGRectMake(0, 0, btn_w, btn_h);

        }else if (btnTitleArray.count == 2) {
            //
            btn.frame = CGRectMake((20+btn_w)*i, 0, btn_w, btn_h);
            
        }else if (btnTitleArray.count > 2){
            //
            btn.frame = CGRectMake(0, (10+31)*i, btn_w, btn_h);
        }

    }
    
    subviews_h += bgview.bounds.size.height;
}

- (void)actionOfClicked:(UIButton*)sender{
    
    //block
    
    //delegate
    if (_delegate && [_delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        //
        [_delegate alertView:self clickedButtonAtIndex:sender.tag-kBaseTag];
    }
    
    [self removeSelfWithAnimation];
}

#pragma mark - 展示
- (void)show{
    //
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    
}

#pragma mark - action of ...
- (void)actionOfNullTap{
    //no code ...
    
}

- (void)actionOfBackTap{
    //
    
    [self removeSelfWithAnimation];
    
}

- (void)removeSelfWithAnimation{
    //
    
    [self setShow:NO withView:rootview];
    
    [UIView transitionWithView:self duration:kAnimationDurationTime options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //
        self.backgroundColor = [UIColor colorWithRed:0.031 green:0.031 blue:0.031 alpha:0];
        rootview.backgroundColor = [UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:0];
        
        for (UIButton* obj in rootview.subviews) {
            //
            obj.alpha = 0;
        }
        for (UILabel* obj in rootview.subviews) {
            obj.alpha = 0;
        }
        
    } completion:^(BOOL finished) {
        //
        [self removeFromSuperview];
        
    }];
}

#pragma mark - ELSE

- (UIButton*)newButtonWithTag:(NSInteger)tag{
    //
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
//    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    btn.layer.cornerRadius = 4;
    btn.layer.borderWidth = 0.5;
    btn.tag = tag;
    btn.layer.borderColor = kColor_line.CGColor;
    return btn;
}
- (void)setShow:(BOOL)show withView:(UIView*)aview{
    //
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = kAnimationDurationTime;
    
    NSMutableArray* values = [NSMutableArray array];
    if (show) {
        //
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    }else{
        //
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    }
    animation.values = values;
    [aview.layer addAnimation:animation forKey:nil];
}


@end

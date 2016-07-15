//
//  LSPaoMaView.m
//  LSDevelopmentModel
//
//  Created by  tsou117 on 15/7/29.
//  Copyright (c) 2015年  tsou117. All rights reserved.
//

#import "LSPaoMaView.h"

@implementation LSPaoMaView
{
    
    CGRect rectMark1;//标记第一个位置
    CGRect rectMark2;//标记第二个位置
    
    NSMutableArray* labelArr;
    
    NSTimeInterval timeInterval;//时间
    
    BOOL isStop;//停止
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - //一句话跑马灯

- (instancetype)initWithFrame:(CGRect)frame title:(NSString*)title
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        title = [NSString stringWithFormat:@"  %@  ",title];//间隔
        
        timeInterval = [self displayDurationForString:title];
        
        self.backgroundColor = [UIColor blackColor];
        self.clipsToBounds = YES;
        
        //
        UILabel* textLb = [[UILabel alloc] initWithFrame:CGRectZero];
        textLb.textColor = TEXTCOLOR;
        textLb.font = [UIFont boldSystemFontOfSize:TEXTFONTSIZE];
        textLb.text = title;
        
        //计算textLb大小
        CGSize sizeOfText = [textLb sizeThatFits:CGSizeZero];
        
        rectMark1 = CGRectMake(0, 0, sizeOfText.width, self.bounds.size.height);
        rectMark2 = CGRectMake(rectMark1.origin.x+rectMark1.size.width, 0, sizeOfText.width, self.bounds.size.height);
        
        textLb.frame = rectMark1;
        [self addSubview:textLb];
        
        labelArr = [NSMutableArray arrayWithObject:textLb];

        
        //判断是否需要reserveTextLb
        BOOL useReserve = sizeOfText.width > frame.size.width ? YES : NO;
        
        if (useReserve) {
            //alloc reserveTextLb ...
            
            UILabel* reserveTextLb = [[UILabel alloc] initWithFrame:rectMark2];
            reserveTextLb.textColor = TEXTCOLOR;
            reserveTextLb.font = [UIFont boldSystemFontOfSize:TEXTFONTSIZE];
            reserveTextLb.text = title;
            [self addSubview:reserveTextLb];
            
            [labelArr addObject:reserveTextLb];
            
            [self paomaAnimate];
        }
  
    }
    return self;
}

#pragma mark - //多句话跑马灯 可点击

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray*)titlearr
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        
        
        self.backgroundColor = [UIColor blackColor];
        self.clipsToBounds = YES;
        
        //
        UIView* view1 = [self loadRootmoveViewWithTitles:titlearr];

        rectMark1 = CGRectMake(0, 0, view1.bounds.size.width, self.bounds.size.height);
        rectMark2 = CGRectMake(rectMark1.origin.x+rectMark1.size.width, 0, view1.bounds.size.width, self.bounds.size.height);
        
        view1.frame = rectMark1;
        [self addSubview:view1];
        
        labelArr = [NSMutableArray arrayWithObject:view1];
        
        //判断是否需要reserveView
        BOOL useReserve = view1.bounds.size.width > frame.size.width ? YES : NO;
        
        if (useReserve) {
            //
            UIView* view2 = [self loadRootmoveViewWithTitles:titlearr];
        
            view2.frame = rectMark2;
            [self addSubview:view2];
            [labelArr addObject:view2];
            
            [self paomaAnimate];
        }
  
    }
    return self;
}

- (UIView*)loadRootmoveViewWithTitles:(NSArray*)titles{
    
    UIView* view1 = [[UIView alloc] initWithFrame:CGRectZero];
//    view1.backgroundColor = [LSFactory fc_randomColor];
    view1.clipsToBounds = YES;
    
    //计算view1上的文字总长,也就是view1的宽度
    
    CGFloat view_width = 0;
    timeInterval = 0;
    
    for (int i = 0; i<titles.count; i++) {
        //
        
        NSString* title = [NSString stringWithFormat:@"  %@  ",titles[i]];
        
        //
        UILabel* textLb = [[UILabel alloc] initWithFrame:CGRectZero];
        textLb.textColor = TEXTCOLOR;
        textLb.font = [UIFont boldSystemFontOfSize:TEXTFONTSIZE];
        textLb.text = title;
        [view1 addSubview:textLb];
        
        CGFloat widthOfText = [textLb sizeThatFits:CGSizeZero].width;
        
        textLb.frame = CGRectMake(view_width, 0, widthOfText, self.bounds.size.height);
        
        view_width += widthOfText;
        
        //
        double tmp = [self displayDurationForString:title];
        timeInterval += tmp;
    }
    view1.frame = CGRectMake(0, 0, view_width, self.bounds.size.height);

    return view1;
}



#pragma mark //开始动画
- (void)paomaAnimate{
    
    if (!isStop) {
        //
        UIView* lbindex0 = labelArr[0];
        UIView* lbindex1 = labelArr[1];
        
//        [UIView animateWithDuration:timeInterval animations:^{
//            //
//            lbindex0.frame = CGRectMake(-rectMark1.size.width, 0, rectMark1.size.width, rectMark1.size.height);
//            lbindex1.frame = CGRectMake(lbindex0.frame.origin.x+lbindex0.frame.size.width, 0, lbindex1.frame.size.width, lbindex1.frame.size.height);
//            
//        } completion:^(BOOL finished) {
//            //
//            lbindex0.frame = rectMark2;
//            lbindex1.frame = rectMark1;
//            
//            [labelArr replaceObjectAtIndex:0 withObject:lbindex1];
//            [labelArr replaceObjectAtIndex:1 withObject:lbindex0];
//            
//            [self paomaAnimate];
//        }];
        
        [UIView transitionWithView:self duration:timeInterval options:UIViewAnimationOptionCurveLinear animations:^{
            //
            
            lbindex0.frame = CGRectMake(-rectMark1.size.width, 0, rectMark1.size.width, rectMark1.size.height);
            lbindex1.frame = CGRectMake(lbindex0.frame.origin.x+lbindex0.frame.size.width, 0, lbindex1.frame.size.width, lbindex1.frame.size.height);
            
        } completion:^(BOOL finished) {
            //
            lbindex0.frame = rectMark2;
            lbindex1.frame = rectMark1;
            
            [labelArr replaceObjectAtIndex:0 withObject:lbindex1];
            [labelArr replaceObjectAtIndex:1 withObject:lbindex0];
            
            [self paomaAnimate];
        }];
    }
}


#pragma mark

- (void)start{
    isStop = NO;
    UIView* lbindex0 = labelArr[0];
    UIView* lbindex1 = labelArr[1];
    lbindex0.frame = rectMark2;
    lbindex1.frame = rectMark1;
    
    [labelArr replaceObjectAtIndex:0 withObject:lbindex1];
    [labelArr replaceObjectAtIndex:1 withObject:lbindex0];
    
    [self paomaAnimate];
    
}
- (void)stop{
    isStop = YES;
}

- (NSTimeInterval)displayDurationForString:(NSString*)string {
    
    return string.length/5;
    //    return MIN((float)string.length*0.06 + 0.5, 5.0);
}











@end

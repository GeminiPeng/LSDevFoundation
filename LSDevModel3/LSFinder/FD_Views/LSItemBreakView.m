//
//  LSItemBreakView.m
//  LSDevModel3
//
//  Created by  tsou117 on 16/4/14.
//  Copyright © 2016年 sen. All rights reserved.
//

#import "LSItemBreakView.h"

@implementation LSItemBreakView
{
    UIScrollView* myscrollview;

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame countOfItem:(NSInteger)count itemSize:(CGSize)itemsize indexOfbreakLine:(NSInteger)index complete:(blockAllItems)buttons
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        myscrollview = [[UIScrollView alloc] initWithFrame:self.bounds];
        myscrollview.scrollsToTop = NO;
        myscrollview.showsHorizontalScrollIndicator = NO;
        [self addSubview:myscrollview];
        
        myscrollview.contentSize = CGSizeMake(itemsize.width*index, myscrollview.bounds.size.height);
        
        int j = 0, k = 0;
        NSMutableArray* tmparr = [NSMutableArray array];
        for (int i = 0; i<count; i++) {
            //
            if (j>=index) {
                k ++;
                j = 0;
            }
            
            UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(itemsize.width*j, itemsize.height*k, itemsize.width, itemsize.height);
            [myscrollview addSubview:btn];
            
            [tmparr addObject:btn];
            
            j++;
            
        }
        
        
        buttons(tmparr);
        
        CGFloat rows = (count%index == 0) ? count/index : 1+count/index;
        CGFloat sub_h = rows*itemsize.height;
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, sub_h);
        myscrollview.frame = self.bounds;
        
    }
    return self;
}

@end

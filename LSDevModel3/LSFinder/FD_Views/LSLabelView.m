//
//  LSLabelView.m
//  LSDevModel3
//
//  Created by  tsou117 on 16/4/21.
//  Copyright © 2016年 sen. All rights reserved.
//

#import "LSLabelView.h"

@implementation LSLabelView
{
    
    UIView* bgview;
    CGFloat sublbs_w;
}
//
- (instancetype)initWithFrame:(CGRect)frame textArr:(NSArray*)textarr
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        _subLabels = [NSMutableArray array];
        
        bgview = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:bgview];
        
        sublbs_w = 0;
        for (int i = 0; i<textarr.count; i++) {
            //
            
            UILabel* lb = [[UILabel alloc] initWithFrame:CGRectZero];
            lb.font = [UIFont systemFontOfSize:14];
            lb.text = textarr[i];
            [bgview addSubview:lb];
            [lb sizeToFit];
            
            CGFloat text_w = lb.bounds.size.width;
            lb.frame = CGRectMake(sublbs_w, 0, text_w, frame.size.height);
            
            sublbs_w += text_w;
            
            //
            [_subLabels addObject:lb];
            
        }
        
        self.normalfont = [UIFont systemFontOfSize:14];
        
        bgview.frame = CGRectMake(0, 0, sublbs_w, frame.size.height);
        
    }
    return self;
}

- (void)setTextarr:(NSArray *)textarr{
    _textarr = textarr;
    
    sublbs_w = 0;
    for (UILabel* obj in _subLabels) {
        //
        [obj removeFromSuperview];
    }
    
    [_subLabels removeAllObjects];
    
    
    for (int i = 0; i<textarr.count; i++) {
        //
        
        UILabel* lb = [[UILabel alloc] initWithFrame:CGRectZero];
        lb.font = [UIFont systemFontOfSize:14];
        lb.text = textarr[i];
        [bgview addSubview:lb];
        [lb sizeToFit];
        
        CGFloat text_w = lb.bounds.size.width;
        lb.frame = CGRectMake(sublbs_w, 0, text_w, self.frame.size.height);
        
        sublbs_w += text_w;
        
        //
        [_subLabels addObject:lb];
        
    }
    
    bgview.frame = CGRectMake(0, 0, sublbs_w, self.frame.size.height);
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment{
    _textAlignment = textAlignment;
    
    if (_textAlignment == NSTextAlignmentCenter) {
        //
        bgview.frame = CGRectMake((self.frame.size.width-bgview.frame.size.width)/2, 0, bgview.frame.size.width, self.frame.size.height);
    }else if (_textAlignment == NSTextAlignmentRight){
        //
        
        bgview.frame = CGRectMake(self.frame.size.width-bgview.frame.size.width, 0, bgview.frame.size.width, self.frame.size.height);
    }
    
}

- (void)setNormalColor:(UIColor *)normalColor{
    
    for (UILabel* obj in _subLabels) {
        //
        obj.textColor = normalColor;
    }
}

- (void)setHighlightedColor:(UIColor *)highlightedColor index:(NSInteger)index{
    
    UILabel* tmplb = _subLabels[index];
    tmplb.textColor = highlightedColor;
    
}

- (void)setText:(NSString*)text index:(NSInteger)index{
    //
    UILabel* tmplb = _subLabels[index];
    sublbs_w -= tmplb.bounds.size.width;
    
    tmplb.text = text;
    [tmplb sizeToFit];
    tmplb.frame = CGRectMake(sublbs_w, 0, tmplb.bounds.size.width, self.frame.size.height);
    sublbs_w += tmplb.bounds.size.width;
    
    bgview.frame = CGRectMake(0, 0, sublbs_w, self.frame.size.height);

    [self setTextAlignment:_textAlignment];

}

#pragma mark - FONT

- (void)setNormalfont:(UIFont *)normalfont{
    //
    _normalfont = normalfont;
    sublbs_w = 0;
    for (UILabel* obj in _subLabels) {
        obj.font = _normalfont;
        [obj sizeToFit];
        
        CGFloat text_w = obj.bounds.size.width;
        obj.frame = CGRectMake(sublbs_w, 0, text_w, self.frame.size.height);
        sublbs_w += text_w;
    }
    bgview.frame = CGRectMake(0, 0, sublbs_w, self.frame.size.height);
}
- (void)setHighlightedFont:(UIFont*)font index:(NSInteger)index{
    
    sublbs_w = 0;
    for (int i = 0; i<_subLabels.count; i++) {
        //
        UILabel* tmplb = _subLabels[i];
        tmplb.font = (i == index) ? font : _normalfont;
        [tmplb sizeToFit];
        
        //
        CGFloat text_w = tmplb.bounds.size.width;
        tmplb.frame = CGRectMake(sublbs_w, 0, text_w, self.frame.size.height);
        sublbs_w += text_w;
    }
    bgview.frame = CGRectMake(0, 0, sublbs_w, self.frame.size.height);
    
}


@end

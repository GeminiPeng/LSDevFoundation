//
//  LSLabelView.h
//  LSDevModel3
//
//  Created by  tsou117 on 16/4/21.
//  Copyright © 2016年 sen. All rights reserved.
//

#import "LSBaseView.h"

@interface LSLabelView : LSBaseView

@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, strong) NSArray* textarr;



@property (nonatomic, strong, readonly) NSMutableArray* subLabels;

- (instancetype)initWithFrame:(CGRect)frame textArr:(NSArray*)textarr;

//
- (void)setNormalColor:(UIColor *)normalColor;
- (void)setHighlightedColor:(UIColor *)highlightedColor index:(NSInteger)index;

//
@property (nonatomic, strong) UIFont* normalfont;
- (void)setHighlightedFont:(UIFont*)font index:(NSInteger)index;

//
- (void)setText:(NSString*)text index:(NSInteger)index;

@end

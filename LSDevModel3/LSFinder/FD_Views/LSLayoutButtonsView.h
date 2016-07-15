//
//  LSLayoutButtonsView.h
//  LSDevModel3
//
//  Created by  tsou117 on 16/4/12.
//  Copyright © 2016年 sen. All rights reserved.
//

#import "LSBaseView.h"

@interface LSLayoutButtonsView : LSBaseView

- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString*)title
                     itemInfo:(NSArray*)itemarr;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, copy) void (^blockSelect)(NSInteger index);

- (void)setHighlightedItemWithIndex:(NSInteger)index;

@end

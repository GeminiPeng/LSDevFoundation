//
//  LSItemBreakView.h
//  LSDevModel3
//
//  Created by  tsou117 on 16/4/14.
//  Copyright © 2016年 sen. All rights reserved.
//

#import "LSBaseView.h"

@interface LSItemBreakView : LSBaseView

typedef void (^blockAllItems)(NSArray* buttons);

- (instancetype)initWithFrame:(CGRect)frame countOfItem:(NSInteger)count itemSize:(CGSize)itemsize indexOfbreakLine:(NSInteger)index complete:(blockAllItems)buttons;

@end

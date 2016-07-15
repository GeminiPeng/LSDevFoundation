//
//  LSImgZoomView.h
//  MyDemo
//
//  Created by Sen on 15/1/25.
//  Copyright (c) 2015年  tsou117. All rights reserved.
//

#import "LSBaseView.h"

@interface LSImgZoomView : LSBaseView
<UIScrollViewDelegate>


@property (nonatomic, strong) void (^BlockClose)(BOOL done);


- (id)initWithFirstFrame:(CGRect)frame1 withImgUrlArr:(NSArray*)imgUrlArr withIndexImg:(NSInteger)index;


- (void)show;

@end

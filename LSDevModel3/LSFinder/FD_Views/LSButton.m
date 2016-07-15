//
//  LSButton.m
//  LSDevModel3
//
//  Created by  tsou117 on 16/4/12.
//  Copyright © 2016年 sen. All rights reserved.
//

#import "LSButton.h"

@implementation LSButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews{
    [super layoutSubviews];
    
    UIImage* img = self.imageView.image;
    
    
    if (img && _imageViewHorizontalAlignment == LSButtonImageViewHorizontalAlignmentRight) {
        //
        
        CGRect rect = self.titleLabel.frame;
        rect.origin.x = self.imageView.frame.origin.x;
        self.titleLabel.frame = rect;
        
        rect = self.imageView.frame;
        rect.origin.x = self.titleLabel.frame.origin.x+self.titleLabel.frame.size.width;
        self.imageView.frame = rect;
    }
    
}

- (void)setImageViewHorizontalAlignment:(LSButtonImageViewHorizontalAlignment)imageViewHorizontalAlignment{
    _imageViewHorizontalAlignment = imageViewHorizontalAlignment;
    [self layoutSubviews];
    
}

@end

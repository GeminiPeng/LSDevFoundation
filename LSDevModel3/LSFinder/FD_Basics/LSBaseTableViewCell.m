//
//  LSBaseTableViewCell.m
//  LSDevModel3
//
//  Created by Sen on 16/3/7.
//  Copyright © 2016年 sen. All rights reserved.
//

#import "LSBaseTableViewCell.h"

@implementation LSBaseTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];

}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //
    UIImage* img = self.imageView.image;

    //
    CGFloat img_h = self.bounds.size.height-20;
    CGFloat img_w = img_h;
    
    self.imageView.frame = CGRectMake(10, (self.bounds.size.height-img_h)*0.5, img_w, img_h);
    self.imageView.contentMode = UIViewContentModeCenter;
    self.imageView.clipsToBounds = YES;
    
    CGRect tmpFrame = self.textLabel.frame;
    tmpFrame.origin.x = img ? self.imageView.frame.origin.x+self.imageView.frame.size.width+10 : 10;
    self.textLabel.frame = tmpFrame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

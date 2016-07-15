//
//  LSButton.h
//  LSDevModel3
//
//  Created by  tsou117 on 16/4/12.
//  Copyright © 2016年 sen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LSButtonImageViewHorizontalAlignment) {
    LSButtonImageViewHorizontalAlignmentNone = 0,
    LSButtonImageViewHorizontalAlignmentLeft,
    LSButtonImageViewHorizontalAlignmentRight,
};

@interface LSButton : UIButton

@property (nonatomic, assign) LSButtonImageViewHorizontalAlignment imageViewHorizontalAlignment;

@end

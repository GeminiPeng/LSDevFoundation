//
//  LSBaseView.h
//  LSDevModel2
//
//  Created by  tsou117 on 15/10/10.
//  Copyright (c) 2015年  tsou117. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LSAFNetworkingManager.h"
#import "LSCellDispose.h"


@interface LSBaseView : UIView

@property (nonatomic,assign)IBInspectable CGFloat cornerRadius;
@property (nonatomic,assign)IBInspectable CGFloat bwidth;
@property (nonatomic,assign)IBInspectable UIColor* bcolor;

@end

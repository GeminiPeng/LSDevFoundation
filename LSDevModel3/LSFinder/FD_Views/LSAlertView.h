//
//  LSAlertView.h
//  LSDevModel2
//
//  Created by  tsou117 on 16/1/18.
//  Copyright (c) 2016年  tsou117. All rights reserved.
//

#import "LSBaseView.h"


@protocol LSAlertViewDelegate;

@interface LSAlertView : LSBaseView

@property (nonatomic, weak) id<LSAlertViewDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<LSAlertViewDelegate>)delegate cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString *)buttonTitles, ... NS_REQUIRES_NIL_TERMINATION;
- (void)show;

@end



@protocol LSAlertViewDelegate <NSObject>

- (void)alertView:(LSAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end



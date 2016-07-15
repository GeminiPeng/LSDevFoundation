//
//  LSTextField.h
//  NingxiaInternational
//
//  Created by  tsou117 on 15/6/8.
//  Copyright (c) 2015年  tsou117. All rights reserved.
//

#import "LSBaseView.h"

typedef enum : NSUInteger {
    LSTextShowStyleFullLine = 0,    //已到头的线———————————
    LSTextShowStyleLine,            //没到头的线   ————————
    LSTextShowStyleRoundedRect,
    LSTextShowStyleNone,
    LSTextShowStyleFullRoundedRect, //全圆角
} LSTextShowStyle;

@class LSTextField;

@protocol LSTextFieldDelegate <NSObject>

@optional
//
- (void)lstextFieldDidBeginEditing:(LSTextField *)lstextField;

- (void)lstextFieldDidEndEditing:(LSTextField *)lstextField;

- (BOOL)lstextFieldShouldReturn:(LSTextField *)lstextField;

@end

@interface LSTextField : LSBaseView
<UITextFieldDelegate>

- (id)initWithFrame:(CGRect)frame andTitle:(NSString*)title andPlaceholder:(NSString*)placeholder;

@property (nonatomic,strong,readonly) UITextField* textField;
@property (nonatomic,strong) NSString* text;

@property (nonatomic,strong) UIFont* titleFont;
@property (nonatomic,strong) UIFont* fieldFont;

@property (nonatomic,assign) id<LSTextFieldDelegate> delegate;

@property (nonatomic,assign) UIKeyboardType keyType;
@property (nonatomic,assign) BOOL secureTextEntry;//是否密码模式，默认 NO
@property (nonatomic,assign) BOOL required;//是否必填，默认 yes
@property (nonatomic,assign) LSTextShowStyle showStyle; //展示风格 默认 LSTextShowStyleLine

@end

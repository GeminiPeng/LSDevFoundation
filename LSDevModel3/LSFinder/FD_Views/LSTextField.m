//
//  LSTextField.m
//  NingxiaInternational
//
//  Created by  tsou117 on 15/6/8.
//  Copyright (c) 2015年  tsou117. All rights reserved.
//

#import "LSTextField.h"

@implementation LSTextField
{
    UILabel* titleLb;
    UITextField* mytextfield;
    UIImageView* markImgV;
    UIImageView* bgimgview;
}
@synthesize textField = _textField;
@synthesize text = _text;
@synthesize showStyle = _showStyle;
@synthesize delegate = _delegate;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame andTitle:(NSString*)title andPlaceholder:(NSString*)placeholder
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        
        //
        titleLb = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, frame.size.height)];
        titleLb.text = title;
        titleLb.font = [UIFont boldSystemFontOfSize:16];
        titleLb.textAlignment = 1;
        titleLb.textColor = [UIColor blackColor];
        [self addSubview:titleLb];
        [titleLb sizeToFit];
        
        titleLb.frame = CGRectMake(10, (frame.size.height-titleLb.frame.size.height)/2, titleLb.frame.size.width, titleLb.frame.size.height);
        
        //bg
        bgimgview = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:bgimgview];
        

        
        //field
        mytextfield = [[UITextField alloc] initWithFrame:CGRectMake(titleLb.frame.origin.x+titleLb.frame.size.width, 0, frame.size.width-titleLb.frame.size.width-30, frame.size.height)];
        mytextfield.delegate = self;
        mytextfield.textColor = [UIColor darkGrayColor];
        mytextfield.font = [UIFont systemFontOfSize:14];
        mytextfield.placeholder = placeholder;
        mytextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        mytextfield.autocorrectionType = UITextAutocorrectionTypeNo;//取消联想
        mytextfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
        mytextfield.returnKeyType = UIReturnKeyDone;
        [self addSubview:mytextfield];
        
        //
        markImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mustmark.png"]];
        markImgV.frame = CGRectMake(frame.size.width-20, 0, 20, frame.size.height);
        markImgV.contentMode = UIViewContentModeCenter;
        markImgV.clipsToBounds = YES;
        [self addSubview:markImgV];
        
        [self setShowStyle:0];

        
        //
        _textField = mytextfield;
    }
    return self;
}

#pragma mark - SET

#pragma mark ----text
- (void)setText:(NSString *)text{
    _text = text;
    mytextfield.text = _text;
}

#pragma mark ----title字体设置
- (void)setTitleFont:(UIFont *)titleFont{
    _titleFont = titleFont;
    titleLb.font = titleFont;
    [titleLb sizeToFit];
    titleLb.frame = CGRectMake(10, (self.frame.size.height-titleLb.frame.size.height)/2, titleLb.frame.size.width, titleLb.frame.size.height);
    mytextfield.frame = CGRectMake(titleLb.frame.origin.x+titleLb.frame.size.width+10, 0, self.frame.size.width-titleLb.frame.size.width-30, self.frame.size.height);
    
    [self setShowStyle:_showStyle];
    
}

#pragma mark ----textfield字体设置
- (void)setFieldFont:(UIFont *)fieldFont{
    _fieldFont = fieldFont;
    mytextfield.font = fieldFont;
}

#pragma mark ----键盘样式
- (void)setKeyType:(UIKeyboardType)keyType{
    _keyType = keyType;
    mytextfield.keyboardType = keyType;
}

#pragma mark ----密码风格
- (void)setSecureTextEntry:(BOOL)secureTextEntry{
    _secureTextEntry = secureTextEntry;
    mytextfield.secureTextEntry = secureTextEntry;
}
#pragma mark ----是否带必填标识
- (void)setRequired:(BOOL)required{
    _required = required;
    markImgV.hidden = !required;
}

#pragma mark ----显示风格
- (void)setShowStyle:(LSTextShowStyle)showStyle{
    _showStyle = showStyle;
    
    if (_showStyle == LSTextShowStyleLine) {
        //
        [self lineStyle];
    }else if (_showStyle == LSTextShowStyleFullLine){
    
        [self fullLineStyle];
    }
    else if (_showStyle == LSTextShowStyleRoundedRect){
        //
        [self roundedRectStyle];
    }else if (_showStyle == LSTextShowStyleNone){
        //
        bgimgview.hidden = YES;
    }else if (_showStyle == LSTextShowStyleFullRoundedRect){
        //
        bgimgview.hidden = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 4;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
    }
}

- (void)lineStyle{
    
    bgimgview.frame = CGRectMake(mytextfield.frame.origin.x, mytextfield.frame.size.height-10.5, mytextfield.frame.size.width, 0.5);
    bgimgview.backgroundColor = kColor_line;
}
- (void)fullLineStyle{
    
    bgimgview.frame = CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width, 0.5);
    bgimgview.backgroundColor = kColor_line;
}

- (void)roundedRectStyle{
    
    bgimgview.frame = CGRectMake(mytextfield.frame.origin.x, 5, mytextfield.frame.size.width, mytextfield.frame.size.height-10);
    bgimgview.backgroundColor = [UIColor clearColor];
    bgimgview.layer.cornerRadius = 4;
    bgimgview.layer.borderWidth = 0.5;
    bgimgview.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

#pragma mark - UITextDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    _textField = textField;
    if ([_delegate respondsToSelector:@selector(lstextFieldDidBeginEditing:)]) {
        //
        [_delegate lstextFieldDidBeginEditing:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    _textField = textField;
    _text = textField.text;
    if ([_delegate respondsToSelector:@selector(lstextFieldDidEndEditing:)]) {
        //
        [_delegate lstextFieldDidEndEditing:self];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    _textField = textField;
    if ([_delegate respondsToSelector:@selector(lstextFieldShouldReturn:)]) {
        //
        [_delegate lstextFieldShouldReturn:self];
    }
    
    return YES;
}

@end

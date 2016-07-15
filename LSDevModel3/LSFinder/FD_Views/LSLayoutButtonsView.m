//
//  LSLayoutButtonsView.m
//  LSDevModel3
//
//  Created by  tsou117 on 16/4/12.
//  Copyright © 2016年 sen. All rights reserved.
//

#import "LSLayoutButtonsView.h"

@implementation LSLayoutButtonsView
{
    NSArray* _itemarr;
    NSMutableArray* btnArr;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithFrame:(CGRect)frame title:(NSString*)title itemInfo:(NSArray*)itemarr
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        
        _itemarr = itemarr;
        
        self.frame = CGRectMake(0, frame.origin.y, kSCREEN_WIDTH, 0);
        self.backgroundColor = [UIColor whiteColor];
        
        //标题
        UILabel* marklb = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kSCREEN_WIDTH-20, 30)];
        marklb.text = title;
        marklb.textColor = [UIColor darkTextColor];
        marklb.font = [UIFont systemFontOfSize:13];
        [self addSubview:marklb];
        //
        CGFloat leftsp = 10;    //左间距
        CGFloat btn_h = 30;     //按钮高
        CGFloat sp_hor = 15;    //横向间距
        CGFloat sp_ver = 10;    //纵向间距
        
        int k = 0;              //行数
        CGFloat btn_w;          //按钮宽
        
        
        btnArr = [NSMutableArray array];
        CGFloat tmp_w = leftsp;
        
        for (int i = 0; i < _itemarr.count; i++) {
            //
            
            
            btn_w = [LSFactory fc_getStringSizeWith:_itemarr[i] boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH*0.5, btn_h) font:[UIFont systemFontOfSize:13]].width+10;
            
            if (btn_w + tmp_w > kSCREEN_WIDTH) {
                k++;
                tmp_w = leftsp;
            }
            
            UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = 100+i;
            btn.backgroundColor = [UIColor whiteColor];
            btn.layer.cornerRadius = 4;
            btn.layer.borderWidth = 0.5;
            btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            [btn setTitle:_itemarr[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
            btn.frame = CGRectMake(tmp_w,
                                   marklb.bounds.size.height+(btn_h+sp_ver)*k,
                                   btn_w,
                                   btn_h);
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn addTarget:self action:@selector(actionOfSelect:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [btnArr addObject:btn];
            
            tmp_w += btn_w+sp_hor;
        }
        
        self.frame = CGRectMake(0, frame.origin.y, kSCREEN_WIDTH, 30+(k+1)*btn_h+((k+1)-1)*sp_ver+10);
        
        //line
        //        UIView* horline1 = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kSCREEN_WIDTH-20, 0.5)];
        //        horline1.backgroundColor = kColor_line;
        //        [self addSubview:horline1];
        //
        //        UIView* horline2 = [[UIView alloc] initWithFrame:CGRectMake(10, self.bounds.size.height-0.5, kSCREEN_WIDTH-20, 0.5)];
        //        horline2.backgroundColor = kColor_line;
        //        [self addSubview:horline2];
        
        
    }
    return self;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    UIButton* btn = btnArr[selectedIndex];
    [self changeButtonState:btn tagBase:100 buttonCount:_itemarr.count];
}

- (void)actionOfSelect:(UIButton*)sender{
    //
    NSInteger index = sender.tag-100;
    [self changeButtonState:sender tagBase:100 buttonCount:_itemarr.count];
    
    if (self.blockSelect) {
        self.blockSelect(index);
    }
    
}



- (void)changeButtonState:(UIButton*)sender tagBase:(NSInteger)num buttonCount:(NSInteger)count{
    
    UIView* tmpv = sender.superview;
    for (UIButton* btn in tmpv.subviews) {
        //
        if (btn.tag < num+count+1 && btn.tag >= num) {
            //
            btn.enabled = YES;
            btn.backgroundColor = [UIColor whiteColor];
        }
    }
    sender.enabled = NO;
    sender.backgroundColor = [UIColor colorWithRed:0.988 green:0.318 blue:0.122 alpha:1];
}

- (void)setHighlightedItemWithIndex:(NSInteger)index{
    //
    
    if (index < 0) {
        return;
    }
    
    UIButton* btn = btnArr[index];
    
    [self changeButtonState:btn tagBase:100 buttonCount:_itemarr.count];
}

@end

//
//  LSPaoMaView.h
//  LSDevelopmentModel
//
//  Created by  tsou117 on 15/7/29.
//  Copyright (c) 2015年  tsou117. All rights reserved.
//

#import "LSBaseView.h"

#define TEXTCOLOR [UIColor redColor]
#define TEXTFONTSIZE 14

@interface LSPaoMaView : LSBaseView


//一句话跑马灯
- (instancetype)initWithFrame:(CGRect)frame title:(NSString*)title;

- (void)start;//开始跑马 初始时不用调用
- (void)stop;//停止跑马

//多句话跑马灯，并可以点击对应的内容做操作

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray*)titlearr;

@end

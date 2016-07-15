//
//  LSWebViewController.h
//  NingxiaInternational
//
//  Created by  tsou117 on 15/6/9.
//  Copyright (c) 2015年  tsou117. All rights reserved.
//

#import "LSBaseViewController.h"


@interface LSWebViewController : LSBaseViewController
<UIWebViewDelegate>

@property (nonatomic,strong) NSString* urlStr;
@property (nonatomic,strong) NSString* defaultTitle;
@property (nonatomic,assign) BOOL usebejson;


@end

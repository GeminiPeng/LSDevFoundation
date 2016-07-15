//
//  LSWebViewController.m
//  NingxiaInternational
//
//  Created by  tsou117 on 15/6/9.
//  Copyright (c) 2015年  tsou117. All rights reserved.
//

#import "LSWebViewController.h"

@interface LSWebViewController ()

@end

@implementation LSWebViewController
{
    UIWebView* mywebView;
    UIProgressView* prv;
}
@synthesize urlStr = _urlStr;
@synthesize defaultTitle = _defaultTitle;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.closeCebianMoveout = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = _defaultTitle;
    
    mywebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    mywebView.delegate = self;
    mywebView.scalesPageToFit = YES;
    [self.view addSubview:mywebView];
    
    NSLog(@"url = %@",_urlStr);
    
    _urlStr = [_urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if ([_urlStr hasPrefix:@"http://"] || [_urlStr hasPrefix:@"https://"]) {
        //
        [mywebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]]];
    }else{
        [mywebView loadHTMLString:_urlStr baseURL:nil];
    }
    
    [self loadBeJson];
    
    [self addProgressView];
}

- (void)loadBeJson{
    
    //
    if (!_usebejson) {
        return;
    }
    
    UIBarButtonItem* rightbtn = [[UIBarButtonItem alloc] initWithTitle:@"BeJson" style:UIBarButtonItemStylePlain target:self action:@selector(actionOfGoBeJson)];
    self.navigationItem.rightBarButtonItem = rightbtn;

}
- (void)actionOfGoBeJson{
    //
    LSWebViewController* webview = [[LSWebViewController alloc] init];
    webview.urlStr = @"http://www.bejson.com/color/";
    webview.defaultTitle = @"BeJson";
    [self.navigationController pushViewController:webview animated:YES];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    mywebView.frame = self.view.bounds;
}

#pragma mark

- (void)addProgressView{
    //
    prv = [[UIProgressView alloc] initWithFrame:CGRectMake(0, kHeight_navBar, kSCREEN_WIDTH, 5)];
    prv.progressTintColor = kColor_themeWithAlpha(0.85);
    prv.trackTintColor = [UIColor clearColor];
    prv.progressViewStyle = UIProgressViewStyleBar;
    [prv setProgress:0.75 animated:YES];
    [self.view addSubview:prv];
}

- (void)closeProressViewWith:(CGFloat)value{
    //
    [prv setProgress:value animated:YES];
    
    BOOL canremove = value == 0.0 || value == 1.0;
    if (canremove) {

        [self performSelector:@selector(hiddenProgressView) withObject:nil afterDelay:kAnimationDurationTime*2];
    }
}

- (void)hiddenProgressView{
    //
    [UIView animateWithDuration:kAnimationDurationTime animations:^{
        //
        prv.frame = CGRectMake(0, kHeight_navBar-5, kSCREEN_WIDTH, 5);
    } completion:^(BOOL finished) {
        //
        prv.progress = 0.0;
    }];
}

#pragma mark
- (void)webViewDidStartLoad:(UIWebView *)webView{
    self.navTitle = _defaultTitle;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    self.navTitle = @"";
//    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    [self closeProressViewWith:0.0];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [self closeProressViewWith:1.0];
    
    if (!_defaultTitle) {
        //
        self.navTitle = [mywebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    
//    self.title = [mywebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
//    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
//    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString* url = [[request URL] absoluteString];
    
    url = [url lowercaseString];
    
    if ([url hasSuffix:@"finish"]) {
        
        [self vcback];
        
        return NO;
    }
    
    return YES;
}

#pragma mark - NJKWebViewProgressDelegate



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

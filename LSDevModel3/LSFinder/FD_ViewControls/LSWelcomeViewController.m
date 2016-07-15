//
//  LSWelcomeViewController.m
//  LSDevModel2
//
//  Created by  tsou117 on 15/10/13.
//  Copyright (c) 2015年  tsou117. All rights reserved.
//

#import "LSWelcomeViewController.h"


@interface LSWelcomeViewController ()

@end

@implementation LSWelcomeViewController
{
    UIScrollView* myscroller;
    UIButton* finishbtn;
    
    NSInteger pages;//引导页页数
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //
    myscroller = [[UIScrollView alloc] initWithFrame:kSCREEN_RECT];
    myscroller.showsHorizontalScrollIndicator = NO;
    myscroller.backgroundColor = [UIColor clearColor];
    myscroller.pagingEnabled = YES;
    myscroller.delegate = self;
    [self.view addSubview:myscroller];
    
    //获取引导页图片
    
    NSArray* pics = [LSFactory fc_getWelcomePics];
    
    if ([pics[0] isEqualToString:kNotFoundObj(@"")]) {
        [LSFactory fc_showSysAlertViewWithMsg:@"未设置引导图"];
    }
    pages = pics.count;

    myscroller.contentSize = CGSizeMake(kSCREEN_WIDTH*(pages+1), kSCREEN_HEIGHT);

    for (int i = 0; i < pages; i++) {
        //
        UIImageView* imgview = [[UIImageView alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH*i, 0, kSCREEN_WIDTH, myscroller.bounds.size.height)];
        imgview.clipsToBounds = YES;
//        imgview.contentMode = UIViewContentModeScaleAspectFit;
//        imgview.backgroundColor = [LSFactory fc_randomColor];
        imgview.image = [UIImage imageNamed:pics[i]];
        [myscroller addSubview:imgview];
    }
    
    //完成
    finishbtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    finishbtn.backgroundColor = [UIColor orangeColor];
    finishbtn.frame = CGRectMake(kSCREEN_WIDTH*(pages-1), kSCREEN_HEIGHT-160, kSCREEN_WIDTH, 160);
//    [finishbtn setTitle:@"进入精彩世界" forState:UIControlStateNormal];
    [finishbtn addTarget:self action:@selector(actionOfFinished:) forControlEvents:UIControlEventTouchUpInside];
    [myscroller addSubview:finishbtn];
    
}

- (void)actionOfFinished:(UIButton*)sender{
    //
    [myscroller setContentOffset:CGPointMake(kSCREEN_WIDTH*pages, 0) animated:YES];
    
    [LSHIGHLEVELWINDOW performSelector:@selector(resignWelcomeWindow) withObject:nil afterDelay:0.45];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float ff = scrollView.contentOffset.x/scrollView.bounds.size.width;
    if (ff > pages-1) {
        float a = ff-pages+1;
        LSHIGHLEVELWINDOW.alpha = 1.0-a;
        
    }
    if (ff < 0) {
        float a = -ff;
        LSHIGHLEVELWINDOW.alpha = 1-a;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    float ff = scrollView.contentOffset.x/scrollView.bounds.size.width;
    if (ff == pages) {
        [LSHIGHLEVELWINDOW resignWelcomeWindow];
    }else if (ff == pages-1){
//        finishbtn.hidden = NO;
    }else{
//        finishbtn.hidden = YES;
    }
    
}

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

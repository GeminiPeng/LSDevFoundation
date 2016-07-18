//
//  LSHomeViewController.m
//  LSDevModel3
//
//  Created by Sen on 16/2/24.
//  Copyright © 2016年 sen. All rights reserved.
//

#import "LSHomeViewController.h"
#import "LSWebViewController.h"


@interface LSHomeViewController ()

@end

@implementation LSHomeViewController
{
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //
    self.hiddedBackBtn = YES;
    self.navTitle = @"首页";
    
    if (!self.isTabbar) {
        //
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionOfSideViewSelect:) name:kNoti_cebianSelect object:nil];
    };
    
    //
    
    UIButton* detailbtn = [UIButton buttonWithType:UIButtonTypeSystem];
    detailbtn.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 88);
    [detailbtn setTitle:@"功能介绍" forState:UIControlStateNormal];
    [detailbtn addTarget:self action:@selector(details) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:detailbtn];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.closeCebianMoveout = NO;

}

#pragma mark -
- (void)details{
    //
    LSWebViewController* vc = [[LSWebViewController alloc] init];
    vc.defaultTitle = @"功能介绍";
    vc.urlStr = @"http://www.jianshu.com/p/66f4c4c90f46";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 侧边栏点击
- (void)actionOfSideViewSelect:(NSNotification*)sender{
    //
    NSInteger obj = [[sender object] integerValue];
    switch (obj) {
        case 0:{
            
            break;
        }
        case 1:{
            
            break;
        }
        case 2:{
            //会员
            [self func_loginvc];

            break;
        }
        case 3:{

            break;
        }
        case 4:{
            
            break;
        }
        default:
            break;
    }

    
    //...
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

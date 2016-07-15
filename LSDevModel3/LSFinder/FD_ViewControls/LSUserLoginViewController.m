//
//  LSUserLoginViewController.m
//  LSDevModel3
//
//  Created by  tsou117 on 16/4/13.
//  Copyright © 2016年 sen. All rights reserved.
//

#import "LSUserLoginViewController.h"

@interface LSUserLoginViewController ()

@end

@implementation LSUserLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navTitle = @"登录";
}

#pragma mark
- (void)actionOfRegister{
    //
    LSUserRegisterViewController* vc = [[LSUserRegisterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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

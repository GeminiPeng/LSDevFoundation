//
//  LSDebugViewController.m
//  LSDevModel2
//
//  Created by  tsou117 on 15/10/12.
//  Copyright (c) 2015年  tsou117. All rights reserved.
//

#import "LSDebugViewController.h"
#import "LSWebViewController.h"

@interface LSDebugViewController ()

@end

@implementation LSDebugViewController
{
    UITableView* mytableview;
    NSArray* tableinfo;
    NSArray* tableinfo2;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    mytableview.frame = self.view.bounds;
}
- (void)viewDidLoad {
    
    self.hiddedBackBtn = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //
    self.view.backgroundColor = [UIColor colorWithRed:0.200 green:0.208 blue:0.216 alpha:1];
    self.title = [LSFactory fc_judgeObj:kApp_name placeholder:kNotFoundObj(@"")];//使用中将填写app名字
    
    //navbar set
    [self loadNavBarView];
    
    //
    mytableview = [[UITableView alloc] initWithFrame:CGRectZero];
    mytableview.backgroundColor = [UIColor clearColor];
    mytableview.delegate = self;
    mytableview.dataSource = self;
    [self.view addSubview:mytableview];
    [self loadTableHeardView];
    
    //
    tableinfo = [LSFactory fc_getAllHttpServer];

}

- (void)actionOfReload:(NSNotification*)sender{
    
    tableinfo2 = [LSFactory fc_getAPIList];
    
    [mytableview reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        
    //
    tableinfo2 = [LSFactory fc_getAPIList];
    
    [mytableview reloadData];
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionOfReload:) name:kNoti_debugTool object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNoti_debugTool object:nil];
}

#pragma mark - 导航栏
- (void)loadNavBarView{

    //right button
//    UIBarButtonItem* rightbtn = [[UIBarButtonItem alloc] initWithTitle:@"栏目预览" style:UIBarButtonItemStylePlain target:self action:@selector(actionOfWatchItems)];
//    rightbtn.tintColor = [UIColor colorWithRed:0.000 green:0.478 blue:1.000 alpha:1];
//    self.navigationItem.rightBarButtonItem = rightbtn;
    
}

- (void)actionOfWatchItems{
    //

}

#pragma mark - TableView

- (void)loadTableHeardView{
    //
    UIView* headerv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 160)];
    
    //
    UILabel* devicemsglb = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, headerv.bounds.size.width-20, headerv.bounds.size.height-40)];
    devicemsglb.numberOfLines = 0;
    devicemsglb.textColor = [UIColor whiteColor];
    devicemsglb.text = [LSFactory fc_deviceMessageLog];
    devicemsglb.font = [UIFont systemFontOfSize:14];
    [headerv addSubview:devicemsglb];
    [devicemsglb sizeToFit];
    
    headerv.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 40+devicemsglb.bounds.size.height);
    
    //
    mytableview.tableHeaderView = headerv;
    mytableview.tableFooterView = [UIView new];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger num = 0;
    if (section == 0) {
        //
        num = tableinfo.count;
    }
    if (section == 1) {
        //
        num = tableinfo2.count;
    }
    
    return num;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString* title;
    if (section == 0) {
        //
        title = @"选择服务器";
    }
    if (section == 1) {
        //
        title = @"API 请求情况";
    }
    return title;
}



- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //
    UITableViewCell* cell = [LSCELLDISPOSE disposeCellWithTableView:tableView cellClassFromString:nil leftLineSpace:0 rightSpace:0 showIndex:0];
    
    if (indexPath.section == 0) {
        //

        cell.accessoryType = [[kLSUserDefaults stringForKey:kMark_currServer] isEqualToString:tableinfo[indexPath.row]] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        cell.textLabel.text = [LSFactory fc_judgeObj:tableinfo[indexPath.row] placeholder:kNotFoundObj(@"")];
        cell.textLabel.textColor = [UIColor grayColor];
    }
    if (indexPath.section == 1) {
        //
        
        
        NSString* apistring = [NSString stringWithFormat:@"%@",[LSFactory fc_judgeObj:tableinfo2[tableinfo2.count-1-indexPath.row] placeholder:kNotFoundObj(@"")]];
        
        apistring = [apistring componentsSeparatedByString:kHOST_main].lastObject;
        
        cell.textLabel.text = [NSString stringWithFormat:@"%ld ...%@",indexPath.row+1,apistring];
        cell.textLabel.textColor = [UIColor colorWithRed:0.886 green:0.271 blue:0.294 alpha:1];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    return cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //
    if (indexPath.section == 0) {
        //
        [kLSUserDefaults setObject:tableinfo[indexPath.row] forKey:kMark_currServer];
        [kLSUserDefaults synchronize];
        
        [tableView reloadData];
        
        UIAlertView* alertv = [[UIAlertView alloc] initWithTitle:@"已切换服务器 程序即将退出\n务必重新登录\n务必重新登录\n务必重新登录\n" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
        [alertv show];
        
        [self performSelector:@selector(exitApp) withObject:nil afterDelay:3.0];
    }
    if (indexPath.section == 1) {
        //
        NSString* urlstring = tableinfo2[tableinfo2.count-1-indexPath.row];
        [LSFactory fc_showSysAlertViewWithMsg:urlstring];
        
        LSWebViewController* web_vc = [[LSWebViewController alloc] init];
        web_vc.urlStr = urlstring;
        web_vc.defaultTitle = @"请求结果";
        web_vc.usebejson = YES;
        [self.navigationController pushViewController:web_vc animated:YES];
        
    }

}

- (void)exitApp{
    exit(0);

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

//
//  LSSideViewController.m
//  LSDevModel2
//
//  Created by  tsou117 on 15/10/13.
//  Copyright (c) 2015年  tsou117. All rights reserved.
//

#import "LSSideViewController.h"

#import "LSCebianCell.h"

@interface LSSideViewController ()

@end

@implementation LSSideViewController
{
    UITableView* mytableview;
    NSArray* tableinfo;
    
    UIButton* userNamebtn;  //用户名
    UIImageView* userImgv;  //用户头像
}
- (void)viewDidLoad {
    
    self.hiddedNavBar = YES;
    [self.navigationController setNavigationBarHidden:self.hiddedNavBar animated:NO];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    tableinfo = @[@"ui_cebian_0.png",@"ui_cebian_1.png",@"ui_cebian_2.png",@"ui_cebian_3.png",@"ui_cebian_4.png"];

    //
    mytableview = [[UITableView alloc] initWithFrame:CGRectZero];
    mytableview.backgroundColor = [UIColor colorWithRed:0.416 green:0.541 blue:0.953 alpha:1];
    mytableview.delegate = self;
    mytableview.dataSource = self;
    mytableview.rowHeight = 137*0.5;
    mytableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mytableview];
    
    
    
    [self loadTableHeaderView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [mytableview selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    


}

- (void)loadTableHeaderView{
    
    UIImage* basicimg = [UIImage imageNamed:@"ui_cebian_0.png"];
    
    UIView* headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, basicimg.size.width, self.view.bounds.size.width*0.5)];
    
    userImgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
    userImgv.layer.cornerRadius = userImgv.frame.size.height*0.5;
    userImgv.image = [UIImage imageNamed:@"defult_tx.png"];
    userImgv.contentMode = UIViewContentModeScaleAspectFill;
    userImgv.clipsToBounds = YES;
    userImgv.center = headview.center;
    [headview addSubview:userImgv];
    
    UIImageView* fugaiv = [[UIImageView alloc] initWithFrame:userImgv.bounds];
    fugaiv.image = [UIImage imageNamed:@"head2.png"];
    fugaiv.contentMode = UIViewContentModeScaleAspectFill;
    [userImgv addSubview:fugaiv];
    
    //
    userNamebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    userNamebtn.frame = CGRectMake(0, userImgv.bounds.size.height+userImgv.frame.origin.y, headview.frame.size.width, 30);
    [userNamebtn setTitle:@"" forState:UIControlStateNormal];
    [userNamebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    userNamebtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [headview addSubview:userNamebtn];
    
    mytableview.tableHeaderView = headview;
    
    mytableview.tableFooterView = [UIView new];
    
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionOfUser:)];
    [headview addGestureRecognizer:tap];
    
}

- (void)actionOfUser:(UITapGestureRecognizer*)sender{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoti_cebianSelect object:[NSString stringWithFormat:@"%d",2]];
    
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        //
        if (finished) {
            //
            
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //
    return tableinfo.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //
    
    LSCebianCell* cell = (LSCebianCell*)[LSCELLDISPOSE disposeCellWithTableView:tableView cellClassFromString:@"LSCebianCell" leftLineSpace:0 rightSpace:0 showIndex:0];
    
    cell.sub_imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",tableinfo[indexPath.row]]];

    UIView* selectbgv = [UIView new];
    selectbgv.backgroundColor = [UIColor colorWithRed:0.373 green:0.486 blue:0.855 alpha:1];
    cell.selectedBackgroundView = selectbgv;
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoti_cebianSelect object:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        //
        if (finished) {
            //
            
            
        }
    }];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    mytableview.frame = self.view.bounds;
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

//
//  LSBaseViewController.m
//  LSDevModel3
//
//  Created by Sen on 16/2/20.
//  Copyright © 2016年 sen. All rights reserved.
//

#import "LSBaseViewController.h"

#import "LScanningViewController.h"
#import "LSUserLoginViewController.h"
#import "LSUserCenterViewController.h"
#import "LSMapViewController.h"
#import "WGS84TOGCJ02.h"


@interface LSBaseViewController ()


@end

@implementation LSBaseViewController
{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    //背景
    self.view.backgroundColor = kBGC_contentView;
    
    kBGC_navBar(kColor_themeWithAlpha(0.5));
    kColor_navbarTitle([UIColor whiteColor]);
    kColor_navbarTintColor([UIColor whiteColor]);
}

- (void)viewWillAppear:(BOOL)animated{
    //
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:self.hiddedNavBar animated:YES];
    self.closeCebianMoveout = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    [SVProgressHUD dismiss];
}

#pragma mark - 基本设置

- (void)setHiddedNavBar:(BOOL)hiddedNavBar{
    //
    _hiddedNavBar = hiddedNavBar;
    
    if (_hiddedNavBar) {self.edgesForExtendedLayout = UIRectEdgeNone;}
}

- (void)setIsTabbar:(BOOL)isTabbar{
    //
    _isTabbar = isTabbar;
    self.hiddedBackBtn = _isTabbar;
    
}

- (void)setNavTitle:(NSString *)navTitle{
    //
    _navTitle = navTitle;
    self.navigationItem.title = _navTitle;

    //
    [self addBackButton];
}
- (void)setHiddedBackBtn:(BOOL)hiddedBackBtn{
    _hiddedBackBtn = hiddedBackBtn;
    
}

- (void)setFullSlidePopBack:(BOOL)fullSlidePopBack{
    //
    self.navigationController.fullScreenInteractivePopGestureRecognizer = fullSlidePopBack;
}

- (void)setCloseCebianMoveout:(BOOL)closeCebianMoveout{
    //
    if (closeCebianMoveout) {
        //
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
    }else{
        //
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    }
}

#pragma mark - 基本界面

- (void)addBackButton{
    //
    if (_hiddedBackBtn) {return;}
    
    
    /*
     默认返回按钮
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
     */
    
    BOOL ispush = [self isPushTypeVc];
    
    /*
     
     1 返回按钮 + 回到首页按钮
     
     2 自定义返回按钮 注释打开
       判断当前vc是不是登录vc,登录vc和非登录vc返回按钮ui不相同
     */
    
    UIView* btnv;
    
    if (_hasHomeBtn) {
        //
        btnv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28*2+10, 44)];
        
        UIButton* backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backbtn.frame = CGRectMake(0, (44-28)/2, 28, 28);
        [backbtn setImage:ispush ? [UIImage imageNamed:@"back.png"] : [UIImage imageNamed:@"esc.png"] forState:UIControlStateNormal];
        [backbtn addTarget:self action:@selector(vcback) forControlEvents:UIControlEventTouchUpInside];
        [btnv addSubview:backbtn];
        
        UIButton* homebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        homebtn.frame = CGRectMake(backbtn.frame.origin.x+backbtn.frame.size.width+5, (44-28)/2, 28, 28);
        [homebtn setImage:[UIImage imageNamed:@"esc.png"] forState:UIControlStateNormal];
        [homebtn addTarget:self action:@selector(vcbackToRoot) forControlEvents:UIControlEventTouchUpInside];
        [btnv addSubview:homebtn];

    }else{
        
        btnv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        
        UIButton* backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backbtn.frame = CGRectMake(0, (44-28)/2, 28, 28);
        [backbtn setImage:ispush ? [UIImage imageNamed:@"back.png"] : [UIImage imageNamed:@"esc.png"] forState:UIControlStateNormal];
        [backbtn addTarget:self action:@selector(vcback) forControlEvents:UIControlEventTouchUpInside];
        [btnv addSubview:backbtn];
    }
    
    UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc] initWithCustomView:btnv];
    self.navigationItem.leftBarButtonItem = leftBtn;
}

#pragma mark
//汉堡包侧边栏功能
- (void)addHamburgerButton{
    //
    UIButton* hamburgerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    hamburgerBtn.frame = CGRectMake(0, 0, 44, 44);
//    hamburgerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [hamburgerBtn setImage:[UIImage imageNamed:@"hbb.png"] forState:UIControlStateNormal];
    [hamburgerBtn setTitle:@"侧边栏" forState:UIControlStateNormal];
    [hamburgerBtn addTarget:self action:@selector(func_hamburger) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* leftbtn = [[UIBarButtonItem alloc] initWithCustomView:hamburgerBtn];
    self.navigationItem.leftBarButtonItem = leftbtn;
}
- (void)func_hamburger{
    //
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}                 

#pragma mark
//扫一扫
- (void)addSaoyisaoButton{
    //
    UIButton* saoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    saoBtn.frame = CGRectMake(0, 0, 44, 44);
//    saoBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    [saoBtn setImage:[UIImage imageNamed:@"saoyisao.png"] forState:UIControlStateNormal];
    [saoBtn setTitle:@"扫描" forState:UIControlStateNormal];
    [saoBtn addTarget:self action:@selector(func_saoyisao) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc] initWithCustomView:saoBtn];
    self.navigationItem.rightBarButtonItem = rightBtn;
//    self.navigationItem.rightBarButtonItems   添加多个按钮
}
- (void)func_saoyisao{
    //
    LScanningViewController* scan_vc = [[LScanningViewController alloc] init];
    scan_vc.hidesBottomBarWhenPushed = self.isTabbar;
    [self.navigationController pushViewController:scan_vc animated:YES];
}

#pragma mark
//搜索
- (void)addSearchButton{
    //
    UIButton* searchBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    searchBtn.frame = CGRectMake(0, 0, 44, 44);
    searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [searchBtn setImage:[UIImage imageNamed:@"ui_search.png"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(func_search) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)func_search{
    //
}

#pragma mark 
- (void)addShareButton{
    //
    UIButton* shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(0, 0, 44, 44);
    shareBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [shareBtn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(func_share) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    
}
- (void)addFavButtonWithFlag:(BOOL)favflag{
    //
    UIButton* favbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    favbtn.frame = CGRectMake(0, 0, 44, 44);
    favbtn.accessibilityIdentifier = [NSString stringWithFormat:@"%d",favflag];
    favbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [favbtn setImage:favflag ? [UIImage imageNamed:@"collect2_2.png"] : [UIImage imageNamed:@"collect2.png"] forState:UIControlStateNormal];
    
    [favbtn addTarget:self action:@selector(func_fav:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:favbtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)addShareAndFavButton{
    //
    UIView* btnv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28*2+10, 44)];
    
    UIButton* favbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    favbtn.frame = CGRectMake(btnv.frame.size.width-24, (44-28)/2, 28, 28);
    [favbtn setImage:[UIImage imageNamed:@"collect2.png"] forState:UIControlStateNormal];
    [favbtn addTarget:self action:@selector(func_fav:) forControlEvents:UIControlEventTouchUpInside];
    [btnv addSubview:favbtn];
    
    UIButton* sharebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sharebtn.frame = CGRectMake(favbtn.frame.origin.x-5-28, (44-28)/2, 28, 28);
    [sharebtn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    [sharebtn addTarget:self action:@selector(func_share) forControlEvents:UIControlEventTouchUpInside];
    [btnv addSubview:sharebtn];
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:btnv];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)func_share{
    
}

- (void)func_shareWithNeedDownImageWithImageUrl:(NSString*)imgurl text:(NSString *)sharetext contentUrl:(NSString *)contenturl{
    //
    UIImage* default_img = [UIImage imageNamed:@"220.png"];
    if (imgurl) {
        //
        SDWebImageManager* manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:imgurl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            //
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            //
            if (image) {
                //download success
                [self func_shareWithText:sharetext contentUrl:contenturl image:image];
            }else{
                //
                [self func_shareWithText:sharetext contentUrl:contenturl image:default_img];
            }
            
        }];
    }else{
        //
        [self func_shareWithText:sharetext contentUrl:contenturl image:default_img];
    }
}

- (void)func_shareWithText:(NSString*)sharetext contentUrl:(NSString*)shareurl image:(UIImage*)image{
    //
    
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = shareurl;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareurl;
    
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
    [UMSocialData defaultData].extConfig.qqData.url = shareurl;
    [UMSocialData defaultData].extConfig.qzoneData.url = shareurl;
    
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession, UMShareToWechatTimeline,UMShareToQQ, UMShareToQzone]];
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:kUmKey
                                      shareText:sharetext
                                     shareImage:image
                                shareToSnsNames:@[UMShareToWechatSession, UMShareToWechatTimeline,UMShareToQQ, UMShareToQzone]
                                       delegate:self];
    
    
    
}
- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
    //
    if (response.responseCode == UMSResponseCodeSuccess) {
        //
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}
- (void)func_fav:(UIButton*)sender{
    //
}



//天气
- (void)addWeatherViewOnSupView:(UIView*)supview info:(NSDictionary*)weatherdic{
    //
    
    NSDictionary* citydic = weatherdic[@"city"];
    NSDictionary* todaydic = weatherdic[@"weather0"];
    
    NSString* temp1 = [LSFactory fc_judgeObj:todaydic[@"temperature"] placeholder:@""];
    NSString* city = [LSFactory fc_judgeObj:citydic[@"city"] placeholder:@""];
    NSString* weather1 = [LSFactory fc_judgeObj:todaydic[@"logo"] placeholder:@""];
    
    UIView* bgview = [[UIView alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH-110, 20, 100, 50)];
    [supview addSubview:bgview];
    
    //
    UILabel* templb = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 75, 15)];
    templb.text = temp1;
    templb.textAlignment = 2;
    templb.textColor = [UIColor whiteColor];
    templb.font = [UIFont systemFontOfSize:12];
    [bgview addSubview:templb];
    
    //
    UILabel* citylb = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 75, 15)];
    citylb.text = city;
    citylb.textAlignment = 2;
    citylb.textColor = [UIColor whiteColor];
    citylb.font = [UIFont systemFontOfSize:10];
    [bgview addSubview:citylb];
    
    //
    UIImageView* imgv = [[UIImageView alloc] initWithFrame:CGRectMake(80, 15, 20, 20)];
    imgv.contentMode = UIViewContentModeScaleAspectFill;
    imgv.image = [UIImage imageNamed:weather1];
    
    [bgview addSubview:imgv];
}

#pragma mark - 基本功能

- (void)vcback{
    //

    [LSAFNetworkingManager cancelAllRequest];
    
    if (_isTongzhi) {
        //
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    
    BOOL ispush = [self isPushTypeVc];
    ispush ? [self.navigationController popViewControllerAnimated:YES] : [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

- (void)vcbackToRoot{
    //
    [LSAFNetworkingManager cancelAllRequest];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)func_callWithNum:(NSString *)phonenum{
    //
    UIAlertView* alertV = [[UIAlertView alloc] initWithTitle:phonenum message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
    alertV.accessibilityIdentifier = phonenum;
    [alertV show];
}

- (void)func_loginvc{
    //
    LSUserLoginViewController* vc = [[LSUserLoginViewController alloc] init];
    UINavigationController* nav_vc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav_vc animated:YES completion:^{}];
}
- (void)func_usercentervc{
    //
    LSUserCenterViewController* user_vc = [[LSUserCenterViewController alloc] init];
    [self.navigationController pushViewController:user_vc animated:YES];
}

- (void)func_logout{
    //
    [self.navigationController popToRootViewControllerAnimated:NO];
    
}

- (void)func_goMap{
    //
    LSMapViewController* map_vc = [[LSMapViewController alloc] init];
    [self.navigationController pushViewController:map_vc animated:YES];
}

- (void)func_callMapWithEndLocationOflatitudeString:(NSString*)latitude longitudeString:(NSString*)longitude endAddress:(NSString*)endaddress{
    //
    
    BOOL noloc = !latitude || !longitude;
    
    if (noloc) {
        [SVProgressHUD showInfoWithStatus:@"未能获取该地址坐标，请重试"];
        return;
    }
    
    double jingdu = [latitude doubleValue];
    double weidu = [longitude doubleValue];
    CLLocationCoordinate2D endlocation = CLLocationCoordinate2DMake(weidu, jingdu);//;
    
    MKMapItem* startitem = [MKMapItem mapItemForCurrentLocation];   //当前位置作为起点
    
    MKMapItem* enditem = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:endlocation addressDictionary:nil]];
    enditem.name = endaddress;
    NSArray *item = @[startitem ,enditem];
    
    //建立字典存储导航的相关参数
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[MKLaunchOptionsDirectionsModeKey] = MKLaunchOptionsDirectionsModeDriving;
    md[MKLaunchOptionsMapTypeKey] = [NSNumber numberWithInteger:MKMapTypeStandard];
    md[MKLaunchOptionsShowsTrafficKey] = @YES;
    
    [MKMapItem openMapsWithItems:item launchOptions:md];
}

#pragma mark - 其他

- (BOOL)isPushTypeVc{
    //
    NSRange range = [self.navTitle rangeOfString:@"登录"];

    return range.length == 0 ? YES : NO;
}

#define mark - LSAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",alertView.accessibilityIdentifier]];
        
        
        [[UIApplication sharedApplication] openURL:url];
    }
}


#pragma mark

- (UIButton*)addRequestButtonOnView:(UIView*)supview requestSEL:(SEL)sel{
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = supview.bounds;
    btn.alpha = 0;
    [btn setTitle:@"获取数据失败,点击重试" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    [supview addSubview:btn];
    return btn;
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

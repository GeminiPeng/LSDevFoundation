//
//  LSBaseListViewController.m
//  LSDevModel2
//
//  Created by  tsou117 on 15/10/30.
//  Copyright (c) 2015年  tsou117. All rights reserved.
//

#import "LSBaseListViewController.h"

@interface LSBaseListViewController ()

@end

@implementation LSBaseListViewController
{
    //
    
    //
    UIButton* nomoredatabtn;
    
    //
    SearchTableView* searchtableview;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.rootview.scrollsToTop = NO;
    self.rootview.scrollEnabled = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.closeCebianMoveout = YES;
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
}


#pragma mark - 标签栏目视图


- (LSHorizontalMenuView*)subbar{
    if (_subbar == nil) {
        //
        _subbar = [[LSHorizontalMenuView alloc] initWithFrame:CGRectMake(0, self.subviews_h, kSCREEN_WIDTH, kSubItemBarHeight)];
        _subbar.itemstyle = UIHorItemStyleHorLine;
        [self addSubview:_subbar];
    }
    return _subbar;
}

#pragma mark - 搜索框

- (void)loadSearchBarWithTableViewBlockSelect:(void (^)(NSDictionary* selectinfo))myselect{
    //
    
    UIView* bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSubItemBarHeight)];
    bgview.backgroundColor = [UIColor colorWithRed:0.012 green:0.051 blue:0.094 alpha:1];
    bgview.clipsToBounds = YES;
    [self addSubview:bgview];
    
    _searchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSubItemBarHeight)];
    _searchbar.placeholder = @"输入搜索内容";
    _searchbar.returnKeyType = UIReturnKeySearch;
    [bgview addSubview:_searchbar];
    
    //
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, kSubItemBarHeight-0.5, kSCREEN_WIDTH, 0.5)];
    line.backgroundColor = kColor_line;
    [bgview addSubview:line];
    
    searchtableview = [[SearchTableView alloc] initWithFrame:CGRectMake(0, kSubItemBarHeight, kSCREEN_WIDTH, 0)];
    [_searchbar.superview addSubview:searchtableview];
    searchtableview.blockMySelect = ^(NSDictionary* dic){myselect(dic);};
}

- (void)setSearchinfo:(NSArray *)searchinfo{
    _searchinfo = searchinfo;
    searchtableview.myinfo = _searchinfo;
}

- (void)beginSearchView{
    //
    
    if (_searchbar.text.length > 0) {
        //
        return;
    }
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [_searchbar setShowsCancelButton:YES animated:YES];
    
    UIView* bgview = _searchbar.superview;
    
    CGRect rect = bgview.frame;
    rect.size.height = kSCREEN_HEIGHT;
    bgview.frame = rect;
    bgview.backgroundColor = [UIColor colorWithRed:0.012 green:0.051 blue:0.094 alpha:0];
    
    if (searchtableview) {
        //
        CGRect rect = searchtableview.frame;
        rect.size.height = kSCREEN_HEIGHT-kSubItemBarHeight-20;
        searchtableview.frame = rect;
        searchtableview.alpha = 0;
        
    }
    
    [UIView animateWithDuration:kAnimationDurationTime animations:^{
        //
        bgview.backgroundColor = [UIColor colorWithRed:0.012 green:0.051 blue:0.094 alpha:0.5];
        if (searchtableview) {searchtableview.alpha = 1;}
        
    }];
}

- (void)cancelSearchView{
    //
    [_searchbar resignFirstResponder];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [_searchbar setShowsCancelButton:NO animated:YES];
    _searchbar.text = nil;
    
    self.searchinfo = @[];
    
    //移除自定义的取消按钮
    UIView* v1 = _searchbar.subviews[0];
    UIButton* bb = (UIButton*)[v1 viewWithTag:100];
    if (bb) {[bb removeFromSuperview];}
    
    //
    UIView* bgview = _searchbar.superview;
    
    [UIView animateWithDuration:kAnimationDurationTime animations:^{
        //
        bgview.backgroundColor = [UIColor colorWithRed:0.012 green:0.051 blue:0.094 alpha:0];
        if (searchtableview) {searchtableview.alpha = 0;}
        
    } completion:^(BOOL finished) {
        //
        CGRect rect = bgview.frame;
        rect.size.height = kSubItemBarHeight;
        bgview.frame = rect;
        bgview.backgroundColor = [UIColor colorWithRed:0.012 green:0.051 blue:0.094 alpha:1];
        
        if (searchtableview) {
            CGRect rect = searchtableview.frame;
            rect.size.height = 0;
            searchtableview.frame = rect;
            searchtableview.alpha = 0;
        }
        
    }];
}

#pragma mark - tableview

- (void)loadTableViewWithTableViewStyle:(UITableViewStyle)style refreshStyle:(LSRefreshType)refreshtype{
    //
    CGFloat listheight = self.isTabbar ? (kSCREEN_HEIGHT-(self.hiddedNavBar?0:kHeight_navBar)-self.subviews_h-kHeight_tabBar) : (kSCREEN_HEIGHT-(self.hiddedNavBar?0:kHeight_navBar)-self.subviews_h);
    
    _mytableview = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                 self.subviews_h,
                                                                 kSCREEN_WIDTH,
                                                                 listheight) style:style];
    _mytableview.backgroundColor = kColor_contentView;
    _mytableview.tableFooterView = [UIView new];
    _mytableview.separatorColor = kColor_line;
    
    if (style == UITableViewStyleGrouped) {
        //
        _mytableview.sectionFooterHeight = 0;//5.0;
        _mytableview.sectionHeaderHeight = 0;//5.0;
        _mytableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 10)];
    }
    [self addSubview:_mytableview];
    
    //
    switch (refreshtype) {
        case LSRefreshTypeDefault:{
            //
            [self loadRefreshViewJustHeader:NO];
            break;
        }
        case LSRefreshTypeJustHeader:{
            //
            [self loadRefreshViewJustHeader:YES];
            break;
        }
        case LSRefreshTypeJustFooter:{
            //
            [self loadRefreshViewJustFooter];
            break;
        }
        default:
            break;
    }
    
}

#pragma mark - collectionview


- (void)loadCollectionViewWithViewLayout:(UICollectionViewLayout*)layout registerClass:(Class)registerclass refreshStyle:(LSRefreshType)refreshtype{
    //
    CGFloat listheight = self.isTabbar ? (kSCREEN_HEIGHT-(self.hiddedNavBar?0:kHeight_navBar)-self.subviews_h-kHeight_tabBar) : (kSCREEN_HEIGHT-(self.hiddedNavBar?0:kHeight_navBar)-self.subviews_h);
    _mycollectionview = [[UICollectionView alloc] initWithFrame:CGRectMake(0,
                                                                           self.subviews_h,
                                                                           kSCREEN_WIDTH,
                                                                           listheight) collectionViewLayout:layout];
    
    _mycollectionview.backgroundColor = kColor_contentView;
    
    //
    [_mycollectionview registerClass:registerclass forCellWithReuseIdentifier:KCollectionViewCellReuseIdentifier];
    _mycollectionview.alwaysBounceVertical = YES;
    
    [self.rootview addSubview:_mycollectionview];
    
    
    switch (refreshtype) {
        case LSRefreshTypeDefault:{
            //
            [self loadRefreshViewJustHeader:NO];
            break;
        }
        case LSRefreshTypeJustHeader:{
            //
            [self loadRefreshViewJustHeader:YES];
            break;
        }
        case LSRefreshTypeJustFooter:{
            //
            [self loadRefreshViewJustFooter];
            break;
        }
        default:
            break;
    }
    
    
    
}

#pragma mark - 刷新

- (void)loadRefreshViewJustHeader:(BOOL)justheader{
    //
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestNewData)];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.textColor = [UIColor lightGrayColor];
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    
    if (_mytableview) {_mytableview.mj_header = header;}
    if (_mycollectionview) {_mycollectionview.mj_header = header;}
    
    if (!justheader) {
        //
        _ls_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestMoreData)];
        _ls_footer.refreshingTitleHidden = YES;
        _ls_footer.stateLabel.hidden = YES;
        _ls_footer.stateLabel.textColor = [UIColor lightGrayColor];
        _ls_footer.stateLabel.font = [UIFont systemFontOfSize:12];
        [_ls_footer setTitle:@"已无更多内容" forState:MJRefreshStateNoMoreData];
        
        if (_mytableview) {_mytableview.mj_footer = _ls_footer;}
        if (_mycollectionview) {_mycollectionview.mj_footer = _ls_footer;}
        
    }
    
}

- (void)loadRefreshViewJustFooter{
    //
    _ls_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestMoreData)];
    _ls_footer.refreshingTitleHidden = YES;
    _ls_footer.stateLabel.hidden = YES;
    _ls_footer.stateLabel.textColor = [UIColor lightGrayColor];
    _ls_footer.stateLabel.font = [UIFont systemFontOfSize:12];
    [_ls_footer setTitle:@"已无更多内容" forState:MJRefreshStateNoMoreData];
    if (_mytableview) {_mytableview.mj_footer = _ls_footer;}
    if (_mycollectionview) {_mycollectionview.mj_footer = _ls_footer;}
    
}

- (void)requestNewData{
    //
    _ls_footer.stateLabel.hidden = YES;
    self.mytableview.mj_footer.state = MJRefreshStateIdle;
    
}
- (void)requestMoreData{
    //
    _ls_footer.stateLabel.hidden = NO;
    
}

- (void)ls_headerBeginRefreshing{
    //
    if (_mytableview) {[_mytableview.mj_header beginRefreshing];}
    if (_mycollectionview) {[_mycollectionview.mj_header beginRefreshing];}
}
- (void)ls_headerEndRefreshing{
    //
    if (_mytableview) {[_mytableview.mj_header endRefreshing];}
    if (_mycollectionview) {[_mycollectionview.mj_header endRefreshing];}
}
- (void)ls_footerEndRefreshing{
    //
    if (_mytableview) {[_mytableview.mj_footer endRefreshing];}
    if (_mycollectionview) {[_mycollectionview.mj_footer endRefreshing];}
}

- (void)ls_reloadData{
    //
    if (_mytableview) {[_mytableview reloadData];}
    if (_mycollectionview) {[_mycollectionview reloadData];}
}

#pragma mark

- (void)showPlaceHolderViewWithStatus:(NSString*)status listinfo:(NSArray*)listinfo{
    
    BOOL nodata = listinfo.count < 1;
    if (!nodata) {
        [self dismissNoDataView];
        return;
    }
    [self showNoDataViewWithStatus:status];
    
}

- (void)showNoDataViewWithStatus:(NSString*)status{
    //
    
    [self dismissNoDataView];
    
    nomoredatabtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nomoredatabtn.frame = CGRectMake(0, self.mytableview.tableHeaderView.bounds.size.height+self.mytableview.tableFooterView.bounds.size.height, kSCREEN_WIDTH, 100);
    [nomoredatabtn setTitle:status forState:UIControlStateNormal];
    [nomoredatabtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    nomoredatabtn.titleLabel.font = [UIFont systemFontOfSize:12];
    if (_mytableview) {[_mytableview addSubview:nomoredatabtn];}
    if (_mycollectionview) {[_mycollectionview addSubview:nomoredatabtn];}
    
}
- (void)dismissNoDataView{
    //
    if (nomoredatabtn) {
        [nomoredatabtn removeFromSuperview];
        nomoredatabtn = nil;
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

@implementation SearchTableView
{
    UITableView* searchtableview;
}
//
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        searchtableview = [[UITableView alloc] initWithFrame:CGRectZero];
        searchtableview.dataSource = self;
        searchtableview.delegate = self;
        searchtableview.rowHeight = 60;
        [self addSubview:searchtableview];
        searchtableview.tableFooterView = [UIView new];
    }
    return self;
}

- (void)layoutSubviews{
    //
    [super layoutSubviews];
    searchtableview.frame = self.bounds;
}

- (void)setMyinfo:(NSArray *)myinfo{
    _myinfo = myinfo;
    [searchtableview reloadData];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //
    return _myinfo.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:KTableViewCellReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:KTableViewCellReuseIdentifier];
    }
    
    NSDictionary* dic = _myinfo[indexPath.row];
    
    cell.textLabel.text = [LSFactory fc_judgeObj:dic[@"text"] placeholder:@""];
    cell.detailTextLabel.text = [LSFactory fc_judgeObj:dic[@"detailtext"] placeholder:@""];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSDictionary* dic = _myinfo[indexPath.row];
    
    self.blockMySelect(dic);
    
}

@end






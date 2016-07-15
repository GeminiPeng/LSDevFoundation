//
//  LSBaseListViewController.h
//  LSDevModel2
//
//  Created by  tsou117 on 15/10/30.
//  Copyright (c) 2015年  tsou117. All rights reserved.
//

#import "LSBaseLinearViewController.h"
#import "LSHorizontalMenuView.h"
#import "CHTCollectionViewWaterfallLayout.h"

#define kSubItemBarHeight 44

typedef NS_ENUM(NSInteger,LSCollectionType) {
    
    LSCollectionTypeDefault = 0,    //默认样式 左右一样
    LSCollectionTypeFlow            //瀑布流
};

typedef NS_ENUM(NSInteger,LSRefreshType) {
    
    LSRefreshTypeDefault = 0,       //默认刷新模式，头部刷新和底部加载更多
    LSRefreshTypeJustHeader,        //仅仅有头部刷新
    LSRefreshTypeJustFooter,        //仅仅末尾加载更多
    LSRefreshTypeNo                 //不使用
};

@interface LSBaseListViewController : LSBaseLinearViewController


#pragma mark - 标签栏
@property (nonatomic, strong) LSHorizontalMenuView* subbar;

#pragma mark - 搜索相关 ...
@property (nonatomic, strong, readonly) UISearchBar* searchbar;
@property (nonatomic, strong, readonly) NSArray* searchinfo;

- (void)loadSearchBarWithTableViewBlockSelect:(void (^)(NSDictionary* selectinfo))myselect;
- (void)beginSearchView;
- (void)cancelSearchView;



#pragma mark - tableview
@property (nonatomic, strong, readonly) UITableView* mytableview;

/**
 *  显示一个tableview
 *
 *  @param style       设置为UITableViewStyleGrouped时 有效果
 *  @param refreshtype 刷新模式（0头部和底部都有 1仅仅头部 2不使用）
 */
- (void)loadTableViewWithTableViewStyle:(UITableViewStyle)style refreshStyle:(LSRefreshType)refreshtype;

#pragma mark - collectionview

@property (nonatomic, strong, readonly) UICollectionView* mycollectionview;

/**
 *  显示一个collectionview
 *
 *  @param layout        layout
 *  @param registerclass 单元类
 *  @param refreshtype   刷新模式（0头部和底部都有 1仅仅头部 2不使用）
 */
- (void)loadCollectionViewWithViewLayout:(UICollectionViewLayout*)layout registerClass:(Class)registerclass refreshStyle:(LSRefreshType)refreshtype;

#pragma mark - 刷新
//刷新实现以下方法

@property (nonatomic, strong,readonly) MJRefreshAutoNormalFooter* ls_footer;

- (void)requestNewData;
- (void)requestMoreData;

- (void)ls_headerBeginRefreshing;
- (void)ls_headerEndRefreshing;
- (void)ls_footerEndRefreshing;

- (void)ls_reloadData;

#pragma mark 无数据处理

- (void)showPlaceHolderViewWithStatus:(NSString*)status listinfo:(NSArray*)listinfo;

@end


@interface SearchTableView : UIView
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)   NSArray* myinfo;
@property (nonatomic, copy)     void(^blockMySelect)(NSDictionary* myselect);








@end






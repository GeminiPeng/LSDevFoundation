//
//  LSCellDispose.h
//  LSDevModel2
//
//  Created by  tsou117 on 15/10/14.
//  Copyright (c) 2015年  tsou117. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define LSCELLDISPOSE [LSCellDispose shareCellDispose]

#define KTableViewCellReuseIdentifier @"mytableviewcellIdentifier"
#define KCollectionViewCellReuseIdentifier @"mycollectionviewcellIdentifier"
#define KfooterIdentifier @"myfooterIdentifier"
#define KheaderIdentifier @"myheaderIdentifier"

#define KcellTypeId @"cellId"


@interface LSCellDispose : NSObject

+ (LSCellDispose*)shareCellDispose;

#pragma mark - UITableViewCell


/**
 *  处理cell
 *
 *  @param tableview  tableview
 *  @param classtring cell类
 *  @param lspace     分割线离左边间距
 *  @param rspace     分割线离右边间距
 *  @param index      xib里的index
 *
 *  @return UITableViewCell
 */
- (UITableViewCell*)disposeCellWithTableView:(UITableView*)tableview
                         cellClassFromString:(NSString*)classtring
                               leftLineSpace:(CGFloat)lspace
                                  rightSpace:(CGFloat)rspace
                                   showIndex:(NSInteger)index;

#pragma mark - UICollectionViewCell

- (UICollectionViewCell*)disposeCellWithCollectionView:(UICollectionView*)collectionview cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

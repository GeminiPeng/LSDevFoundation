//
//  LSCellDispose.m
//  LSDevModel2
//
//  Created by  tsou117 on 15/10/14.
//  Copyright (c) 2015年  tsou117. All rights reserved.
//

#import "LSCellDispose.h"
#import "LSBaseTableViewCell.h"

static LSCellDispose* __celldispose;

@implementation LSCellDispose

{
    UICollectionView* _collectionview;
    
    NSIndexPath* _indexPath;
    NSArray* _listinfo;
}

+ (LSCellDispose*)shareCellDispose{
    //
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        //
        
        __celldispose = [[LSCellDispose alloc] init];
    });
    
    return __celldispose;
}

#pragma mark - UITableViewCell

//视图是在xib里的第几个
- (UITableViewCell*)disposeCellWithTableView:(UITableView*)tableview
                         cellClassFromString:(NSString*)classtring
                               leftLineSpace:(CGFloat)lspace
                                  rightSpace:(CGFloat)rspace
                                   showIndex:(NSInteger)index{
    //
    
    if (!classtring) {
        //
        LSBaseTableViewCell* cell = [tableview dequeueReusableCellWithIdentifier:KTableViewCellReuseIdentifier];
        if (!cell) {
            cell = [[LSBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:KTableViewCellReuseIdentifier];
        }
        cell.textLabel.textColor = [UIColor darkTextColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        [self setCellSeparatorWithCell:cell leftSpace:lspace rightSpace:rspace];
        return cell;
    }
    
    UITableViewCell* cell = [tableview dequeueReusableCellWithIdentifier:KTableViewCellReuseIdentifier];
    
    if (!cell) {
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:classtring owner:nil options:nil];
        cell=[array objectAtIndex:index];
    }
    
    
    [self setCellSeparatorWithCell:cell leftSpace:lspace rightSpace:rspace];

    
    return cell;
}

- (void)setCellSeparatorWithCell:(UITableViewCell*)cell leftSpace:(CGFloat)lspace rightSpace:(CGFloat)rspace{
    
    
    
    //分割线补全
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        //
        [cell setSeparatorInset:UIEdgeInsetsMake(0, lspace, 0, rspace)];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        //
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        //
        [cell setLayoutMargins:UIEdgeInsetsMake(0, lspace, 0, rspace)];
    }
    
}

#pragma mark - UICollectionViewCell

- (UICollectionViewCell*)disposeCellWithCollectionView:(UICollectionView*)collectionview cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //
    UICollectionViewCell* cell = [collectionview dequeueReusableCellWithReuseIdentifier:KCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    
    return cell;
}

@end

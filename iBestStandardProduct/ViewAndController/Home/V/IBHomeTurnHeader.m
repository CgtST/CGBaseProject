//
//  IBHomeTurnHeader.m
//  QNApp
//
//  Created by xboker on 2017/4/20.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import "IBHomeTurnHeader.h"
#import "YHXFindHomeTurnCell.h"
//#import "IBXHelpers.h"
#import <UMAnalytics/MobClick.h>




@interface IBHomeTurnHeader()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>
@property (nonatomic, weak) IBOutlet UICollectionView       *collectionView;
@property (nonatomic, weak) IBOutlet UIPageControl          *pageC;
@property (nonatomic, strong) NSTimer                       *timer;
@property (nonatomic, strong) NSMutableArray                *turnImageArr;


@end


@implementation IBHomeTurnHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    self.collectionView.delegate = self;
    self.collectionView.dataSource  = self;
}


- (void)headerViewDisplayWithDataSource:(NSArray *)dataSource {
    [self.turnImageArr removeAllObjects];
    [self.turnImageArr addObjectsFromArray:dataSource];
    self.pageC.numberOfPages = dataSource.count;
    if (self.turnImageArr.count > 1) {
        [self timer];
        self.pageC.hidden = NO;
    }else {
        self.pageC.hidden = YES;
    }
    [self.collectionView reloadData];
}

- (void)invalidateTheTimer {
    [self.collectionView setContentOffset:CGPointMake(0, 0) animated:NO];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)activeTheTimer {
    if (self.turnImageArr.count > 1) {
        [self timer];
    }
}

- (void)layoutAction {
    [self.collectionView reloadData];
    [self layoutIfNeeded];
}


#pragma mark    UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.turnImageArr.count == 1) {
        return 1;
    }else {
        return self.turnImageArr.count + 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YHXFindHomeTurnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YHXFindHomeTurnCell" forIndexPath:indexPath];
    [cell cellDisplayWithDataSource:self.turnImageArr withIndexPath:indexPath];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.turnImageArr.firstObject isKindOfClass:[UIImage class]]) {
        return;
    }else {
        if (self.turnImageArr == nil) {
            return;
        }
        if (self.turnImageArr.count) {
            id imageDic;
            if (self.turnImageArr.count == indexPath.item) {
                 imageDic = self.turnImageArr[0];
            }else {
                 imageDic = self.turnImageArr[indexPath.item];
            }
            if ([imageDic isKindOfClass:[NSDictionary class]]) {
#pragma mark    统计首页banner点击
                NSString *markID = [IBXHelpers getStringWithDictionary:imageDic andForKey:@"id"];
                [MobClick event:@"banner_click" label:markID];
                NSString *url = [IBXHelpers getStringWithDictionary:imageDic andForKey:@"url"];
                if (url.length < 1) {
                    return;
                }
                if (self.turnImageArr.count == indexPath.item) {
                    [self.delegate ibDidSelecetImageWithUrl:[IBXHelpers getAnalysisDicWithUrl:url] withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
                }else {
                    [self.delegate ibDidSelecetImageWithUrl:[IBXHelpers getAnalysisDicWithUrl:url] withIndexPath:indexPath];
                }
            }
        }
    }
}


+ (IBHomeTurnHeader *)shareTurnHeaer {
    return [[NSBundle mainBundle] loadNibNamed:@"IBHomeTurnHeader" owner:nil options:nil].lastObject;
}


#pragma mark    UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake( [UIScreen mainScreen].bounds.size.width   , self.bounds.size.height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark    UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat offset = scrollView.contentOffset.x / ScreenWidth;
    self.pageC.currentPage = round(offset) ;
    
    if (offset  == self.turnImageArr.count) {
        [self.collectionView setContentOffset:CGPointMake(0, 0) animated:NO];
        self.pageC.currentPage = 0;
    }
    
}// called when scroll view grinds to a halt

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.turnImageArr.count > 1) {
        [self timer];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.x / ScreenWidth;
    self.pageC.currentPage = round(offset) ;
    if (offset  == self.turnImageArr.count) {
        [self.collectionView setContentOffset:CGPointMake(0, 0) animated:NO];
        self.pageC.currentPage = 0;
    }
}







#pragma mark    Case

- (NSInteger)offsetX {
    return self.collectionView.contentOffset.x / ScreenWidth;
}

- (NSMutableArray *)turnImageArr {
    if (!_turnImageArr) {
        _turnImageArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _turnImageArr;
}


- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(changeImgae) userInfo:nil repeats:YES];
    }
    return _timer;
}


- (void)changeImgae {
    
    [self.collectionView setContentOffset:CGPointMake((self.pageC.currentPage + 1) * ScreenWidth, 0) animated:YES];
    if (self.pageC.currentPage == self.turnImageArr.count ) {
        self.pageC.currentPage = 0;
    }else {
        self.pageC.currentPage ++;
    }
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

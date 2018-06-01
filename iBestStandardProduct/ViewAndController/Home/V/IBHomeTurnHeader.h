//
//  IBHomeTurnHeader.h
//  QNApp
//
//  Created by xboker on 2017/4/20.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import <UIKit/UIKit.h>





@protocol IBHomeTurnHeaderDelegate <NSObject>
@required
- (void)ibDidSelecetImageWithUrl:(NSDictionary *)paraDic withIndexPath:(NSIndexPath *)path;

@end


@interface IBHomeTurnHeader : UIView
@property (nonatomic, weak) id<IBHomeTurnHeaderDelegate>delegate;

@property (nonatomic, assign) NSInteger offsetX;


+ (IBHomeTurnHeader *)shareTurnHeaer;
- (void)headerViewDisplayWithDataSource:(NSArray *)dataSource;
- (void)invalidateTheTimer;
- (void)activeTheTimer;
- (void)layoutAction;


@end

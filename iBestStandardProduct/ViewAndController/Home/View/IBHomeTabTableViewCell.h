//
//  IBHomeTabTableViewCell.h
//  QNApp
//
//  Created by iBest on 2017/3/8.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IBHomeTabTableViewCellDelegate <NSObject>

-(void)didSeletedTabWithIndex:(NSInteger)index;

@end

@class DZNSegmentedControl;
@interface IBHomeTabTableViewCell : UITableViewCell

@property(nonatomic,assign)id<IBHomeTabTableViewCellDelegate> delegate;
@property(nonatomic,strong) DZNSegmentedControl *control;
@property(nonatomic,strong) NSArray *menuItems;

@end

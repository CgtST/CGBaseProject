//
//  IBNonOptionalTableViewCell.h
//  QNApp
//  首页--预计要使用的展示添加自选股的cell
//  Created by iBest on 2017/3/9.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IBNonOptionalTableViewCellDelegate <NSObject>

-(void)clickToAddOptionStock:(id)sender;

@end

@interface IBNonOptionalTableViewCell : UITableViewCell

@property (nonatomic,assign) id <IBNonOptionalTableViewCellDelegate> delegate;

@end

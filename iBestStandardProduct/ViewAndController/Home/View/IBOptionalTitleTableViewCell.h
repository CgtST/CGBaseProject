//
//  IBOptionalTitleTableViewCell.h
//  QNApp
//  正在用的首页展示在自选股cell上方的cell
//  Created by iBest on 2017/3/9.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IBOptionalTitleTableViewCellDelegate <NSObject>

-(void)clickButtonActionGotoOptionStock:(id)sender;

@end

@interface IBOptionalTitleTableViewCell : UITableViewCell

@property(nonatomic,assign) id<IBOptionalTitleTableViewCellDelegate> delegate;

@property(nonatomic,weak) IBOutlet UILabel *titleLabel;
@property(nonatomic,weak) IBOutlet UIButton *moreButton;

@property (weak, nonatomic) IBOutlet UIView *lineView;


@end

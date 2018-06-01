//
//  IBBusinessTableViewCell.h
//  QNApp
//
//  Created by iBest on 2017/3/8.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IBBusinessTableViewCellDelegate <NSObject>

-(void)clickBusinessButtonAction:(NSInteger)tag;

@end

@interface IBBusinessTableViewCell : UITableViewCell

@property(nonatomic,assign) id <IBBusinessTableViewCellDelegate> delegate;

@property(weak,nonatomic) IBOutlet UIButton *optionalButton;
@property(weak,nonatomic) IBOutlet UIButton *NewStockButton;
@property(weak,nonatomic) IBOutlet UIButton *funButton;
@property(weak,nonatomic) IBOutlet UIButton *bussinessButton;

@end

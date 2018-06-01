//
//  IBOptionalStockTableViewCell.h
//  QNApp
//
//  Created by iBest on 2017/3/8.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IBOptionalStockTableViewCellDelegate <NSObject>

-(void)changeTargetClickButtonAction:(id)sender;

@end

@interface IBOptionalStockTableViewCell : UITableViewCell

@property (nonatomic,assign) id <IBOptionalStockTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *marketLabel;

@property (weak,nonatomic) IBOutlet UILabel *stkCodeLabel;
@property (weak,nonatomic) IBOutlet UILabel *stkNameLabel;
@property (weak,nonatomic) IBOutlet UILabel *stkPriceLabel;
@property (weak,nonatomic) IBOutlet UIButton *zdfButton;

@end

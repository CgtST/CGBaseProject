//
//  IBMarkeActiveTableViewCell.h
//  QNApp
//  正在用的首页--展示市场动态, 财富百科, 股票评级的cell
//  Created by iBest on 2017/3/9.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IBTopLabel;
@interface IBMarkeActiveTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet IBTopLabel *m_Des;

+ (IBMarkeActiveTableViewCell *)shareCellWithTableView:(UITableView *)tableView;
///财富百科
- (void)displayPropertyCellWithData:(NSArray *)data withIndexPath:(NSIndexPath *)path withIsReadedArr:(NSArray *)readedArr;
///市场动态
- (void)displayMarketActitvityCellWithData:(NSArray *)data withIndexPath:(NSIndexPath *)path withIsReadedArr:(NSArray *)readedArr;
///股票评级
- (void)displayStockLevelCellWithData:(NSArray *)data withIndexPath:(NSIndexPath *)path withIsReadedArr:(NSArray *)readedArr;


///热门资讯
- (void)displayChoicenessInformationCellWithData:(NSArray *)data withIndexPath:(NSIndexPath *)path withIsReadedArr:(NSArray *)readedArr;




@end

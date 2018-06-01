//
//  IBXMenuChooseViewCell.h
//  QNApp
//  高度-45
//  Created by xboker on 2017/3/31.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IBXMenuChooseViewCell : UITableViewCell



+ (IBXMenuChooseViewCell *)shareCellWithTableView:(UITableView *)tableView;

/**
 资金提取时的账户                    0
 资金提取时的市场                    1
 资金提取时的收款银行                 2
 账户转账时的转出账户                 3
 账户转账时的转出市场                 4
 账户转账时的转入账户                 5
 账户转账时的转入市场                 6
 股票转仓时选择某一支股票              7
 外汇交易下单界面选择合约              8
 外汇交易下单界面选择条件期限           9
 外汇交易下单界面选择订单期限          10
 贵金属交易下单界面选择合约            11

 */
- (void)displayCellWithData:(NSArray *)data withIndexPath:(NSIndexPath *)path withType:(NSInteger)type;



@end

//
//  IBCustomChangeAccoountViewCell.h
//  QNApp
//
//  Created by xboker on 2017/4/14.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IBCustomChangeAccoountViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *m_Account;

+ (IBCustomChangeAccoountViewCell *)shareCellWithTableView:(UITableView *)tableView;
- (void)displayCellWithData:(NSArray *)data withIndexPath:(NSIndexPath *)path;


@end

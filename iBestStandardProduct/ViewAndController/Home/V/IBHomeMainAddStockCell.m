//
//  IBHomeMainAddStockCell.m
//  QNApp
//
//  Created by xboker on 2017/5/9.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import "IBHomeMainAddStockCell.h"

@interface IBHomeMainAddStockCell()
@property (weak, nonatomic) IBOutlet UILabel *m_Des;

@property (weak, nonatomic) IBOutlet UIView *m_Index;

@end


@implementation IBHomeMainAddStockCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.dk_backgroundColorPicker = DKColorPickerWithKey(QContentColor);
    self.m_Index.dk_backgroundColorPicker = DKColorPickerWithKey(SeperateLine);
    self.m_Des.text = CustomLocalizedString(@"HOME_GANGGUTOUZICONGTIANJIAZIXUANKAISHI", nil);
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

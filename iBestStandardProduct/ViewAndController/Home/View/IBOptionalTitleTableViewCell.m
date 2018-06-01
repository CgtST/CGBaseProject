//
//  IBOptionalTitleTableViewCell.m
//  QNApp
//
//  Created by iBest on 2017/3/9.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import "IBOptionalTitleTableViewCell.h"

@implementation IBOptionalTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.dk_backgroundColorPicker = DKColorPickerWithKey(QContentColor);

    // Initialization code
    [self.titleLabel setText:CustomLocalizedString(@"HOME_OPTION_STOCK", nil)];
    [self.moreButton addTarget:self action:@selector(clickMoreButton:) forControlEvents:UIControlEventTouchUpInside];
    self.lineView.dk_backgroundColorPicker  = DKColorPickerWithKey(SeperateLine);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)clickMoreButton:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(clickButtonActionGotoOptionStock:)])
    {
        [_delegate clickButtonActionGotoOptionStock:sender];
    }
}
@end

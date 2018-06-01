//
//  IBHomeMainHeader.m
//  QNApp
//  tableview的header

//  Created by xboker on 2017/4/20.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import "IBHomeMainHeader.h"

#import "UIView+Extension.h"


@interface IBHomeMainHeader()




@end

@implementation IBHomeMainHeader


#pragma mark  - InterFaceBuilderMethod

- (void)awakeFromNib {
    [super awakeFromNib];
    self.m_First.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.m_Second.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.m_Third.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.m_Fouth.titleLabel.textAlignment = NSTextAlignmentCenter;

    self.m_First.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.m_Second.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.m_Third.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.m_Fouth.imageView.contentMode = UIViewContentModeScaleAspectFit;

    self.firstLab.dk_textColorPicker = DKColorPickerWithKey(TextColor);
    self.twoLab.dk_textColorPicker = DKColorPickerWithKey(TextColor);
    self.thirdLab.dk_textColorPicker = DKColorPickerWithKey(TextColor);
    self.fouthLab.dk_textColorPicker = DKColorPickerWithKey(TextColor);
    self.frame = CGRectMake(self.x, self.y, ScreenWidth, ScreenWidth * 0.5 + 90);

    self.firstLab.text = CustomLocalizedString(@"HOME_OPTION_STOCK", nil);
    self.twoLab.text = CustomLocalizedString(@"MINEXINGUGOURU", nil);
    self.thirdLab.text = CustomLocalizedString(@"MY_PROPERTY", nil);
    self.fouthLab.text = CustomLocalizedString(@"MINEYEWUBANLI", nil);
    [self layoutSubviews];
}



- (IBAction)tapAction:(UIButton *)sender {
    [self.delegate ibHomeMainHeaderTapWithType:(HomeMainHeaderTapType)sender.tag];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)haha:(id)sender {
}

@end

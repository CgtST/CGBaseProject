//
//  IBNonOptionalTableViewCell.m
//  QNApp
//
//  Created by iBest on 2017/3/9.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import "IBNonOptionalTableViewCell.h"


@interface IBNonOptionalTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end

@implementation IBNonOptionalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.addBtn dk_setTitleColorPicker:DKColorPickerWithKey(ContentColor) forState:UIControlStateNormal];
    [self.addBtn setTitle:CustomLocalizedString(@"QTJZXGu", nil) forState:UIControlStateNormal];
     [self.addBtn setTitle:CustomLocalizedString(@"QTJZXGu", nil) forState:UIControlStateHighlighted];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)clickButtonAction:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickToAddOptionStock:)])
    {
        [self.delegate clickToAddOptionStock:sender];
    }
}
@end

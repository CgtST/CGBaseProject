//
//  IBOptionalStockTableViewCell.m
//  QNApp
//
//  Created by iBest on 2017/3/8.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import "IBOptionalStockTableViewCell.h"

@implementation IBOptionalStockTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _zdfButton.layer.masksToBounds = YES;
    _zdfButton.layer.cornerRadius = 2.f;
    
    [_zdfButton addTarget:self action:@selector(clickzdfButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)clickzdfButtonAction:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    NSLog(@"clickzdfButtonAction tag = %ld",btn.tag);
    if(_delegate && [_delegate respondsToSelector:@selector(changeTargetClickButtonAction:)])
    {
        [_delegate changeTargetClickButtonAction:btn];
    }
}
@end

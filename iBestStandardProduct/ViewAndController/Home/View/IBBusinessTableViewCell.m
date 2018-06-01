//
//  IBBusinessTableViewCell.m
//  QNApp
//
//  Created by iBest on 2017/3/8.
//  Copyright © 2017年 BaiCai. All rights reserved.
//
/*
 总结来说，就是：
 
 图片 向  右上角   移动
 
 文字 向  左下角   移动
 
 */

#define offsetY 10.f
#define ButtonWidth 60.f
#define ButtonHeight 70.f

#import "IBBusinessTableViewCell.h"

@implementation IBBusinessTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    float offset = (ScreenWidth - 28.f * 2 - ButtonWidth - ButtonWidth*3)/3;//每个按钮的间距
    _optionalButton.frame = CGRectMake(28.f, offsetY, ButtonWidth, ButtonHeight);
    _optionalButton.tag = 100;
    [_optionalButton addTarget:self action:@selector(HomePageBusinessButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _NewStockButton.frame = CGRectMake(28.f + ButtonWidth + offset, offsetY, ButtonWidth, ButtonHeight);
    _NewStockButton.tag = 101;
    [_NewStockButton addTarget:self action:@selector(HomePageBusinessButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _funButton.frame = CGRectMake(28.f +  offset*2 +ButtonWidth*2, offsetY, ButtonWidth, ButtonHeight);
    _funButton.tag = 102;
    [_funButton addTarget:self action:@selector(HomePageBusinessButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _bussinessButton.frame = CGRectMake(ScreenWidth-28.f-ButtonWidth, offsetY, ButtonWidth, ButtonHeight);
    _bussinessButton.tag = 103;
    [_bussinessButton addTarget:self action:@selector(HomePageBusinessButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)HomePageBusinessButtonAction:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    NSLog(@"HomePageBusinessButtonAction tag = %ld",btn.tag);
    if(_delegate && [_delegate respondsToSelector:@selector(clickBusinessButtonAction:)])
    {
        [_delegate clickBusinessButtonAction:btn.tag];
    }
}
@end

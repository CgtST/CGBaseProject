//
//  IBNoNetView.m
//  iBestProduct
//
//  Created by zscftwo on 2017/12/29.
//  Copyright © 2017年 iBest. All rights reserved.
//

#import "IBNoNetView.h"


@interface IBNoNetView ()
{
    noNetClickBlock _nonetBlock;
}


@end

@implementation IBNoNetView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)layoutSubviews
{
    self.frameSize = CGSizeMake(ScreenWidth, 37);
}


- (IBAction)noNetClick:(UIButton *)sender {
    if (_nonetBlock) {
        _nonetBlock();
    }
}
-(void)returnNoNetBlock:(noNetClickBlock)block
{
    _nonetBlock =  block;
}

@end
